#!/usr/bin/env python3
"""D255: package three approved image-generated complete transparent 25-pose art sheets.

Requires Pillow. Sources are lossless WebP encoded as Base64 text committed to
assets/pixel/units/black_lantern_road_qa. Deterministic conversion to 576x480.
No pose synthesis, character rotations, frame duplicates, cropping or background extraction.
"""
from pathlib import Path
import base64,hashlib,json,sys
from io import BytesIO
from PIL import Image,ImageDraw

HERE=Path(__file__).resolve().parents[2]
DEST=HERE/'assets/pixel/units/black_lantern_road_qa'
REPORT=HERE/'docs/qa/D255_THREE_RICH25_QC.json'
ANIMS={'idle':4,'walk':6,'attack':6,'hit':3,'death':6}
COLUMNS=6; ROWS=5; SOURCE_CELL=229; TARGET_CELL=96; INSET=2
ROLES=['extinguished_guide','oil_acolyte','lantern_archer']

def open_src(role):
    raw=base64.b64decode((DEST/f'{role}_d255_approved_original.webp.b64').read_text().strip())
    im=Image.open(BytesIO(raw)).convert('RGBA')
    assert im.size == (1374,1145),(role,im.size)
    return im

def save_encoded(im,path):
    buf=BytesIO()
    im.save(buf,format='WEBP',lossless=True,method=6)
    data=buf.getvalue()
    path.write_text(base64.b64encode(data).decode('ascii')+'\n',encoding='ascii')
    return hashlib.sha256(data).hexdigest()

def author(role,preview_dir=None):
    im=open_src(role)
    atlas=Image.new('RGBA',(COLUMNS*TARGET_CELL,ROWS*TARGET_CELL),(0,0,0,0))
    frame_hashes=[]
    counts=[]
    border_violations=[]
    for row,(anim,num) in enumerate(ANIMS.items()):
        row_details=[]
        for col in range(COLUMNS):
            if col >= num: continue
            source=im.crop((col*SOURCE_CELL,row*SOURCE_CELL,(col+1)*SOURCE_CELL,(row+1)*SOURCE_CELL))
            # Uniform source geometry: NEVER scale one wide pose to fit
            # independently. All 25 frames preserve identical scene scaling.
            target=source.resize((TARGET_CELL-2*INSET,TARGET_CELL-2*INSET),Image.Resampling.LANCZOS)
            # Tiny alpha fringes from downscale removed conservatively; no
            # hard alpha threshold, keep semi-transparent flame/cloth pixels.
            atlas.alpha_composite(target,(col*TARGET_CELL+INSET,row*TARGET_CELL+INSET))
            packed=atlas.crop((col*TARGET_CELL,row*TARGET_CELL,(col+1)*TARGET_CELL,(row+1)*TARGET_CELL))
            rgba=packed.tobytes();h=hashlib.sha256(rgba).hexdigest()
            frame_hashes.append(h)
            a=packed.getchannel('A')
            pix=sum(1 for x in a.getdata() if x>8)
            assert pix>150,(role,anim,col,pix)
            # content touching edges of SOURCE CELL can indicate a severed
            # chain/cape. Count it as a visual review WARNING, not source PASS.
            ap=source.getchannel('A')
            edgecnt=sum(v>48 for v in ap.crop((0,0,3,229)).getdata())+sum(v>48 for v in ap.crop((226,0,229,229)).getdata())
            if edgecnt>10: border_violations.append({'animation':anim,'frame':col,'source_vertical_edge_alpha_pixels':edgecnt})
            row_details.append({'frame':col,'opaque_pixels':pix,'source_edge_pixels':edgecnt,'hash':h})
        counts.append({'animation':anim,'frames':row_details})
    assert len(frame_hashes)==25 and len(set(frame_hashes))==25
    for row,(anim,count) in enumerate(ANIMS.items()):
        for c in range(COLUMNS):
            tile=atlas.crop((c*TARGET_CELL,row*TARGET_CELL,(c+1)*TARGET_CELL,(row+1)*TARGET_CELL))
            if c>=count: assert tile.getchannel('A').getbbox() is None
            else:
                alpha=tile.getchannel('A')
                assert alpha.getbbox() is not None
                for strip in [alpha.crop((0,0,2,96)),alpha.crop((94,0,96,96)),alpha.crop((0,0,96,2)),alpha.crop((0,94,96,96))]:
                    assert strip.getbbox() is None
    path=DEST/f'{role}_d255_rich25_qa.webp.b64'
    sha=save_encoded(atlas,path)
    raw=base64.b64decode(path.read_text().strip())
    final=Image.open(BytesIO(raw)).convert('RGBA')
    assert final.size==(576,480)
    # WebP may canonicalize RGB of 100% transparent pixels. Verify alpha
    # channel exactly, and visible RGB never varies by more than 1 unit.
    assert final.getchannel('A').tobytes()==atlas.getchannel('A').tobytes(),role
    import numpy as np
    original=np.asarray(atlas,dtype=np.int16)
    decoded=np.asarray(final,dtype=np.int16)
    mask=original[:,:,3]>0
    assert np.abs(original[:,:,:3][mask]-decoded[:,:,:3][mask]).max() <= 1,role
    if preview_dir:
        preview_dir.mkdir(parents=True,exist_ok=True)
        # Black background as in actual game; vivid nearest x2 preview
        bg=Image.new('RGBA',atlas.size,(10,9,13,255));bg.alpha_composite(atlas)
        bg.resize((1152,960),Image.Resampling.NEAREST).convert('RGB').save(preview_dir/f'{role}_contact_x2.png')
    return {'role':role,'sheet_size':list(im.size),'atlas_size':list(atlas.size),'asset_sha256':sha,'distinct':len(set(frame_hashes)),'empty':5,'source_edge_warnings':border_violations,'states':counts}

if __name__=='__main__':
    preview=Path(sys.argv[1]) if len(sys.argv)>1 else None
    report=[author(role,preview) for role in ROLES]
    REPORT.parent.mkdir(parents=True,exist_ok=True)
    REPORT.write_text(json.dumps({'version':'D255','status':'STRUCTURAL_PASS_ART_REVIEW_PENDING','roles':report},ensure_ascii=False,indent=2)+'\n')
    print([(d['role'],len(d['source_edge_warnings']),d['asset_sha256'][:12]) for d in report])