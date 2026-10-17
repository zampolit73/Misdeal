"""D234 one-illustration cutout proof: wrist-anchored lantern in FOUR idle cels only.
Rebuilds from versioned D232 cutout, not from screenshots or a fake generated sheet.
Outputs 576x480 RGBA 6x5 grid with 4 true idle image variants / 26 CLEAR slots.
Production/combat source remains technical D229 until a real 25-cel repaint is approved.
Run from the repository or pass repository path as first argument; out directory second.
"""
from __future__ import annotations
from PIL import Image, ImageDraw, ImageChops
from pathlib import Path
import base64, io, hashlib, json, sys

ROOT = Path(sys.argv[1]).resolve() if len(sys.argv)>1 else Path(__file__).resolve().parents[2]
OUT = Path(sys.argv[2]).resolve() if len(sys.argv)>2 else Path.cwd()/"d234_hand_lantern"
OUT.mkdir(parents=True,exist_ok=True)
SOURCE = ROOT/'assets/pixel/units/black_lantern_road_qa/road_sentinel_d232_reference_cutout.webp.b64'
SRC = Image.open(io.BytesIO(base64.b64decode(SOURCE.read_text().strip()))).convert('RGBA')
assert SRC.size == (115,129)
W,H=SRC.size

def poly_alpha(points):
    poly = Image.new('L', SRC.size, 0)
    ImageDraw.Draw(poly).polygon(points,fill=255)
    return ImageChops.multiply(poly, SRC.getchannel('A'))

def cutout(mask):
    layer=SRC.copy(); layer.putalpha(mask); return layer

# The original illustrated lantern hangs at x~54 around the KNEE, far away
# from the right gauntlet at x~83 y~79. Mask it out completely and re-position
# it next to the RIGHT hand, never animating it independently of the wrist pivot.
LANTERN_MASK=poly_alpha([(45,82),(54,81),(64,84),(68,91),(68,112),(64,116),(44,116),(41,110),(41,92)])
CLOAK_MASK=poly_alpha([(90,75),(97,82),(101,90),(114,97),(114,106),(109,113),(107,120),(96,113),(89,102)])
# Paint over source lamp hole with warm-dark, interrupted rust-cloth texture.
# Keep silhouette and legs intact; lamp is the only relocated piece.
BODY = SRC.copy()
bd=BODY.load(); am=LANTERN_MASK.load();cm=CLOAK_MASK.load()
for y in range(H):
    for x in range(W):
        if am[x,y] or cm[x,y]: bd[x,y]=(0,0,0,0)

UNDER = Image.new('RGBA',SRC.size,(0,0,0,0))
# Replace the vacated lamp shape with genuine dark-burgundy fabric TEXTURE from
# another portion of THIS same illustrated robe, mirrored to drape under belt.
# No giant flat rectangular patch: carry through original ragged alpha edges.
robe_donor=SRC.crop((89,76,114,117)).transpose(Image.Transpose.FLIP_LEFT_RIGHT)
UNDER.alpha_composite(robe_donor,(42,80))
# Only 2 thin shadow folds, under existing surface geometry.
d=ImageDraw.Draw(UNDER)
d.line([(55,84),(54,95),(50,109)],fill=(66,36,34,115),width=1)
d.line([(61,84),(63,98),(58,115)],fill=(26,16,18,145),width=2)
d.line([(27,36),(45,79)],fill=(78,47,29,235),width=3) # spear remains joined

def shift(layer,dx,dy):
    out=Image.new('RGBA',(W,H),(0,0,0,0));out.alpha_composite(layer,(dx,dy));return out

LAMP=cutout(LANTERN_MASK)
CLOAK=cutout(CLOAK_MASK)
# Mask of the gauntlet that will overlap the lantern attachment. It stays
# connected to the original forearm and always renders IN FRONT of the handle.
WRIST_MASK=poly_alpha([(77,73),(87,71),(93,79),(90,86),(79,89),(74,83)])
WRIST=cutout(WRIST_MASK)

# Visible, continuous wrist-to-lamp construction at high-res source pixels:
# right-hand knuckles around (82,80); a short wrought-iron hanger under them,
# ring joining lantern crown centered on x~82 near y~90. Lamp is intentionally
# on same side of body as its holding hand, rather than crossing to other knee.
# Target +28/+5 translates original illustrated lantern center near x54 to x82.
# Tiny 1px sway allowed only around hand anchor, hinge repainted each frame.
PHASES=[(0,0,0,0,0.98),(1,0,1,-1,1.06),(1,1,-1,0,1.00),(0,1,0,1,0.95)]
FRAMES=[]; VALID=[]
for i,(lamp_x, lamp_y,cloak_dx,cloak_dy,glow) in enumerate(PHASES):
    frame=Image.new('RGBA',(W,H),(0,0,0,0))
    frame.alpha_composite(UNDER)
    frame.alpha_composite(shift(CLOAK,cloak_dx,cloak_dy))
    frame.alpha_composite(BODY)
    # The lantern is suspended from an iron D-ring *at the gauntlet*, not
    # free-floating: connect every small swing to the stationary wrist pivot.
    hardware=Image.new('RGBA',(W,H),(0,0,0,0));hd=ImageDraw.Draw(hardware)
    anchor=(82,82)
    # Original lantern cap x~54 y~86, after move dx=28+lamp_x, dy=5+lamp_y
    crown=(82+lamp_x,91+lamp_y)
    hd.line([anchor,(83,85),crown], fill=(27,22,20,255),width=4)
    hd.line([anchor,(83,85),crown], fill=(151,118,70,255),width=2)
    hd.line([(79,83),(79,86),(83+lamp_x,89+lamp_y),(86+lamp_x,87+lamp_y)], fill=(195,153,93,242),width=1)
    hd.ellipse((78,77,87,85),outline=(45,31,27,255),width=2)
    hd.point((80,80),fill=(201,168,120,255))
    frame.alpha_composite(hardware)
    ll=shift(LAMP,28+lamp_x,5+lamp_y)
    pixels=ll.load()
    for yy in range(90,118):
        for xx in range(71,99):
            r,g,b,a=pixels[xx,yy]
            if a>30 and r>120 and g>35 and r>b*1.55:
                pixels[xx,yy]=(min(255,round(r*glow)),min(255,round(g*glow)),min(255,round(b*glow)),a)
    frame.alpha_composite(ll)
    # Forearm-and-hand overlap: show gloved fist around the short lantern grip.
    frame.alpha_composite(WRIST)
    # Tiny knuckle glints emphasize a real hand-to-handle junction.
    detail=Image.new('RGBA',(W,H),(0,0,0,0));dd=ImageDraw.Draw(detail)
    dd.line([(79,78),(82,80),(84,82)],fill=(149,131,99,245),width=2)
    dd.line([(82,81),(83,86)],fill=(85,61,37,255),width=1)
    frame.alpha_composite(detail)

    # Exact same source crop/nearest as D233, 2px safe buffer.
    canvas=Image.new('RGBA',(96,96),(0,0,0,0))
    sample=frame.crop((8,10,114,127)).resize((78,86),Image.Resampling.NEAREST)
    canvas.alpha_composite(sample,(9,5))
    bbox=canvas.getchannel('A').getbbox()
    assert bbox and bbox[0]>=2 and bbox[1]>=2 and bbox[2]<=94 and bbox[3]<=94,(i,bbox)
    FRAMES.append(canvas)
    VALID.append({'frame':i,'bbox':list(bbox),'arm_anchor_src':[82,82],'lamp_crown_src':list(crown),'handle_connected':abs(crown[0]-82)<=1 and 8<=crown[1]-82<=10})

assert len({hashlib.sha256(im.tobytes()).hexdigest() for im in FRAMES})==4
atlas=Image.new('RGBA',(576,480),(0,0,0,0))
for i,im in enumerate(FRAMES): atlas.alpha_composite(im,(i*96,0))
# Verify all 26 remaining cells alpha completely blank.
for row in range(5):
    for col in range(6):
        cell=atlas.crop((col*96,row*96,col*96+96,row*96+96))
        if row==0 and col<4: assert cell.getbbox()
        else: assert not cell.getbbox(),(row,col)
atlas.save(OUT/'road_sentinel_d234_handheld_idle4.png',optimize=True)
atlas.save(OUT/'road_sentinel_d234_handheld_idle4.webp',format='WEBP',lossless=True,method=6)
bts=(OUT/'road_sentinel_d234_handheld_idle4.webp').read_bytes()
(OUT/'road_sentinel_d234_handheld_idle4.webp.b64').write_text(base64.b64encode(bts).decode())
decoded=Image.open(io.BytesIO(bts)).convert('RGBA');assert decoded.tobytes()==atlas.tobytes()
# Review before/after contact sheet at real pixels enlarged exactly 4x.
old_b64=ROOT/'assets/pixel/units/black_lantern_road_qa/road_sentinel_d233_idle4_cutout_proof.webp.b64'
old=Image.open(io.BytesIO(base64.b64decode(old_b64.read_text().strip()))).convert('RGBA') if old_b64.exists() else None
poster=Image.new('RGB',(8*288+9*14,390),(20,22,28));dp=ImageDraw.Draw(poster)
for section,atl in enumerate([old,atlas]):
    if atl is None:continue
    dp.text((section*4*302+32,14),'D233 no visible grip' if section==0 else 'D234 gauntlet holds lamp',fill=(232,214,181))
    for i in range(4):
        tile=atl.crop((i*96,0,(i+1)*96,96))
        im=tile.resize((288,288),Image.Resampling.NEAREST)
        x=(section*4+i)*302+18
        poster.paste(im,(x,40),im)
        dp.text((x+80,345),f'Idle {i+1}/4',fill=(196,192,178))
poster.save(OUT/'D234_D233_before_after_idles.png')
# Optional source-scale QA images with precise wrist→handle closeup, no fake atlas.
big=FRAMES[0].resize((576,576),Image.Resampling.NEAREST)
bg=Image.new('RGB',big.size,(35,35,39));bg.paste(big,mask=big.getchannel('A'));bg.save(OUT/'D234_hand_lantern_96px_x6.png')
report={'stage':'D234 four idle ONLY, fixed visible wrist-to-lantern link', 'atlas_size':[576,480],'used_idle_frames':4,'transparent_unused_cells':26,'frame_qc':VALID,'frame_hashes':[hashlib.sha256(im.tobytes()).hexdigest() for im in FRAMES],'pixel_unique_frames':4,'edge_faults':[],'original_image_source':'D232 rich-source illustrated SINGLE character; D233 layer rig modified, no 21 original walk/attack/hit/death frames','source_hand_anchor':[82,82],'repositioned_lamp_crown':[82,91],'webp_sha256':hashlib.sha256(bts).hexdigest(),'production_installed':False,'native_godot_pass':False}
(OUT/'D234_HAND_LANTERN_IDLE_QC.json').write_text(json.dumps(report,ensure_ascii=False,indent=2))
print(json.dumps({'atlas_bytes':len(bts),'sha':report['webp_sha256'],'checks':VALID,'source':str(SOURCE)},ensure_ascii=False))