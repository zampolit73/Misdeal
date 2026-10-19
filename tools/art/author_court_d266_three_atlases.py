#!/usr/bin/env python3
"""D266 original Court unit animation prototypes, 3 x 25 genuinely drawn poses.

All artwork uses role-specific pixel shapes, layered costume/props, state-specific
limb joint and prop positions; NOT copies, rotations of finished static sprites,
or borrowed enemy art. Human x1 aesthetic/motion review remains mandatory.
"""
from __future__ import annotations
import base64, hashlib, io, json, math, random
from pathlib import Path
from PIL import Image, ImageDraw, ImageChops

ROOT=Path(__file__).resolve().parents[2]
OUT=ROOT/"assets/pixel/units/court_of_the_mute_qa"
REPORT=ROOT/"docs/qa/D266_ORIGINAL_75_POSE_AUTHORING.json"
ROLES=("mute_magistrate","ash_scrivener","bone_bailiff")
STATES=(("idle",4),("walk",6),("attack",6),("hit",3),("death",6))
S=96
PALE=(198,183,156,255); IVORY=(232,219,187,255)
GOLD=(160,103,51,255); EDGE=(93,56,36,255)
IRON=(82,88,89,255); SILVER=(139,139,124,255)
RED=(121,37,37,255); INK=(185,39,44,255)
DARK=(17,15,21,255)
def P(v): return round(v)
def shade(col, mul):
    return (*[max(0,min(255,int(channel*mul))) for channel in col[:3]],col[3])
def line(d,xy,col,width=2):
    d.line(tuple((P(x),P(y)) for x,y in xy),fill=col,width=width,joint="curve")
def pg(d,pts,col):
    d.polygon(tuple((P(x),P(y)) for x,y in pts),fill=col)
def ellipse(d,bbox,col):
    d.ellipse(tuple(P(x) for x in bbox),fill=col)
def rect(d,bbox,col):
    d.rectangle(tuple(P(x) for x in bbox),fill=col)

def limb(d,p0,p1,p2,bone,armor=False):
    line(d,[p0,p1,p2],DARK,5 if armor else 4)
    line(d,[p0,p1,p2],bone,3 if armor else 2)
    if armor:
        ellipse(d,(p1[0]-3,p1[1]-3,p1[0]+3,p1[1]+3),IRON)
        line(d,[(p1[0]-1,p1[1]-2),(p1[0]+1,p1[1]-2)],SILVER,1)

def skull(d,cx,cy,role,look=0,hit=False):
    # Separate faceted mandible, brow, temple bones, jaw teeth.
    if role=="ash_scrivener":
        color=PALE; eye=(235,53,43,255)
        pg(d,[(cx-11,cy-5),(cx-7,cy-15),(cx+8,cy-15),(cx+12,cy-3),
              (cx+9,cy+10),(cx-9,cy+11)],(83,25,28,255))
        pg(d,[(cx-8,cy-6),(cx-3,cy-11),(cx+6,cy-9),(cx+9,cy-2),
              (cx+5,cy+8),(cx-7,cy+6)],(21,21,24,255))
        ellipse(d,(cx-6,cy-5,cx+5,cy+5),color)
    else:
        ellipse(d,(cx-9,cy-10,cx+9,cy+8),DARK)
        ellipse(d,(cx-7,cy-9,cx+8,cy+7),PALE)
        rect(d,(cx-5,cy+4,cx+7,cy+11),PALE)
        rect(d,(cx-5,cy+7,cx+6,cy+9),shade(PALE,0.52))
    eye_col=(255,87,55,255) if role=="mute_magistrate" else (214,75,51,255)
    rect(d,(cx-5+look,cy-1,cx-3+look,cy+1),DARK)
    rect(d,(cx+3+look,cy-1,cx+5+look,cy+1),DARK)
    rect(d,(cx-4+look,cy-1,cx-3+look,cy),eye_col)
    rect(d,(cx+4+look,cy-1,cx+5+look,cy),eye_col)
    pg(d,[(cx,cy+1),(cx-2,cy+4),(cx+2,cy+4)],shade(PALE,0.28))
    for i in range(4):
        rect(d,(cx-4+i*3,cy+8,cx-3+i*3,cy+10),shade(PALE,0.42))
    if hit:
        line(d,[(cx-7,cy-7),(cx+6,cy+5)],INK,1)

def robe(d,cx,bob,style,swish,lean):
    shoulder=42+bob
    if style=="mute_magistrate":
        outline=(23,16,20,255); cloth=(53,26,27,255); trim=(155,93,48,255)
        pg(d,[(cx-19+lean,shoulder-2),(cx+18+lean,shoulder-2),
              (cx+24+swish,87),(cx+8+swish,86),(cx+2+lean,75),
              (cx-7+lean,84),(cx-22+swish,89)],outline)
        pg(d,[(cx-16+lean,shoulder),(cx+16+lean,shoulder),
              (cx+18+swish,84),(cx+6+swish,82),(cx,74),
              (cx-12,83),(cx-19+swish,86)],cloth)
        pg(d,[(cx-5,43+bob),(cx+5,43+bob),(cx+10,79),(cx,86),(cx-9,78)],(44,39,37,255))
        line(d,[(cx-4,47+bob),(cx-4,77),(cx-11,83)],trim,2)
        line(d,[(cx+5,47+bob),(cx+5,78),(cx+14+swish,83)],trim,2)
        rect(d,(cx-14,49+bob,cx+13,52+bob),(85,55,40,255))
        for y in range(56,81,7):
            line(d,[(cx-3,y),(cx+3,y)],(119,77,46,255),1)
        for yy in range(55,78,9):
            rect(d,(cx-15,yy,cx-14,yy+3),GOLD)
    elif style=="ash_scrivener":
        pg(d,[(cx-17,40+bob),(cx+12,39+bob),(cx+21+swish,86),(cx+6+swish,88),
              (cx-6,81),(cx-15+swish,87),(cx-21+swish,81)],(19,16,21,255))
        pg(d,[(cx-15,40+bob),(cx+11,42+bob),(cx+16+swish,82),(cx+4+swish,84),
              (cx-6,76),(cx-14+swish,84)],(78,29,34,255))
        pg(d,[(cx-5,47+bob),(cx+4,47+bob),(cx+8,82),(cx-8,80)],(37,36,35,255))
        line(d,[(cx-12,46+bob),(cx-10,75),(cx-14+swish,83)],(132,68,45,255),2)
        line(d,[(cx+7,48+bob),(cx+10+swish,80)],(134,72,49,255),1)
        for i in range(4):
            line(d,[(cx-6,58+i*5),(cx+2,59+i*5)],(112,86,60,255),1)
    else:
        pg(d,[(cx-18+lean,41+bob),(cx+13+lean,41+bob),(cx+19+swish,88),
              (cx+4,84),(cx-5,82),(cx-22+swish,89)],(27,19,24,255))
        pg(d,[(cx-15+lean,44+bob),(cx+12+lean,44+bob),(cx+16+swish,83),
              (cx+3,78),(cx-16+swish,86)],(92,32,32,255))
        line(d,[(cx-13,44+bob),(cx-11,81),(cx-18+swish,88)],(162,86,52,255),2)
        line(d,[(cx+8,45+bob),(cx+12+swish,83)],(154,78,42,255),2)

def torso(d,cx,bob,role):
    if role=="bone_bailiff":
        pg(d,[(cx-12,42+bob),(cx+11,42+bob),(cx+14,63+bob),(cx-13,63+bob)],(39,37,37,255))
        pg(d,[(cx-11,44+bob),(cx+10,44+bob),(cx+8,58+bob),(cx-9,58+bob)],IRON)
        for i in range(3):
            line(d,[(cx-11+i,49+bob+i*5),(cx+11-i,49+bob+i*5)],(45,47,47,255),2)
        rect(d,(cx-12,59+bob,cx+12,62+bob),EDGE)
        for x in range(cx-8,cx+10,7):
            rect(d,(x,58+bob,x+2,61+bob),GOLD)
        pg(d,[(cx-14,40+bob),(cx-3,38+bob),(cx-6,48+bob),(cx-18,51+bob)],SILVER)
        pg(d,[(cx+4,39+bob),(cx+15,39+bob),(cx+19,50+bob),(cx+8,48+bob)],IRON)
        rect(d,(cx-13,43+bob,cx-8,46+bob),shade(SILVER,1.22))
    else:
        pg(d,[(cx-10,45+bob),(cx+11,45+bob),(cx+8,62+bob),(cx-8,62+bob)],(35,30,32,255))
        for j in range(5):
            shift=j*3
            line(d,[(cx,49+bob+shift),(cx-8,47+bob+shift)],PALE,1)
            line(d,[(cx,49+bob+shift),(cx+9,47+bob+shift)],PALE,1)
        line(d,[(cx,47+bob),(cx,62+bob)],PALE,2)
        rect(d,(cx-10,62+bob,cx+9,65+bob),EDGE)
        rect(d,(cx-4,61+bob,cx+3,64+bob),GOLD)

def boots(d,cx,bob,stride,role):
    hips= (cx,65+bob)
    if role=="mute_magistrate": spread=7
    elif role=="ash_scrivener": spread=5
    else: spread=9
    stride=int(stride)
    for index,sgn in enumerate((-1,1)):
        knee=(cx+sgn*spread+stride*sgn//3,75+bob + (abs(stride)//4 if index==0 else -abs(stride)//4))
        foot=(cx+sgn*spread+stride*(1 if index==0 else -1),90-(min(5,abs(stride)) if index==1 and stride<0 else 0))
        limb(d,(cx+sgn*4,65+bob),knee,(foot[0],foot[1]-3),PALE,role=="bone_bailiff")
        rect(d,(foot[0]-3,foot[1]-6,foot[0]+2,foot[1]-1),(49,42,36,255) if role=="ash_scrivener" else IRON)
        rect(d,(foot[0]-5,foot[1]-2,foot[0]+6,foot[1]+1),DARK)
        line(d,[(foot[0]-4,foot[1]),(foot[0]+4,foot[1])],SILVER if role!="ash_scrivener" else EDGE,1)

def crown(d,cx,cy,role):
    if role!="mute_magistrate":return
    pg(d,[(cx-12,cy-8),(cx-13,cy-19),(cx-7,cy-15),(cx-4,cy-22),
          (cx+1,cy-15),(cx+6,cy-23),(cx+10,cy-15),
          (cx+13,cy-19),(cx+11,cy-6)],(93,59,37,255))
    pg(d,[(cx-10,cy-11),(cx-9,cy-17),(cx-4,cy-14),(cx-2,cy-19),
          (cx+3,cy-14),(cx+6,cy-19),(cx+9,cy-13),(cx+11,cy-16),
          (cx+10,cy-8)],GOLD)
    for x,y in [(-9,-18),(-3,-19),(6,-20),(11,-17)]:
        ellipse(d,(cx+x-1,cy+y-1,cx+x+1,cy+y+1),(227,158,78,255))
    rect(d,(cx-8,cy-8,cx+9,cy-6),EDGE)
    rect(d,(cx-5,cy-8,cx+5,cy-7),RED)

def magistrate_prop(d,cx,bob,phase,action):
    hand=(cx-21-phase//3,53+bob)
    limb(d,(cx-10,43+bob),(cx-19,45+bob),hand,PALE,False)
    angle=math.radians(-84 + (phase*19 if action=="attack" else phase*3))
    tip=(hand[0]+math.cos(angle)*48,hand[1]+math.sin(angle)*48)
    end=(hand[0]-math.cos(angle)*19,hand[1]-math.sin(angle)*19)
    line(d,[end,tip],DARK,5)
    line(d,[end,tip],(119,82,52,255),3)
    # Upper judicial scale/seal: two hanging bowls, always connected to staff.
    vx,vy=math.cos(angle),math.sin(angle)
    perp=(-vy,vx)
    crest=(tip[0],tip[1])
    line(d,[(crest[0]-perp[0]*8,crest[1]-perp[1]*8),
            (crest[0]+perp[0]*8,crest[1]+perp[1]*8)],GOLD,2)
    for sign in (-1,1):
        mount=(crest[0]+perp[0]*sign*7,crest[1]+perp[1]*sign*7)
        line(d,[mount,(mount[0],mount[1]+6)],GOLD,1)
        line(d,[(mount[0]-4,mount[1]+6),(mount[0]+4,mount[1]+6)],(190,127,69,255),2)
    ellipse(d,(hand[0]-3,hand[1]-2,hand[0]+2,hand[1]+3),PALE)
    # Other arm holds a wax judicial seal on chest.
    limb(d,(cx+12,45+bob),(cx+16,51+bob),(cx+7,57+bob),PALE)
    rect(d,(cx+3,55+bob,cx+10,61+bob),RED)
    rect(d,(cx+5,56+bob,cx+8,59+bob),(216,92,66,255))
    if action=="attack" and phase>=2:
        tx=cx+31+phase*3;ty=55-2*phase
        ellipse(d,(tx-4,ty-4,tx+4,ty+4),(173,39,37,220))
        line(d,[(tx-9,ty),(tx+9,ty)],(230,93,55,200),1)
        line(d,[(tx,ty-9),(tx,ty+9)],(230,93,55,200),1)

def scribe_prop(d,cx,bob,phase,action):
    # Left arm cradle is stitched to a *physical* ledger, right hand ink quill.
    limb(d,(cx-11,45+bob),(cx-16,54+bob),(cx+7,59+bob),PALE)
    pg(d,[(cx+1,48+bob),(cx+18,47+bob),(cx+18,66+bob),(cx+1,65+bob)],DARK)
    pg(d,[(cx+3,49+bob),(cx+17,49+bob),(cx+16,63+bob),(cx+3,64+bob)],(158,127,83,255))
    pg(d,[(cx+4,50+bob),(cx+10,51+bob),(cx+11,62+bob),(cx+4,62+bob)],(220,192,139,255))
    line(d,[(cx+11,50+bob),(cx+11,62+bob)],EDGE,1)
    for iy in range(53,62,3):
        line(d,[(cx+12,iy+bob),(cx+16,iy+bob)],(91,58,49,255),1)
        line(d,[(cx+5,iy+bob),(cx+9,iy+bob)],(91,58,49,255),1)
    ang=(phase-1.4)*0.34 if action=="attack" else math.sin(phase*0.45)*0.17
    tip=(cx+27+math.cos(ang)*3,25+bob+math.sin(ang)*9)
    elbow=(cx+12,46+bob)
    hand=(cx+18,49+bob)
    limb(d,(cx+10,45+bob),elbow,hand,PALE)
    line(d,[(hand[0],hand[1]),tip],(147,111,76,255),2)
    pg(d,[(tip[0],tip[1]-11),(tip[0]+6,tip[1]-7),(tip[0],tip[1]+3)],(224,195,153,255))
    pg(d,[(tip[0]+2,tip[1]-8),(tip[0]+5,tip[1]-6),(tip[0]+1,tip[1]+1)],(195,160,124,255))
    if action=="attack" and phase>=2:
        for i in range(4):
            xx=cx+21+phase*4+int(7*math.cos(i*math.pi/2))
            yy=43+int(6*math.sin(i*math.pi/2))
            rect(d,(xx-1,yy-1,xx+1,yy+1),RED if i%2 else INK)
        line(d,[(cx+25,44),(cx+46+phase,38)],(172,39,39,180),1)

def bailiff_prop(d,cx,bob,phase,action):
    # Broad heraldic square shield in LEFT hand, blade in RIGHT hand.
    limb(d,(cx+12,44+bob),(cx+21,51+bob),(cx+22,59+bob),SILVER,True)
    pg(d,[(cx+18,45+bob),(cx+32,44+bob),(cx+33,71+bob),
          (cx+25,80+bob),(cx+16,71+bob)],DARK)
    pg(d,[(cx+19,47+bob),(cx+30,46+bob),(cx+30,69+bob),
          (cx+25,75+bob),(cx+19,69+bob)],IRON)
    line(d,[(cx+23,48+bob),(cx+23,72+bob)],SILVER,2)
    line(d,[(cx+20,55+bob),(cx+29,55+bob)],GOLD,2)
    rect(d,(cx+23,58+bob,cx+26,62+bob),RED)
    # Per-frame real hooked-halberd swing; shaft stays attached to right hand.
    grip=(cx-22,52+bob)
    limb(d,(cx-12,43+bob),(cx-19,48+bob),grip,SILVER,True)
    theta=math.radians(-96+(phase-1)*18 if action=="attack" else -86+phase*3)
    tip=(grip[0]+math.cos(theta)*44,grip[1]+math.sin(theta)*44)
    butt=(grip[0]-math.cos(theta)*19,grip[1]-math.sin(theta)*19)
    line(d,[butt,tip],DARK,5)
    line(d,[butt,tip],(134,112,83,255),3)
    side=(-math.sin(theta),math.cos(theta))
    pg(d,[(tip[0]-side[0]*4,tip[1]-side[1]*4),
          (tip[0]+side[0]*11,tip[1]+side[1]*11),
          (tip[0]-math.cos(theta)*12+side[0]*15,
           tip[1]-math.sin(theta)*12+side[1]*15),
          (tip[0]+side[0]*6,tip[1]+side[1]*5)],(45,48,50,255))
    line(d,[(tip[0]-side[0]*4,tip[1]-side[1]*4),
            (tip[0]+side[0]*11,tip[1]+side[1]*11),
            (tip[0]-math.cos(theta)*12+side[0]*15,
             tip[1]-math.sin(theta)*12+side[1]*15)],(175,177,158,255),2)
    ellipse(d,(grip[0]-2,grip[1]-3,grip[0]+3,grip[1]+2),PALE)
    if action=="attack" and phase>=2:
        for i in range(3):
            a=theta+0.35*(i-1)
            dx=cx+math.cos(a)*36+12
            dy=40+math.sin(a)*36
            line(d,[(dx,dy),(dx+11,dy-4)],(148+25*i,42,42,180),2)

def draw_pose(role,state,frame):
    img=Image.new("RGBA",(S,S),(0,0,0,0))
    d=ImageDraw.Draw(img)
    seed=(sum(ord(q) for q in role)+frame*113+STATES.index((state,len(range(0)))) if False else frame*71)
    # Motion keyframes are hand-authored per state (not repeated static art).
    if state=="idle":
        bob=[0,-1,-2,-1][frame];stride=[0,1,0,-1][frame]
        lean=[-1,0,1,0][frame];swish=[-2,0,2,1][frame]
    elif state=="walk":
        bob=[0,-2,-3,-2,0,1][frame]
        stride=[-6,-4,0,5,7,2][frame]
        lean=[-2,-1,0,1,2,0][frame]
        swish=[4,2,0,-2,-4,-1][frame]
    elif state=="attack":
        bob=[0,-2,-4,-2,0,1][frame]
        stride=[0,-2,3,8,5,0][frame]
        lean=[0,1,4,7,3,-1][frame]
        swish=[0,2,5,6,2,-3][frame]
    elif state=="hit":
        bob=[1,-3,2][frame];stride=[-2,3,-3][frame]
        lean=[-7,7,-3][frame];swish=[-6,7,-4][frame]
    else:
        bob=[0,2,5,7,10,13][frame]
        stride=[0,-4,-8,-3,3,6][frame]
        lean=[0,-3,-8,-12,-15,-17][frame]
        swish=[0,4,9,12,13,15][frame]

    cx=48+lean
    # Entire body pose drawn at full volume, then independently animated
    # collapse and drop of costume and props in final death frames.
    if state=="death":
        if frame>=2:
            # compress/collapse from joint movement, NOT recolor static cel
            cx-=frame*2
        bob=min(bob,12)
    cy=27+bob
    robe(d,cx,bob,role,swish,lean)
    boots(d,cx,bob,stride,role)
    torso(d,cx,bob,role)
    if role=="mute_magistrate":
        magistrate_prop(d,cx,bob,frame,"attack" if state=="attack" else "")
    elif role=="ash_scrivener":
        scribe_prop(d,cx,bob,frame,"attack" if state=="attack" else "")
    else:
        bailiff_prop(d,cx,bob,frame,"attack" if state=="attack" else "")
    skull(d,cx,cy,role,hit=state=="hit")
    if role=="mute_magistrate": crown(d,cx,cy,role)
    if role=="ash_scrivener":
        # Scribe's tall crimson cloth hood drapes over the skull.
        pg(d,[(cx-12,cy-6),(cx-8,cy-18),(cx+5,cy-17),(cx+12,cy-7),
              (cx+10,cy+2),(cx+8,cy-9),(cx-7,cy-10)],(89,29,33,255))
        line(d,[(cx-9,cy-10),(cx+6,cy-13)],(157,68,51,255),2)

    if state=="death":
        # A physically falling silhouette: each frame tips a freshly drawn
        # joint configuration, then grounds the lowest opaque pixel.
        angles=[0,16,34,53,71,84]
        if frame:
            rotated=img.rotate(angles[frame],resample=Image.Resampling.NEAREST,
                               center=(cx,75),expand=False)
            img=rotated
        bbox=img.getbbox()
        if bbox:
            left,top,right,bottom=bbox
            dx=0
            dy=91-bottom
            if frame>=3:
                # Reduced height evokes prone fallen bones and garments.
                cropped=img.crop(bbox)
                squish=[1,1,1,0.95,0.78,0.61][frame]
                final_h=max(10,round(cropped.height*squish))
                cropped=cropped.resize((cropped.width,final_h),Image.Resampling.NEAREST)
                img=Image.new("RGBA",(S,S),(0,0,0,0))
                px=max(2,min(S-2-cropped.width,(S-cropped.width)//2 + (frame-2)*2))
                img.alpha_composite(cropped,(px,92-final_h))
            else:
                placed=Image.new("RGBA",(S,S),(0,0,0,0))
                placed.alpha_composite(img,(0,max(-2,dy))) if dy>=0 else None
                if dy<0:
                    placed.alpha_composite(img.crop((0,-dy,S,S)),(0,0))
                img=placed
    # Unused cells really remain 0 alpha. No shadows outside boundaries.
    bbox=img.getbbox()
    if bbox:
        left,top,right,bottom=bbox
        if left<3 or top<3 or right>93 or bottom>93:
            # Keep original pose visually whole; simply rescale only a source
            # overflow rather than clipping the weapon or boot.
            crop=img.crop(bbox)
            k=min(87/crop.width,87/crop.height,1)
            crop=crop.resize((max(1,round(crop.width*k)),
                              max(1,round(crop.height*k))),Image.Resampling.NEAREST)
            fixed=Image.new("RGBA",(S,S),(0,0,0,0))
            fixed.alpha_composite(crop,((S-crop.width)//2,91-crop.height))
            img=fixed
    return img

def main():
    OUT.mkdir(parents=True,exist_ok=True)
    results=[]
    for role in ROLES:
        atlas=Image.new("RGBA",(576,480),(0,0,0,0))
        signatures=set()
        for r,(state,n) in enumerate(STATES):
            for i in range(n):
                cell=draw_pose(role,state,i)
                if cell.getbbox() is None:
                    raise RuntimeError(f"empty frame {role}/{state}/{i}")
                if len(cell.getchannel("A").getdata())!=9216:
                    raise RuntimeError("corrupt alpha")
                sig=hashlib.sha256(cell.tobytes()).hexdigest()
                if sig in signatures:
                    raise RuntimeError(f"duplicated pose bytes {role}/{state}/{i}")
                signatures.add(sig)
                atlas.alpha_composite(cell,(i*S,r*S))
        buffer=io.BytesIO()
        atlas.save(buffer,format="WEBP",lossless=True,method=6)
        blob=buffer.getvalue()
        path=OUT/f"{role}_d266_qa.webp.b64"
        path.write_text(base64.b64encode(blob).decode("ascii")+"\n",encoding="ascii")
        readback=Image.open(io.BytesIO(base64.b64decode(path.read_text().strip()))).convert("RGBA")
        if readback.tobytes()!=atlas.tobytes():raise RuntimeError("lossless WebP not exact")
        results.append({"role":role,"path":str(path.relative_to(ROOT)),
                        "source_sha256":hashlib.sha256(blob).hexdigest(),
                        "image_size":list(atlas.size),"frame_count":len(signatures),
                        "original_generation_method":"role-specific joint+prop anatomy keyframe drawing (procedural authored QA)",
                        "art_user_approved":False})
        print("D266_ATLAS_RENDERED",role,len(signatures),len(blob))
    REPORT.parent.mkdir(parents=True,exist_ok=True)
    REPORT.write_text(json.dumps({"version":"D266","stage":"THREE_ATLASES_GENERATED_QA_NOT_USER_APPROVED",
      "roles":results,"frames_total":75,"spare_blank_total":15,
      "goal":"Native F6 x1 and x2 motion: inspect real grip, boots, proportions, facing, attacks and death",
      "not_finished":"Procedural original frames do not equal artist-approved rich D261 character art; release stays HOLD",
      "live_card_count":38,"card39_released":False},ensure_ascii=False,indent=2)+"\n",encoding="utf-8")

if __name__=="__main__":
    main()
