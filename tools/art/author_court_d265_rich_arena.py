#!/usr/bin/env python3
"""D265: detail/palette pass on original empty Court of the Mute floor (QA only).

Draws all architecture from editable scene instructions. NEVER rasterizes
character images into the battle plate. Output 1280x720 lossless WebP .b64.
Art direction references the user-approved SECOND D261 court card, but that
card bitmap remains completely unchanged. Manual pixel layout; no recycled
crypt background and no opaque pseudo-enemy cutouts.
"""
from __future__ import annotations
import base64
from io import BytesIO
import hashlib
import json
import math
import random
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parents[2]
OUT = ROOT / "assets/pixel/battle/arenas/court_of_the_mute_d265_rich_qa.webp.b64"
REPORT = ROOT / "docs/qa/D265_COURT_RICH_EMPTY_ARENA_QC.json"
W, H = 640, 360
rng = random.Random(26539)

im = Image.new("RGB", (W, H), (13, 16, 22))
p = ImageDraw.Draw(im)

def box(coords, color):
    p.rectangle(tuple(int(v) for v in coords), fill=color)
def line(points, color, width=1):
    p.line([(int(x), int(y)) for x,y in points], fill=color, width=width)
def poly(points, color):
    p.polygon([(int(x), int(y)) for x,y in points], fill=color)
def ell(coords, color):
    p.ellipse(tuple(int(v) for v in coords), fill=color)

# Upper vault: deliberate carved masonry instead of wall-to-wall abstract noise.
for y in range(0, 176, 11):
    for x in range(-4, W+8, 27):
        jitter = (y // 11 % 2)*13
        tone = rng.randint(-4, 3)
        box((x+jitter,y,x+24+jitter,y+9),(20+tone,25+tone,33+tone))
        line([(x+jitter,y+10),(x+25+jitter,y+10)],(10,12,17))
        line([(x+25+jitter,y),(x+25+jitter,y+9)],(10,12,17))

# Open moonlit inner arches, no character silhouettes.
def arch(left, right, ceiling, base, light):
    width=right-left
    for x in range(left,right):
        n=(x-(left+right)/2)/(width/2)
        ry=max(0.0,1.0-n*n)**0.5
        top=int(base-(base-ceiling)*ry)
        box((x,top,x,base), light)
    for t in (0,1,2):
        xx0=left-t-2; xx1=right+t+2
        line([(xx0,base),(xx0,ceiling+16),(left+width//4,ceiling-1-t),
              (left+width//2,ceiling-7-t),(right-width//4,ceiling-1-t),
              (xx1,ceiling+16),(xx1,base)],(42+t*8,47+t*7,53+t*7),2)
for left,right in [(45,152),(266,374),(488,596)]:
    arch(left,right,35,161,(23,35,48))
    # Silhouetted mountains and broken cities beyond arches.
    poly([(left+2,160),(left+2,125),(left+16,116),(left+28,130),
          (left+40,109),(left+58,134),(right-4,122),(right-3,160)],(25,33,43))
    for n in range(9):
        x=left+8+n*11
        skyline=122-rng.randrange(7,40)
        box((x,skyline,x+rng.randrange(3,7),163),(19,24,34))
        if n%3==1: poly([(x-1,skyline),(x+2,skyline-13),(x+5,skyline)],(19,24,34))

# Cold moon disk floats behind fractured central circular stone lattice.
ell((309,20,333,44),(111,128,138))
ell((314,22,329,38),(153,164,168))
for x in [23,160,237,381,461,605]:
    box((x-13,0,x+13,225),(24,25,29))
    for side in (x-15,x+12):
        box((side,15,side+4,232),(38,38,39))
    for yy in range(19,218,23):
        line([(x-11,yy),(x+11,yy)],(51,48,46))
        box((x-9,yy+4,x+9,yy+6),(30,30,34))
    box((x-21,203,x+20,214),(54,50,49))
    box((x-22,215,x+21,223),(31,31,35))

# Heavy ring of ceiling beams, two grand broken arches, thin hanging chains.
for x0,x1 in [(8,298),(340,632)]:
    for t in range(5):
        line([(x0,65-t),(x0+20,36-t),(x0+88,9-t),
              (x1-80,9-t),(x1-12,36-t),(x1,67-t)],(35+4*t,36+4*t,39+4*t),2)
for x in [28,129,226,412,507,609]:
    for yy in range(0,116,10):
        line([(x,yy),(x+(yy//10%2),yy+7)],(63,56,47))
        box((x-1,yy+4,x+1,yy+6),(84,66,49))

# Funeral banners with ragged hem and exact repeated heraldic form.
for cx in (190,449):
    poly([(cx-16,0),(cx+18,0),(cx+15,114),(cx+8,107),(cx+2,127),
          (cx-5,111),(cx-14,120)],(66,28,28))
    poly([(cx-10,0),(cx+5,0),(cx+4,101),(cx-3,107),(cx-8,109)],(87,37,32))
    line([(cx+1,17),(cx+1,66)],(128,83,53),2)
    line([(cx-8,36),(cx+10,36)],(135,86,54),2)
    ell((cx-5,19,cx+7,34),(142,96,57))
    ell((cx-3,21,cx+5,32),(71,34,30))

# Seated stone judgment throne is EMPTY — no painted magistrate.
box((255,104,385,188),(30,30,35))
poly([(263,106),(277,79),(307,66),(320,46),(336,70),(367,79),(380,106)],(49,46,45))
poly([(267,107),(284,83),(311,74),(320,58),(330,75),(354,84),(377,107)],(24,29,36))
for yy in range(108,190,14):
    line([(254,yy),(386,yy)],(62,55,51))
box((269,121,371,179),(45,40,39))
box((283,132,357,166),(26,27,33))
# Carved stone skull emblem at center, deliberately architectural and static.
ell((309,137,331,158),(69,66,62))
ell((314,146,318,151),(18,18,21))
ell((324,146,328,151),(18,18,21))
box((318,155,324,164),(53,51,50))
box((295,179,347,191),(58,49,46))

# Dais, tribunal lectern, cracked bench and stairs above playable floor.
for i in range(5):
    box((211-i*8,188+i*9,430+i*8,200+i*9),(35+i*3,33+i*3,36+i*3))
    line([(211-i*8,188+i*9),(430+i*8,188+i*9)],(79,69,56),2)
box((178,176,235,225),(53,44,40))
box((183,171,231,180),(84,65,48))
box((406,177,462,226),(53,44,40))
box((401,171,459,180),(84,65,48))
# Ledger plinth empty; quill props are reserved for animated scribe.
box((303,184,338,205),(73,55,43))
box((307,181,334,189),(106,77,52))
line([(320,182),(320,201)],(148,107,60))
# Giant broken scales of judgment: architectural hanging balance, NO living hands.
line([(322,92),(322,134)],(157,106,58),3)
poly([(312,99),(321,86),(333,99)],(139,92,53))
line([(280,108),(364,106)],(167,114,67),3)
for xx in (286,359):
    y=110 if xx==286 else 107
    line([(xx,y),(xx-11,y+28)],(135,91,54))
    line([(xx,y),(xx+11,y+28)],(135,91,54))
    line([(xx-18,y+29),(xx+18,y+29)],(160,113,65),2)
    poly([(xx-17,y+29),(xx+17,y+29),(xx+11,y+35),(xx-11,y+35)],(97,71,48))
# Stone stairs to playable arena foreground.
for j in range(3):
    left=190-j*13; right=449+j*13; y=235+j*9
    box((left,y,right,y+11),(44+j*3,43+j*3,45+j*3))
    line([(left,y),(right,y)],(92,77,61),2)

# Flat broad contiguous REAL walkable floor from screen y≈270 to lower 590.
# Game's combat feet fall at ~390–538; make no props overlap this stretch.
for yy in range(261,359,16):
    for x in range(-25,W+35,48):
        shift=24 if ((yy-261)//16)%2 else 0
        x1=x+shift+rng.randint(-2,2); x2=x1+46
        shade=rng.randrange(-6,6)
        box((x1,yy,x2,yy+15),(40+shade,43+shade,47+shade))
        line([(x1,yy),(x2,yy)],(66+shade,66+shade,66+shade))
        line([(x2,yy),(x2,yy+14)],(21,24,30))
        if rng.random()<.54:
            line([(x1+5,yy+5),(x1+13,yy+7),(x1+19,yy+5)],(34,35,38))
        if rng.random()<.34:
            box((x1+26,yy+8,x1+30,yy+8),(77,68,58))
# Thin chalk circle recessed in the distant floor, behind unit silhouettes.
for rr in (74,79,83):
    for t in range(0,360,3):
        x=int(320+rr*math.cos(math.radians(t)))
        y=int(301+(rr*0.28)*math.sin(math.radians(t)))
        box((x,y,x+1,y+1),(75,51,45) if rr==79 else (57,49,47))
# Edge piles and candle-bearing stone parapets only on FAR left/right.
def brazier(cx, cy):
    box((cx-11,cy,cx+10,cy+11),(61,53,50))
    box((cx-7,cy+11,cx+7,cy+41),(42,39,39))
    box((cx-13,cy+40,cx+12,cy+44),(68,56,48))
    for j in range(6):
        dx=(j-3)*4
        hh=[9,14,19,13,16,10][j]
        poly([(cx+dx-2,cy),(cx+dx,cy-hh),(cx+dx+2,cy)],(171,92+2*j,38))
        box((cx+dx,cy-4,cx+dx,cy),(251,179,84))
for x,y in [(83,205),(553,205),(107,171),(530,171)]:
    brazier(x,y)
# restrained warm light at far edges, never heavy orange overlay on unit contact.
for cx,cy in ((83,205),(553,205)):
    for rad,a in [(36,0.055),(24,0.075)]:
        glow=Image.new("RGBA",(W,H),(0,0,0,0))
        gg=ImageDraw.Draw(glow)
        gg.ellipse((cx-rad,cy-rad,cx+rad,cy+rad),fill=(244,117,42,int(a*255)))
        glow=glow.filter(ImageFilter.GaussianBlur(13))
        im=Image.alpha_composite(im.convert("RGBA"),glow).convert("RGB")
p=ImageDraw.Draw(im)
# Isolated amber puddle reflections outside highest-density character lane.
for cx in (83,553):
    for i in range(15):
        y=rng.randrange(276,351)
        x=cx+rng.randrange(-21,22)
        line([(x,y),(x+rng.randrange(3,13),y)],(91,68,46))
# One subtle foreground vignette but no blurred/baked combat silhouettes.
pix=im.load()
for yy in range(H):
    for xx in range(W):
        edge=(abs(xx-W/2)/(W/2))**2*0.24+(abs(yy-H/2)/(H/2))**2*0.06
        if edge>0.06:
            f=max(0.70,1.0-edge)
            r,g,b=pix[xx,yy]
            pix[xx,yy]=(int(r*f),int(g*f),int(b*f))

# D265 style pass: deliberately placed carved stone, recessed mortar,
# narrow patina channels and edge-only moon / warm firelight; NO actors.
# This is a texture/detail pass on authored empty architecture, not a
# replacement for the user's selected D261 card painting.
painting = Image.new("RGBA", (W,H), (0,0,0,0))
pd = ImageDraw.Draw(painting)
for y in range(9,260,11):
    for x in range(7+(y//11%2)*15,W,30):
        if 145 < y < 245 and 184 < x < 460:
            continue  # Keep throne, stairs and scales legible.
        sx=x+rng.randint(-2,2)
        if rng.random()<.68:
            pd.line([(sx+1,y+2),(sx+rng.randint(8,23),y+2)],
                    fill=(131,115,96,rng.randint(25,95)),width=1)
        if rng.random()<.4:
            sx+=rng.randint(1,13)
            pd.line([(sx,y+3),(sx-2,y+7),(sx+3,y+10)],
                    fill=(4,7,13,rng.randint(66,143)),width=1)
for x in [23,160,237,381,461,605]:
    pd.line([(x-9,28),(x-9,191)],fill=(146,125,100,68),width=2)
    pd.line([(x+10,26),(x+10,198)],fill=(2,4,9,139),width=2)
    for k in range(14):
        yy=rng.randint(7,210)
        xx=x+rng.choice((-8,-6,6,8))
        pd.rectangle((xx,yy,xx+1,yy+1),
                     fill=(159,139,114,rng.randrange(42,124)))
for step in range(7):
    y=190+step*10
    pd.line([(180-step*6,y),(461+step*6,y)],
            fill=(159,133,104,119),width=1)
    pd.line([(180-step*6,y+3),(461+step*6,y+3)],
            fill=(4,6,11,116),width=2)
for x in (70,110,171,470,529,573):
    for k in range(13):
        xx=x+rng.randrange(-18,19)
        yy=rng.randrange(130,259)
        pd.line([(xx,yy),(xx+rng.choice((-1,0,1)),yy+rng.randint(5,20))],
                fill=(41,70,53,rng.randint(18,78)),width=1)
# LOWER FLOOR (D264 x40–1268, y532–710 screen), no props or figures,
# only surface wear flush with the stone below actors' feet.
for yy in range(269,355,16):
    for xx in range(-10+(yy//16%2)*24,650,48):
        px=xx+rng.randint(-3,3)
        if rng.random()<.8:
            pd.line([(px+1,yy+2),(px+rng.randint(11,39),yy+2)],
                    fill=(158,143,119,rng.randint(15,94)),width=1)
        if rng.random()<.29:
            pd.line([(px+5,yy+5),(px+14,yy+7),(px+21,yy+6)],
                    fill=(4,8,16,rng.randint(65,137)),width=1)
for k in range(240):
    xx=rng.randint(24,626);yy=rng.randint(271,353)
    col=(163,136,97,rng.randint(11,75)) if rng.random()<.58 else (5,9,15,rng.randint(41,102))
    if rng.random()<.5: pd.point((xx,yy),fill=col)
    else: pd.line([(xx,yy),(xx+rng.randint(2,12),yy)],fill=col,width=1)
# Worn court seal is a shallow floor engraving, not a summon circle or prop.
for i in range(0,275,2):
    rad=12+i*0.26
    theta=math.radians(i*1.1)
    xx=320+rad*math.cos(theta)
    yy=313+rad*0.27*math.sin(theta)
    pd.point((round(xx),round(yy)),fill=(155,80,55,81))
im=Image.alpha_composite(im.convert("RGBA"), painting)
ambient=Image.new("RGBA",(W,H),(0,0,0,0))
ad=ImageDraw.Draw(ambient)
# Stone vault swallows warm firelight; torch reflection never blankets play area.
for xx,yy in ((83,200),(553,200),(107,171),(530,171)):
    for k,(radius,alpha) in enumerate(((35,24),(55,14),(80,6))):
        ad.ellipse((xx-radius,yy-radius,xx+radius,yy+radius),
                   fill=(239,122,53,alpha))
ambient=ambient.filter(ImageFilter.GaussianBlur(18))
im=Image.alpha_composite(im,ambient).convert("RGB")
# Stone surface variation is tile-scaled, never random HUD-like symbols.
pixels=im.load()
for yy in range(H):
    for xx in range(W):
        r,g,b=pixels[xx,yy]
        jitter=rng.randint(-5,5) if yy<266 else rng.randint(-4,4)
        pixels[xx,yy]=(max(0,min(255,r+jitter)),
                       max(0,min(255,g+jitter//2)),
                       max(0,min(255,b+jitter//3)))
p=ImageDraw.Draw(im)

im=im.resize((1280,720), Image.Resampling.NEAREST)
buf=BytesIO()
im.save(buf,format="WEBP",lossless=True,method=6)
raw=buf.getvalue()
OUT.parent.mkdir(parents=True,exist_ok=True)
OUT.write_text(base64.b64encode(raw).decode("ascii")+"\n",encoding="ascii")
roundtrip=Image.open(BytesIO(base64.b64decode(OUT.read_text().strip()))).convert("RGB")
assert roundtrip.size==(1280,720) and roundtrip.tobytes()==im.tobytes()
qc={"version":"D265","status":"RICH_QA_ARENA_NOT_YET_ART_APPROVED","type":"original procedural-authored pixel architecture; not imported approved art",
    "source":"tools/art/author_court_d265_rich_arena.py","path":str(OUT.relative_to(ROOT)),
    "sha256":hashlib.sha256(raw).hexdigest(),"width":1280,"height":720,
    "actor_cutouts":0,"characters_baked_into_scene":False,
    "has_distinct_floor":True,"source_card_art_modified":False,
    "live_cards":38,"card39_released":False,
    "native_F6_visual_acceptance":"NOT_YET_APPROVED"}
REPORT.parent.mkdir(parents=True,exist_ok=True)
REPORT.write_text(json.dumps(qc,indent=2,ensure_ascii=False)+"\n",encoding="utf-8")
print("D265_COURT_RICH_EMPTY_ARENA_SOURCE_PASS",qc["sha256"],len(raw))
