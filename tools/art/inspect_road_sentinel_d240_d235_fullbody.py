"""D240 internal art-source probe: isolate SIX genuine full-body D235 illustrated poses.

The D235 source contains painted legs with correct armor, unlike the unrelated
geometric shin/boot rig in D236R/D239. This is ONLY a matte/pose feasibility
probe, not final 25-cel art and must NEVER be promoted to production as-is.
Requires Pillow, numpy, opencv-python-headless.
"""
from __future__ import annotations
from PIL import Image
import numpy as np
import cv2, io, base64, json, hashlib
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
ASSETS=ROOT/'assets/pixel/units/black_lantern_road_qa'
SRC=ASSETS/'road_sentinel_d235_approved_walk_concept_q95.webp.b64'
OUT=ASSETS/'road_sentinel_d240_d235_original_legs_source_probe.webp.b64'
QC=ROOT/'docs/qa/D240_D235_FULLBODY_SOURCE_PROBE.json'
original=Image.open(io.BytesIO(base64.b64decode(SRC.read_text().strip()))).convert('RGB')
assert original.size==(1536,1024),original.size
atlas=Image.new('RGBA',(576,480),(0,0,0,0))
diagnostics=[]

def extract(panel,idx):
    raw=np.asarray(panel)
    bgr=cv2.cvtColor(raw,cv2.COLOR_RGB2BGR)
    mask=np.full((512,512),cv2.GC_PR_BGD,np.uint8)
    # Hand-authored broad anatomical silhouettes across six approved full
    # illustrations: tip/shaft, hood+torso+cloak, two extended real greaves,
    # and lantern physically held by the free hand.
    outer=np.zeros((512,512),dtype=np.uint8)
    whole=np.array([(205,106),(255,85),(316,105),(358,145),
         (431,206),(509,252),(507,387),(465,435),(436,490),
         (365,500),(337,467),(319,412),(279,459),(262,507),
         (137,507),(135,460),(177,401),(195,355),(208,294),
         (192,237)],np.int32)
    cv2.fillPoly(outer,[whole],255)
    cv2.line(outer,(83,35),(284,340),255,32)
    cv2.line(outer,(76,30),(135,116),255,45)
    cv2.ellipse(outer,(352,373),(64,104),0,0,360,255,-1)
    cv2.dilate(outer,cv2.getStructuringElement(cv2.MORPH_ELLIPSE,(11,11)),dst=outer)
    mask[outer==0]=cv2.GC_BGD
    # Anatomical certainties ensure the highly shaded cloak and iron aren't
    # mistaken for the soft dark gradient background.
    fg=np.zeros_like(outer)
    cv2.ellipse(fg,(278,175),(38,49),0,0,360,255,-1)
    cv2.ellipse(fg,(321,271),(53,83),0,0,360,255,-1)
    cv2.ellipse(fg,(346,350),(44,32),0,0,360,255,-1)
    cv2.ellipse(fg,(224,460),(41,15),0,0,360,255,-1)
    cv2.ellipse(fg,(405,457),(34,13),0,0,360,255,-1)
    cv2.ellipse(fg,(340,392),(17,27),0,0,360,255,-1)
    cv2.line(fg,(91,52),(201,215),255,4)
    # Inexact sure foreground seeds stay probable if outside broad silhouette.
    mask[(fg>0)&(outer>0)]=cv2.GC_FGD
    bg_model=np.zeros((1,65),np.float64)
    fg_model=np.zeros((1,65),np.float64)
    cv2.grabCut(bgr,mask,None,bg_model,fg_model,6,cv2.GC_INIT_WITH_MASK)
    binary=np.where((mask==cv2.GC_FGD)|(mask==cv2.GC_PR_FGD),255,0).astype(np.uint8)
    # Remove tiny islands. Preserve fragile spear shaft and cloak tattering.
    count, labels, stats,_=cv2.connectedComponentsWithStats(binary,8)
    keep=np.zeros_like(binary)
    for j in range(1,count):
        if stats[j,cv2.CC_STAT_AREA]>=22:
            keep[labels==j]=255
    rgba=np.dstack((raw,keep))
    mask_canvas=Image.fromarray(rgba,'RGBA')
    bbox=mask_canvas.getchannel('A').getbbox()
    assert bbox is not None,(idx,'empty')
    # Each cel keeps the complete figure, not just trousers.
    crop=mask_canvas.crop(bbox)
    scale=min(82/crop.width,86/crop.height)
    w=max(1,round(crop.width*scale));h=max(1,round(crop.height*scale))
    sprite=crop.resize((w,h),Image.Resampling.LANCZOS)
    output=Image.new('RGBA',(96,96),(0,0,0,0))
    output.alpha_composite(sprite,((96-w)//2,93-h))
    pixels=np.asarray(output)
    bbox96=output.getchannel('A').getbbox()
    checksum=hashlib.sha256(output.tobytes()).hexdigest()
    return output, {'pose':idx,'source_bbox':list(bbox),
        'game_bbox':list(bbox96),'foreground_px':int(np.count_nonzero(keep)),
        'source_components':int(count-1),'signature':checksum}

for i in range(6):
    panel=original.crop(((i%3)*512,(i//3)*512,(i%3+1)*512,(i//3+1)*512))
    frame,stats=extract(panel,i)
    atlas.alpha_composite(frame,(i*96,96))
    diagnostics.append(stats)
assert len(set(x['signature'] for x in diagnostics))==6
webp=io.BytesIO();atlas.save(webp,format='WEBP',lossless=True,method=6)
OUT.write_text(base64.b64encode(webp.getvalue()).decode()+'\n')
QC.parent.mkdir(parents=True,exist_ok=True)
QC.write_text(json.dumps({'stage':'D240 MATTE PROBE, NOT APPROVED ART',
 'source':str(SRC.relative_to(ROOT)),'poses':diagnostics,
 'canvas':[576,480],'author_art_method':'D235 original six full painted bodies, iterative GrabCut',
 'native_godot_pass':False,'game_integrated':False,
 'sha256':hashlib.sha256(webp.getvalue()).hexdigest()},indent=2)+'\n')
print('D240 source matte probe saved',OUT,'pose stats',diagnostics)
