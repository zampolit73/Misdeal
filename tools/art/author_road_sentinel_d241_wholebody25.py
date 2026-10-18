"""D241 whole-body illustrated-source animation prototype (NOT final approved art).

D240 extracted real D235 full figures and armored legs; D239 used foreign-looking
Pillow-generated boots. Here all 25 states use complete illustrated original
legs. Reconstruct one matching long SPEAR from D234 original painted pixels.
Validate atlas layout and export reproducible QA art, never change live #38.
"""
from __future__ import annotations
from PIL import Image, ImageDraw
import base64,hashlib,io,json,math
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
ART=ROOT/'assets/pixel/units/black_lantern_road_qa'
SRC=ART/'road_sentinel_d240_d235_original_legs_source_probe.webp.b64'
SPEAR_SRC=ART/'road_sentinel_d234_handheld_idle4.webp.b64'
OUTPUT=ART/'road_sentinel_d241_wholebody25_qa.webp.b64'
QC=ROOT/'docs/qa/D241_SENTINEL_WHOLEBODY_QC.json'
COUNTS=[4,6,6,3,6];ROWS=['idle','walk','attack','hit','death']
def load(path):
    art=Image.open(io.BytesIO(base64.b64decode(path.read_text().strip()))).convert('RGBA')
    assert art.size==(576,480)
    return art
def tile(sheet,col,row):
    return sheet.crop((col*96,row*96,(col+1)*96,(row+1)*96))
walk_source=load(SRC)
d234=load(SPEAR_SRC)
raw_walks=[tile(walk_source,i,1) for i in range(6)]
# D234 long pointed spear is the SAME accepted illustrated Sentinel weapon.
# Mask excludes gauntlet/face; blade and shaft painted pixels come from art.
painted_spear=Image.new('RGBA',(96,96))
d=ImageDraw.Draw(painted_spear)
# Use source weapon shaped from original illustration rather than flat shaft.
weapon_mask=Image.new('L',(96,96));m=ImageDraw.Draw(weapon_mask)
m.line([(15,10),(37,49)],fill=255,width=9)
m.polygon([(7,3),(27,3),(30,19),(22,24),(12,16)],fill=255)
m.ellipse((32,43,41,53),fill=255)
weapon_src=tile(d234,0,0)
painted_spear.paste(weapon_src,(0,0),weapon_mask)

# Source full-body walkers already carry spears, but the D235 matte removed
# original thin edges for some poses. Mask only the weapon shaft/tip, then
# overlay the D234 full original point with a single character-hand pivot.
def rotate_grip(image,angle,pivot=(36,48),shift=(0,0)):
    # rotate in visual screen coordinates around the hand, not cell center
    big=Image.new('RGBA',(256,256))
    off=(128-pivot[0],128-pivot[1])
    # A 96px cel cannot fit a fully horizontal original long spear.
    # Temporarily foreshorten only during the advanced forward attack poses,
    # keeping its actual illustrated pixel art and the same hand pivot.
    factor=(0.52 if angle>40 else (0.59 if angle>26 else (0.65 if angle>16 else 1.0)))
    if factor < 1.0:
        new_size=(round(96*factor),round(96*factor))
        image=image.resize(new_size,Image.Resampling.LANCZOS)
        off=(128-round(pivot[0]*factor),128-round(pivot[1]*factor))
    big.alpha_composite(image,off)
    # pillow's +deg rotates visually from raised NW to forward-left.
    big=big.rotate(angle,resample=Image.Resampling.BICUBIC,expand=False)
    canvas=Image.new('RGBA',(96,96))
    # World-space hand pivot stays x36,y48 after angular foreshortening.
    canvas.alpha_composite(big,(-128+pivot[0]+shift[0],-128+pivot[1]+shift[1]))
    return canvas
def undress_weapon(src):
    body=src.copy()
    mask=Image.new('L',(96,96));d=ImageDraw.Draw(mask)
    d.line([(16,9),(35,45)],fill=255,width=10)
    d.polygon([(6,2),(27,2),(29,19),(22,27),(11,17)],fill=255)
    # Constrain removal to left of gauntlet and below skull to protect body.
    body.paste((0,0,0,0),(0,0,96,96),mask)
    return body
def render(base,angle=0,lean=(0,0),glow=0):
    body=undress_weapon(base)
    out=Image.new('RGBA',(96,96))
    out.alpha_composite(body,lean)
    out.alpha_composite(rotate_grip(painted_spear,angle,shift=lean))
    # Restore the illustrated hand on top of the spear's held shaft.
    gloved=base.crop((33,42,42,56))
    out.alpha_composite(gloved,(33+lean[0],42+lean[1]))
    # Tiny carried-light variation is tied to body; no independent lamp jump.
    if glow:
        pass
    return out

def ground_rotate(image,angle,dx=0,limit_h=87):
    # A physically staged collapse: rotate WHOLE original figure/greaves
    # then anchor the lowest opaque pixel to the same ground, not dismember it.
    big=image.rotate(angle,Image.Resampling.BICUBIC,expand=True)
    bbox=big.getchannel('A').getbbox()
    assert bbox
    big=big.crop(bbox)
    scale=min(1.0,88/big.width,limit_h/big.height)
    if scale<1:
        big=big.resize((max(1,round(big.width*scale)),
                        max(1,round(big.height*scale))),Image.Resampling.LANCZOS)
    cell=Image.new('RGBA',(96,96))
    x=max(2,min(94-big.width,(96-big.width)//2+dx))
    cell.alpha_composite(big,(x,93-big.height))
    return cell

def build():
    # No rectangular puppet boots; ALL bodies+boots derived from painted D235.
    walks=[render(f) for f in raw_walks]
    idle_choices=[0,1,2,3]
    idle=[render(raw_walks[idx],angle=[-3,2,-2,3][i]) for i,idx in enumerate(idle_choices)]
    # Spear windup (raised), heavy step, hand-driven forward jab, hit, recovery.
    attack_source=[0,3,4,5,2,1]
    attack_angles=[-8,8,29,55,24,3]
    attack=[]
    for i in range(6):
        src=raw_walks[attack_source[i]]
        frame=render(src,angle=attack_angles[i],
                     lean=[(1,0),(0,0),(-2,0),(-3,0),(-2,0),(0,0)][i])
        attack.append(frame)
    # Body recoil progresses from forward hit to crouched and recovery.
    hit_src=[raw_walks[j] for j in (2,4,1)]
    hit=[ground_rotate(render(hit_src[i]),[5,-8,2][i],dx=[1,2,0][i])
         for i in range(3)]
    # Stagger → knee buckle → lean → catch floor → fall → settled corpse.
    death_src=[raw_walks[j] for j in (0,2,4,5,3,1)]
    death=[ground_rotate(render(death_src[i],angle=[0,0,15,32,52,65][i]),
             angle=[-4,8,32,62,84,89][i],dx=[0,-1,-2,-2,1,1][i],
             limit_h=[87,87,82,73,58,46][i]) for i in range(6)]
    return [idle,walks,attack,hit,death]

atlas=Image.new('RGBA',(576,480));allstates=build();report=[]
seen=set()
for row,frames in enumerate(allstates):
    assert len(frames)==COUNTS[row]
    for col,im in enumerate(frames):
        bbox=im.getchannel('A').getbbox()
        assert bbox and bbox[0]>=2 and bbox[1]>=2 and bbox[2]<=94 and bbox[3]<=94,(row,col,bbox)
        sha=hashlib.sha256(im.tobytes()).hexdigest()
        assert sha not in seen,('duplicate',row,col)
        seen.add(sha)
        atlas.alpha_composite(im,(col*96,row*96))
        report.append({'state':ROWS[row],'cel':col,'bbox':bbox,'sha256':sha})
for r,count in enumerate(COUNTS):
    for c in range(count,6):
        assert tile(atlas,c,r).getchannel('A').getbbox() is None
assert len(seen)==25
image_bytes=io.BytesIO();atlas.save(image_bytes,format='WEBP',lossless=True,method=6)
raw=image_bytes.getvalue()
assert Image.open(io.BytesIO(raw)).convert('RGBA').tobytes()==atlas.tobytes()
OUTPUT.write_text(base64.b64encode(raw).decode()+'\n')
QC.parent.mkdir(parents=True,exist_ok=True)
QC.write_text(json.dumps({
 'stage':'D241 whole-body painted source QA after user rejects mismatched D239 legs',
 'artifact_status':'SOURCE-COMPOSITED ART CANDIDATE; NATIVE VISUAL UNAPPROVED',
 'source_original':'D235 fullbody six-pose illustration, D240 matte source',
 'reused_weapon':'D234 authentic painted spear with hand pivot',
 'technical_checks':'25 distinct, 5 clear, safe 2px, lossless exact roundtrip',
 'states':ROWS,'counts':COUNTS,'unique':25,'clear':5,'frames':report,
 'fullbody_original_cels':False,'native_godot_pass':False,
 'runstate_unchanged':True,'asset_sha256':hashlib.sha256(raw).hexdigest()
},indent=2,ensure_ascii=False)+'\n')
print('D241 saved full illustrated-body QA atlas',OUTPUT,'hash',hashlib.sha256(raw).hexdigest())
