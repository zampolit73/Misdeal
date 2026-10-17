"""D236R gait repair: six-step support/swing cycle for rich D234 Sentinel.

Drawings are QA animation-cutout/painted shin proof, NOT six originally hand-painted
rich D235 full-body sprites.  Reads only versioned repository source asset.
Reproducible with Pillow >=10 and Python 3.11.
"""
from __future__ import annotations
import base64, hashlib, io, json, math
from pathlib import Path
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[2]
ASSETS = ROOT / 'assets/pixel/units/black_lantern_road_qa'
SRC = ASSETS / 'road_sentinel_d234_handheld_idle4.webp.b64'
OUT = ASSETS / 'road_sentinel_d236r_walk6_support_cycle.webp.b64'
QC = ROOT / 'docs/qa/D236R_SENTINEL_GAIT_QC.json'
SIZE = 96
FLOOR = 91
# Six-phase shared cycle: heel contact -> weight transfer -> toe push -> other
# heel contact -> weight transfer -> toe push.  Each foot is planted for three
# phases and lifted for three. Upper-body bob only 1px, spear & lamp attached.
# A and B tuple = (boot center x, boot sole y).  Position near the core, so
# strides are within 23px instead of D236's 49px split.
CYCLE = [
  {'phase':'A-contact', 'support':'A', 'A':(35,91), 'B':(57,87), 'body':(0,0)},
  {'phase':'A-weight',  'support':'A', 'A':(42,91), 'B':(47,85), 'body':(1,0)},
  {'phase':'A-push',    'support':'A', 'A':(50,91), 'B':(39,88), 'body':(1,-1)},
  {'phase':'B-contact', 'support':'B', 'A':(57,87), 'B':(35,91), 'body':(0,0)},
  {'phase':'B-weight',  'support':'B', 'A':(47,85), 'B':(42,91), 'body':(-1,0)},
  {'phase':'B-push',    'support':'B', 'A':(39,88), 'B':(50,91), 'body':(-1,-1)},
]
# shadow/rust detail sampled from Style-B illustration (colors authored here)
INK=(24,18,20,255); SHADE=(40,36,34,255); STEEL=(65,61,56,255)
ARMOR=(99,86,73,255); RIM=(143,123,101,255); GLINT=(179,152,116,255)
RUST=(93,46,43,255); BOOT=(50,43,42,255)
assert SRC.exists(),f'missing checked-in illustrated source {SRC}'
img=Image.open(io.BytesIO(base64.b64decode(SRC.read_text().strip()))).convert('RGBA')
assert img.size==(576,480)


def polygon(draw, pts, fill):
    draw.polygon([(round(x),round(y)) for x,y in pts], fill=fill)


def plated_limb(layer, hip, knee, ankle, strong):
    """Lightly angled multi-plate greaves, not a rigid knee-to-shoe straight line."""
    d=ImageDraw.Draw(layer)
    width=5 if strong else 4
    d.line([hip,knee],fill=INK,width=width+3)
    d.line([hip,knee],fill=STEEL,width=width)
    d.line([knee,ankle],fill=INK,width=width+3)
    d.line([knee,ankle],fill=ARMOR,width=width)
    d.line([(hip[0]-1,hip[1]),(knee[0]-1,knee[1])],fill=RIM,width=1)
    # kneecap and slight tapered greave separate the joints
    kx,ky=knee
    polygon(d,[(kx-4,ky-3),(kx+2,ky-4),(kx+5,ky-1),(kx+3,ky+4),(kx-4,ky+3)],INK)
    polygon(d,[(kx-3,ky-3),(kx+1,ky-3),(kx+4,ky-1),(kx+2,ky+2),(kx-2,ky+2)],ARMOR)
    d.line([(kx-2,ky-3),(kx+1,ky-3)],fill=GLINT,width=1)
    dx,dy=ankle[0]-kx,ankle[1]-ky
    for t in [0.44,0.74]:
        px=round(kx+dx*t);py=round(ky+dy*t)
        d.line([(px-2,py-1),(px+2,py)],fill=INK,width=2)
        d.line([(px-1,py-2),(px+1,py-1)],fill=RIM,width=1)


def boot(layer,center_x,sole_y,support):
    """Point toe to character's left, one sole line for planted foot."""
    d=ImageDraw.Draw(layer)
    bx=int(center_x); by=int(sole_y)
    # Artist-controlled forward-pointing toe, heel high on the right.
    outer=[(bx-9,by-2),(bx-7,by-4),(bx-3,by-5),(bx+3,by-5),
           (bx+7,by-3),(bx+7,by),(bx+4,by+1),(bx-8,by+1)]
    polygon(d,outer,INK)
    polygon(d,[(bx-7,by-3),(bx-2,by-4),(bx+4,by-3),(bx+6,by-1),(bx+2,by),(bx-7,by)],BOOT)
    d.line([(bx-7,by-3),(bx-4,by-4),(bx+1,by-4)],fill=RIM,width=1)
    d.line([(bx-8,by),(bx+6,by)],fill=STEEL,width=1)
    d.point((bx-5,by-2),fill=GLINT)
    if support: # anchored flat sole, single repeatable baseline
        d.line([(bx-8,FLOOR+1),(bx+6,FLOOR+1)],fill=SHADE,width=1)


def render_leg(foot_x,foot_y,which,torso_dx,torso_dy,support):
    """Two limb segments with bend towards foot motion and pelvis offset."""
    strong=which=='A'
    hip=(46+torso_dx, 72+torso_dy) if strong else (60+torso_dx,73+torso_dy)
    ankle=(int(foot_x)+2,int(foot_y)-5)
    delta=foot_x-hip[0]
    # Knee visible in gaps, bends in direction of step (within 7px).
    bend=(-3 if delta < -5 else (3 if delta>5 else (-1 if strong else 2)))
    knee=(round((hip[0]+ankle[0])/2+bend),round(hip[1]*0.40+ankle[1]*0.60))
    layer=Image.new('RGBA',(SIZE,SIZE))
    plated_limb(layer,hip,knee,ankle,strong)
    boot(layer,foot_x,foot_y,support)
    return layer, knee


def cleaned_body(i,offset):
    tile=img.crop((96*(i%4),0,96*(i%4+1),96)).copy()
    # Remove D234 miniature static heels ONLY. Keep long tattered cloak,
    # antique spear, complicated plate torso and ORIGINAL held lantern intact.
    for x0,x1,y0 in [(35,49,86),(67,82,86)]:
        for py in range(y0,SIZE):
            for px in range(x0,x1): tile.putpixel((px,py),(0,0,0,0))
    dx,dy=offset
    out=Image.new('RGBA',(SIZE,SIZE))
    out.alpha_composite(tile,(dx,dy))
    return out


def build_frame(i,step):
    dx,dy=step['body']; coordinates={}
    # B leg behind cloak, A leg over waist cloth at calf height.
    a_x,a_y=step['A'];b_x,b_y=step['B']
    rear,knee_b=render_leg(b_x,b_y,'B',dx,dy,step['support']=='B')
    front,knee_a=render_leg(a_x,a_y,'A',dx,dy,step['support']=='A')
    pose=rear.copy()
    body=cleaned_body(i,(dx,dy))
    pose.alpha_composite(body)
    # Keep high-detail coat visible up to the edge of its lowest hem;
    # foreground A shin/boot can emerge in front only below knee level.
    f=front.copy()
    for py in range(0,79):
        for px in range(SIZE):
            f.putpixel((px,py),(0,0,0,0))
    pose.alpha_composite(f)
    coordinates['knee_A']=knee_a; coordinates['knee_B']=knee_b
    return pose,coordinates

atlas=Image.new('RGBA',(576,480))
frames=[]; qc={
 'stage':'D236R GAIT REPAIR after user reports D236 unnatural',
 'decision':'D236 user visual FAIL, new gait still UNAPPROVED',
 'technique':'3-phase alternating stance per foot, softer center-of-mass bob, no toe teleport',
 'canvas':[576,480],'cell':[96,96],'states_implemented':['walk'],
 'visible':6,'unused':24,'production_installed':False,
 'whole_character_fully_repainted':False,'native_godot_pass':False,
 'support_frames':[],'frames':[],'hashes':[],'warnings':[]
}
for i,step in enumerate(CYCLE):
    pose,knees=build_frame(i,step)
    atlas.alpha_composite(pose,(96*i,96))
    frames.append(pose)
    bbox=pose.getchannel('A').getbbox();signature=hashlib.sha256(pose.tobytes()).hexdigest()
    qa={'i':i,'phase':step['phase'],'support':step['support'],
        'boot_A':step['A'],'boot_B':step['B'],'body_offset':step['body'],
        'knees':knees,'bbox':bbox, 'hash':signature}
    qc['frames'].append(qa); qc['hashes'].append(signature)
    if bbox is None or bbox[0]<2 or bbox[1]<2 or bbox[2]>94 or bbox[3]>94:
        qc['warnings'].append({'frame':i,'problem':'out of safe 2px inset', 'bbox':bbox})
    if step['A'][1]!=FLOOR and step['B'][1]!=FLOOR:
        qc['warnings'].append({'frame':i,'problem':'no planted foot'})
    if step[step['support']][1]!=FLOOR:
        qc['warnings'].append({'frame':i,'problem':'support not on floor'})
assert len(set(qc['hashes']))==6
assert not qc['warnings'],qc['warnings']
blob_buffer=io.BytesIO();atlas.save(blob_buffer,format='WEBP',lossless=True,method=6)
blob=blob_buffer.getvalue()
assert Image.open(io.BytesIO(blob)).convert('RGBA').tobytes()==atlas.tobytes()
qc['webp_sha256']=hashlib.sha256(blob).hexdigest()
assert sum(1 for row in range(5) for col in range(6)
           if atlas.crop((col*96,row*96,col*96+96,row*96+96)).getbbox())==6
OUT.parent.mkdir(parents=True,exist_ok=True);QC.parent.mkdir(parents=True,exist_ok=True)
OUT.write_text(base64.b64encode(blob).decode())
QC.write_text(json.dumps(qc,ensure_ascii=False,indent=2))
# QA protects loop continuity: no ankle teleport at 2->3 or 5->0.
qc['max_ankle_delta'] = 0
for i,step in enumerate(CYCLE):
    nxt=CYCLE[(i+1)%6]
    for foot in ('A','B'):
        before=step[foot]; after=nxt[foot]
        delta=max(abs(before[0]-after[0]),abs(before[1]-after[1]))
        qc['max_ankle_delta']=max(qc['max_ankle_delta'],delta)
        assert delta <= 10, f'{foot} teleports between phase {i} and {(i+1)%6}'
assert [step['support'] for step in CYCLE]==['A','A','A','B','B','B']
QC.write_text(json.dumps(qc,ensure_ascii=False,indent=2))
print('SAVED',OUT,'sha',qc['webp_sha256'],'QC',qc['warnings'],'BOUNDS',[x['bbox'] for x in qc['frames']])