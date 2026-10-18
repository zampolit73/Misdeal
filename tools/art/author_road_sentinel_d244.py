"""D244: extract 25 individually illustrated Sentinel poses from one transparent generation.

Source shows original whole-body artwork in 6x5 panels at 229px grid; many poses
cross nominal grid edges (e.g. extended spear). Do NOT blindly tile-crop it.
Each character is a connected alpha island; isolate all 25 whole characters first,
then shrink to 96x96 while preserving floor alignment, lantern, spear and silhouette.
This is offline art preparation, not runtime procedural character generation.
"""
from __future__ import annotations
from pathlib import Path
from PIL import Image
import base64, hashlib, io, json

ROOT = Path(__file__).resolve().parents[2]
QA_DIR = ROOT/'assets/pixel/units/black_lantern_road_qa'
SOURCE = QA_DIR/'road_sentinel_d244_illustrated_source.webp.b64'
ART = QA_DIR/'road_sentinel_d244_illustrated25_qa.webp.b64'
QC = ROOT/'docs/qa/D244_SENTINEL_ILLUSTRATED_QC.json'
PREVIEW = ROOT/'docs/qa/D244_SENTINEL_ILLUSTRATED_PREVIEW.png'
COUNTS=(4,6,6,3,6)
NAMES=('idle','walk','attack','hit','death')
NATIVE=96
SRC_CELL=229


def load_image(path):
    return Image.open(io.BytesIO(base64.b64decode(path.read_text().strip()))).convert('RGBA')


def components(mask, width, height, minimum=2000):
    # Pure Python, 8-connected alpha segmentation. Source images have four/six/three
    # large isolated character islands on each animation strip.
    pixels=mask.tobytes(); visited=bytearray(width*height); results=[]
    for seed in range(width*height):
        if visited[seed] or pixels[seed]<24:
            continue
        visited[seed]=1
        stack=[seed]; indices=[];xmin=width;ymin=height;xmax=ymax=0
        while stack:
            i=stack.pop(); indices.append(i); y,x=divmod(i,width)
            if x<xmin:xmin=x
            if x>xmax:xmax=x
            if y<ymin:ymin=y
            if y>ymax:ymax=y
            for yy in range(max(0,y-1),min(height-1,y+1)+1):
                lo=yy*width
                for xx in range(max(0,x-1),min(width-1,x+1)+1):
                    p=lo+xx
                    if not visited[p] and pixels[p]>=24:
                        visited[p]=1;stack.append(p)
        if len(indices)>=minimum:
            results.append((indices,(xmin,ymin,xmax+1,ymax+1)))
    return sorted(results,key=lambda c:(c[1][0]+c[1][2])/2)


def extract_islands(src):
    assert src.size==(1374,1145)
    all_frames=[]
    for ri,count in enumerate(COUNTS):
        row=src.crop((0,ri*SRC_CELL,src.width,(ri+1)*SRC_CELL))
        comps=components(row.getchannel('A'),row.width,row.height)
        if len(comps)!=count:
            raise AssertionError(f'row={ri}: expected {count} substantial whole sprites, got {len(comps)}')
        frames=[]
        for ci,(indices,bb) in enumerate(comps):
            data=bytearray(row.width*row.height)
            for p in indices: data[p]=255
            mask=Image.frombytes('L',row.size,bytes(data))
            separated=Image.new('RGBA',row.size);separated.paste(row,(0,0),mask)
            frames.append((separated.crop(bb),bb))
        all_frames.append(frames)
    return all_frames


def attack_foreshorten(sprite, ci, bb):
    """Only shorten thin left-pointing spear, NEVER scale/rotate body, legs or cloak.

    A real upright Sentinel occupies ~200px high. Two long lunges occupy >300px
    wide: their spear tips would protrude outside 96px without localized perspective
    foreshortening. Retain individually illustrated full body unscaled at base ratio.
    """
    if ci not in (2,3):return sprite
    w,h=sprite.size
    # Attack 2: shaft at row-local y~93, held point at absolute x~520.
    # Attack 3: shaft at row-local y~101, held point at absolute x~815.
    hand_source_x=(522 if ci==2 else 820)-bb[0]
    # Robustly mask only the thin spear pixels to the LEFT of its holding hand.
    # Spear occupies only a narrow y band (the figure's bent leg remains intact).
    band=(80,122) if ci==2 else (91,124)
    tip_length_new=65 if ci==2 else 73
    if hand_source_x<5 or hand_source_x>=w:return sprite
    band_mask=Image.new('L',(w,h));
    from PIL import ImageDraw
    md=ImageDraw.Draw(band_mask);md.rectangle((0,max(0,band[0]-bb[1]),hand_source_x,min(h,band[1]-bb[1])),fill=255)
    spear=Image.new('RGBA',(w,h));spear.paste(sprite,(0,0),band_mask)
    base=Image.new('RGBA',(w,h));base.alpha_composite(sprite)
    # Zero those isolated spear pixels and repaint them closer to its hand.
    base.paste((0,0,0,0),(0,0,w,h),band_mask)
    target_w=min(hand_source_x,tip_length_new)
    if target_w>=hand_source_x:return sprite
    spear=spear.crop((0,0,hand_source_x,h))
    stretched=spear.resize((target_w,h),Image.Resampling.BICUBIC)
    base.alpha_composite(stretched,(hand_source_x-target_w,0))
    return base


def pack_frame(sprite, stage, ci, bb):
    # Physical scale stays constant across poses (incl corpse); don't normalize
    # individual bbox heights to 90px because this fakes giant dead bodies.
    if stage=='attack':
        sprite=attack_foreshorten(sprite,ci,bb)
        bounds=sprite.getchannel('A').getbbox()
        assert bounds
        sprite=sprite.crop(bounds)
    # Retain base horizontal/vertical 0.4 native ratio unless very long corpse.
    scale=.385
    max_size=92
    if sprite.width*scale>max_size:scale=max_size/sprite.width
    if sprite.height*scale>max_size:scale=max_size/sprite.height
    w=max(1,int(sprite.width*scale+.5));h=max(1,int(sprite.height*scale+.5))
    # Crisp source silhouettes at native budget, no upscaling.
    cell=Image.new('RGBA',(NATIVE,NATIVE))
    small=sprite.resize((w,h),Image.Resampling.LANCZOS)
    # Keep source centering at final bounds, not original panel x coordinates.
    # Some attacks have asymmetric spear extension; balance weapon + body.
    x=max(2,(NATIVE-w)//2)
    y=92-h
    cell.alpha_composite(small,(x,y))
    return cell


def build():
    source=load_image(SOURCE)
    assert source.size==(1374,1145),source.size
    island_sets=extract_islands(source)
    atlas=Image.new('RGBA',(NATIVE*6,NATIVE*5))
    reports=[];seen=set()
    for ri,(state,frame_list) in enumerate(zip(NAMES,island_sets)):
        for ci,(src,bb) in enumerate(frame_list):
            cel=pack_frame(src,state,ci,bb)
            box=cel.getchannel('A').getbbox()
            assert box and box[0]>=2 and box[1]>=2 and box[2]<=94 and box[3]<=94,(state,ci,box)
            assert sum(p>80 for p in cel.getchannel('A').tobytes())>=80,(state,ci)
            sha=hashlib.sha256(cel.tobytes()).hexdigest()
            assert sha not in seen,(state,ci,'duplicate')
            seen.add(sha);atlas.alpha_composite(cel,(ci*NATIVE,ri*NATIVE))
            reports.append({'state':state,'column':ci,'source_bbox':bb,'packed_bbox':box,'sha256':sha})
    for ri,count in enumerate(COUNTS):
        for ci in range(count,6):
            assert not atlas.crop((ci*NATIVE,ri*NATIVE,(ci+1)*NATIVE,(ri+1)*NATIVE)).getchannel('A').getbbox()
    assert len(seen)==25
    # Normalize invisible RGB to zero: WebP does not preserve colors at alpha=0.
    raw=bytearray(atlas.tobytes())
    for i in range(0,len(raw),4):
        if raw[i+3]==0:raw[i]=raw[i+1]=raw[i+2]=0
    atlas=Image.frombytes('RGBA',atlas.size,bytes(raw))
    b=io.BytesIO();atlas.save(b,'WEBP',lossless=True,method=4,exact=True)
    assert Image.open(io.BytesIO(b.getvalue())).convert('RGBA').tobytes()==atlas.tobytes()
    ART.parent.mkdir(parents=True, exist_ok=True)
    QC.parent.mkdir(parents=True, exist_ok=True)
    ART.write_text(base64.b64encode(b.getvalue()).decode()+'\n')
    atlas.save(PREVIEW)
    QC.write_text(json.dumps({'stage':'D244 original illustrated animation from 25 transparent full-body painted poses',
        'authoring':'connected alpha island extraction from transparent 6x5 original source; see script',
        'stage_status':'QA candidate only; user native F6 PENDING, visual approval PENDING',
        'counts':list(COUNTS),'filled_cels':25,'empty_cels':5,
        'source_original_png_hash':'660732bb24435e51756741793ec7167aeebddf0466e8565b29eb3ab408eb9f06',
        'source_b64_sha256':hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
        'atlas_webp_sha256':hashlib.sha256(b.getvalue()).hexdigest(),
        'frame_info':reports},indent=2)+'\n')
    print('D244',len(b.getvalue()),'bytes',hashlib.sha256(b.getvalue()).hexdigest())

if __name__=='__main__':build()