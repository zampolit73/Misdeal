"""D239: one-batch Road Sentinel atlas, 4 idle / 6 walk / 6 thrust / 3 hit / 6 death.
QA-only illustrated-source motion pass. Preserves D234 wrist-held lantern, D236R gait,
and D235 richly illustrated appearance instead of reverting to procedural D229.
"""
from __future__ import annotations
import base64, hashlib, io, json
from pathlib import Path
from PIL import Image, ImageDraw

ROOT=Path(__file__).resolve().parents[2]
DIR=ROOT/'assets/pixel/units/black_lantern_road_qa'
IDLE=DIR/'road_sentinel_d234_handheld_idle4.webp.b64'
WALK=DIR/'road_sentinel_d236r_walk6_support_cycle.webp.b64'
OUT=DIR/'road_sentinel_d239_full25_qa.webp.b64'
QC=ROOT/'docs/qa/D239_SENTINEL_FULL25_QC.json'
CELL=96
COUNTS=(4,6,6,3,6)

def read(path):
    im=Image.open(io.BytesIO(base64.b64decode(path.read_text().strip()))).convert('RGBA')
    assert im.size==(576,480), (path,im.size)
    return im

def cel(sheet,c,r):
    return sheet.crop((c*CELL,r*CELL,(c+1)*CELL,(r+1)*CELL))

def offset(image,x=0,y=0):
    result=Image.new('RGBA',(96,96));result.alpha_composite(image,(x,y))
    return result

def hold_upper(source,ground,lean=0,drop=0):
    """Painted upper/connected props lean; previously approved greaves keep foot contact."""
    fg=source.copy()
    ImageDraw.Draw(fg).rectangle((0,75,95,95),fill=(0,0,0,0))
    result=ground.copy()
    ImageDraw.Draw(result).rectangle((0,0,95,73),fill=(0,0,0,0))
    result.alpha_composite(offset(fg,lean,drop))
    return result

def thrust(idles,walks):
    # Windup -> brace -> arm/body lean -> spear tip contact -> recoil -> reset.
    # The long pointed SPEAR remains part of the painted arm, never a floating decal.
    cues=[(-1,0,1,0),(2,0,0,0),(-3,-1,2,0),(-5,-2,0,0),(-2,-1,1,0),(0,0,3,0)]
    out=[]
    for i,(dx,dy,b,g) in enumerate(cues):
        frame=hold_upper(idles[b],walks[g],dx,dy)
        d=ImageDraw.Draw(frame)
        d.line([(51+dx,42+dy),(53+dx,43+dy)],fill=(175,143,107,165),width=1)
        if i in (2,3):
            d.line([(39+dx,56+dy),(44+dx,55+dy)],fill=(142,111,80,175))
        out.append(frame)
    return out

def hit(idles,walks):
    frames=[]
    for i,(dx,dy,j) in enumerate(((2,1,1),(4,2,2),(1,0,3))):
        frame=hold_upper(idles[j],walks[(i+2)%6],dx,dy)
        if i<2:
            ImageDraw.Draw(frame).line([(62+dx,37+dy),(65+dx,39+dy)],
                                        fill=(154,71,58,185))
        frames.append(frame)
    return frames

def death(idles,walks):
    # Stagger, buckle, tip, impact, settle: six separate body transformations.
    steps=((0,1,0,0),(15,-2,1,1),(32,-2,0,2),
           (58,-2,0,3),(80,-1,2,4),(88,0,1,5))
    result=[]
    for angle,xoff,index,stage in steps:
        src=walks[stage%6] if stage<2 else idles[index]
        if angle==0:
            pose=offset(src,xoff,0)
        else:
            tilted=src.rotate(angle,Image.Resampling.NEAREST,expand=True)
            bbox=tilted.getchannel('A').getbbox()
            assert bbox is not None
            tilted=tilted.crop(bbox)
            maxh=88 if stage<4 else 69
            factor=min(1.0,88/tilted.width,maxh/tilted.height)
            if factor<1:
                tilted=tilted.resize((max(1,round(tilted.width*factor)),
                                    max(1,round(tilted.height*factor))),Image.Resampling.NEAREST)
            pose=Image.new('RGBA',(96,96))
            pose.alpha_composite(tilted,((96-tilted.width)//2+xoff,92-tilted.height))
        result.append(pose)
    return result

def main():
    source_idle=read(IDLE);source_walk=read(WALK)
    idles=[cel(source_idle,i,0) for i in range(4)]
    walks=[cel(source_walk,i,1) for i in range(6)]
    states=[idles,walks,thrust(idles,walks),hit(idles,walks),death(idles,walks)]
    atlas=Image.new('RGBA',(576,480))
    report={'stage':'D239 ONE full 25-frame illustrated-source Sentinel QA pack',
       'state_names':['idle','walk','attack','hit','death'],
       'state_counts':list(COUNTS),'size':[576,480],'cell':[96,96],
       'sources':[str(IDLE.relative_to(ROOT)),str(WALK.relative_to(ROOT))],
       'source_notes':'D234 connected gauntlet lantern, D236R user-accepted 6-step feet, D235 rich look',
       'method':'composited illustrated body + planted support boots; distinct thrust/hit/collapse staging',
       'fully_independently_repainted_bodies':False,
       'native_godot_pass':False,'live_game_integrated':False,'frames':[]}
    signatures=set()
    for r,frames in enumerate(states):
        assert len(frames)==COUNTS[r]
        for c,frame in enumerate(frames):
            bbox=frame.getchannel('A').getbbox()
            assert bbox and bbox[0]>=2 and bbox[1]>=2 and bbox[2]<=94 and bbox[3]<=94, (r,c,bbox)
            signature=hashlib.sha256(frame.tobytes()).hexdigest()
            assert signature not in signatures,('duplicate',r,c)
            signatures.add(signature)
            atlas.alpha_composite(frame,(c*96,r*96))
            report['frames'].append({'row':r,'col':c,'bbox':bbox,'sha256':signature})
    for r in range(5):
        for c in range(COUNTS[r],6):
            assert cel(atlas,c,r).getchannel('A').getbbox() is None,(r,c)
    assert len(signatures)==25
    raw=io.BytesIO();atlas.save(raw,format='WEBP',lossless=True,method=6)
    image_bytes=raw.getvalue()
    assert Image.open(io.BytesIO(image_bytes)).convert('RGBA').tobytes()==atlas.tobytes()
    report.update({'unique_poses':25,'transparent_unused':5,'safe_inset_px':2,
                   'atlas_sha256':hashlib.sha256(image_bytes).hexdigest()})
    OUT.write_text(base64.b64encode(image_bytes).decode()+'\n')
    QC.parent.mkdir(parents=True,exist_ok=True)
    QC.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
    print('D239 25 unique / 5 clear, atlas bytes',len(image_bytes),report['atlas_sha256'])

if __name__=='__main__':
    main()
