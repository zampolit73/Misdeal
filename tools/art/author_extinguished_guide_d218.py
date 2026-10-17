#!/usr/bin/env python3
"""D218: original QA-only 25-cel pixel poses for the double-height Extinguished Guide.
Godot still uses 96px sprites with visual_scale=1.8: artwork is drawn tall,
no enlarged collider or production role registration. Requires only Pillow offline.
"""
from PIL import Image, ImageDraw
from pathlib import Path
import base64, hashlib, json, math, random

OUT = Path(__file__).resolve().parent
S = 96
STATES = [('idle', 4), ('walk', 6), ('attack', 6), ('hit', 3), ('death', 6)]
C = dict(ink='#111820', mantle='#212832', mantle2='#303946', mantle3='#424751',
 bone_sh='#66675b', bone='#b0a790', bone_hi='#d2c3a1', iron='#343940',
 iron_hi='#7e8079', chain='#706c61', amber='#b67d39', ember='#efb34f', flame='#ffd176',
 rust='#7f4b35', leather='#644432', dark='#171d23', eye='#ffba61')

def L(d, pts, fill, width=1): d.line([(round(x),round(y)) for x,y in pts],fill=C.get(fill,fill),width=width,joint='curve')
def P(d, pts, fill, outline='ink'):
    p=[(round(x),round(y)) for x,y in pts];d.polygon(p,fill=C.get(fill,fill))
    if outline:d.line(p+[p[0]],fill=C.get(outline,outline),width=1,joint='curve')
def E(d,box,fill,outline='ink'):
    d.ellipse(tuple(round(v) for v in box),fill=C.get(fill,fill),outline=C.get(outline,outline) if outline else None)
def DOT(d,x,y,c,size=1): d.rectangle((round(x),round(y),round(x)+size-1,round(y)+size-1),fill=C.get(c,c))
def BONE(d,a,b,w=4):
    L(d,[a,b],'ink',w+2);L(d,[a,b],'bone_sh',w);L(d,[(a[0],a[1]-1),(b[0],b[1]-1)],'bone',max(1,w-2))
def lamp(d,x,y,lit=True):
    # Real 8x12 hinged cage, NO world-glow VFX baked into the art.
    x=round(x);y=round(y)
    P(d,[(x-5,y),(x+4,y),(x+5,y+11),(x-4,y+11)],'iron')
    d.rectangle((x-3,y+2,x+3,y+9),fill=C['amber'] if lit else C['rust'])
    if lit:d.rectangle((x-1,y+3,x+1,y+8),fill=C['flame'])
    L(d,[(x-5,y+9),(x+5,y+9)],'iron_hi',2)
    L(d,[(x-5,y+1),(x+4,y+1)],'iron_hi',1)
    DOT(d,x,y+12,'rust')
def skull(d,x,y,tilt=0):
    x=round(x);y=round(y)
    P(d,[(x-7,y-6),(x-4,y-9),(x+3,y-9),(x+7,y-5),(x+7,y+1),(x+4,y+5),(x-4,y+4),(x-7,y+1)],'bone_sh')
    P(d,[(x-6,y-6),(x-3,y-8),(x+3,y-8),(x+6,y-5),(x+5,y+1),(x-3,y+4),(x-6,y+1)],'bone')
    P(d,[(x-6,y-1),(x-2,y-2),(x-2,y+1),(x-6,y+1)],'ink',None)
    P(d,[(x+1,y-2),(x+5,y-2),(x+5,y+1),(x+1,y+1)],'ink',None)
    DOT(d,x-4,y-1,'eye');DOT(d,x+3,y-1,'eye')
    L(d,[(x-4,y+5),(x+5,y+5)],'bone_hi',2)
    for q in (-3,0,3):DOT(d,x+q,y+6,'ink')
    DOT(d,x-3,y-6,'bone_hi');DOT(d,x+2,y-6,'bone_hi')

def config(st,i):
    # Local coordinates; all 25 poses explicitly determine physically distinct joints.
    p=dict(H=(43,29),S=(48,41),HIP=(48,65),LK=(35,77),RK=(62,77),LF=(27,91),RF=(66,91),
           ARM=(69,50),HAND=(76,57),LH=(30,62),CROSS=(55,27),TILT=0, SWAY=0,
           CHAIN=(0,0,0),FRAME=0, GROUND=False, LIT=True)
    if st=='idle':
        v=[{},
           dict(H=(43,30),S=(48,42),HIP=(48,66),CROSS=(54,28),CHAIN=(0,1,-1),SWAY=1),
           dict(H=(44,28),S=(49,40),HIP=(48,64),LF=(28,91),CROSS=(56,26),CHAIN=(-1,2,0),TILT=1),
           dict(H=(43,29),S=(48,41),HIP=(47,65),RF=(65,91),CHAIN=(0,-1,1),TILT=-1)]
        p.update(v[i])
    elif st=='walk':
        v=[dict(LF=(26,87),LK=(32,76),RF=(66,91),H=(42,28),S=(46,40),HIP=(45,64),CHAIN=(2,1,-1),SWAY=-2),
           dict(LF=(23,91),LK=(32,78),RF=(66,91),H=(41,30),S=(45,43),HIP=(45,67),CHAIN=(3,1,-1),SWAY=-2),
           dict(LF=(38,91),LK=(36,77),RF=(67,91),H=(43,31),S=(47,43),HIP=(47,66),CHAIN=(1,2,-2),SWAY=-1),
           dict(LF=(36,91),LK=(40,78),RF=(69,86),RK=(63,73),H=(45,28),S=(49,40),HIP=(49,64),CHAIN=(-1,-2,2),SWAY=2),
           dict(LF=(36,91),LK=(40,79),RF=(72,91),RK=(65,79),H=(46,30),S=(51,42),HIP=(50,67),CHAIN=(-3,-1,2),SWAY=3),
           dict(LF=(30,91),LK=(36,77),RF=(66,91),RK=(62,76),H=(44,29),S=(48,41),HIP=(48,65),CHAIN=(-1,0,1),SWAY=1)]
        p.update(v[i])
    elif st=='attack':
        v=[dict(H=(42,28),S=(47,39),HIP=(48,64),CROSS=(55,26),TILT=-3,CHAIN=(-2,0,2),ARM=(68,46),HAND=(75,49)),
           dict(H=(45,30),S=(51,45),HIP=(52,67),CROSS=(61,29),TILT=4,CHAIN=(-3,0,2),LF=(31,91),RF=(68,91),ARM=(69,53),HAND=(76,56)),
           dict(H=(39,29),S=(43,42),HIP=(46,65),CROSS=(46,26),TILT=-9,CHAIN=(4,-1,0),LF=(22,91),RF=(65,91),ARM=(63,42),HAND=(70,43)),
           dict(H=(37,28),S=(41,41),HIP=(46,64),CROSS=(42,24),TILT=-12,CHAIN=(5,1,-2),LF=(20,91),RF=(67,91),ARM=(58,44),HAND=(63,49)),
           dict(H=(40,31),S=(45,44),HIP=(47,66),CROSS=(47,27),TILT=-7,CHAIN=(2,2,-1),LF=(23,91),RF=(68,91),ARM=(62,49),HAND=(69,53)),
           dict(H=(43,29),S=(48,41),HIP=(48,65),CROSS=(54,27),TILT=-1,CHAIN=(0,0,0),LF=(27,91),RF=(66,91))]
        p.update(v[i])
    elif st=='hit':
        v=[dict(H=(48,30),S=(53,43),HIP=(50,65),CROSS=(59,28),TILT=7,CHAIN=(-2,1,3),ARM=(73,50),HAND=(78,59)),
           dict(H=(52,35),S=(55,48),HIP=(53,68),CROSS=(61,32),TILT=11,CHAIN=(-4,3,5),LF=(32,91),RF=(73,91),ARM=(73,55),HAND=(79,63)),
           dict(H=(46,30),S=(50,42),HIP=(49,65),CROSS=(56,29),TILT=3,CHAIN=(-1,2,2),LF=(28,91),RF=(68,91))]
        p.update(v[i])
    else:
        v=[dict(H=(44,32),S=(49,45),HIP=(48,70),LK=(38,80),RK=(61,80),CROSS=(55,31),TILT=8,CHAIN=(2,3,2)),
           dict(H=(47,39),S=(52,52),HIP=(50,75),LK=(39,84),RK=(60,84),LF=(26,91),RF=(67,91),CROSS=(56,37),TILT=15,CHAIN=(1,2,2)),
           dict(H=(45,51),S=(51,61),HIP=(54,79),LK=(40,85),RK=(62,86),LF=(25,91),RF=(70,91),CROSS=(52,49),TILT=20,CHAIN=(0,1,1)),
           dict(H=(39,66),S=(47,74),HIP=(56,84),LK=(42,86),RK=(64,87),LF=(21,91),RF=(73,91),CROSS=(49,70),TILT=17,CHAIN=(0,0,0),GROUND=True),
           dict(H=(28,79),S=(43,81),HIP=(57,84),LK=(45,87),RK=(64,88),LF=(25,91),RF=(73,91),CROSS=(46,84),TILT=0,CHAIN=(0,0,0),GROUND=True,LIT=False),
           dict(H=(25,80),S=(42,82),HIP=(58,85),LK=(47,88),RK=(64,88),LF=(25,91),RF=(72,91),CROSS=(45,85),TILT=0,CHAIN=(0,0,0),GROUND=True,LIT=False)]
        p.update(v[i])
    return p

def paint(st,i):
    p=config(st,i);extra = st=='death' and i>=2
    img=Image.new('RGBA',(S,104 if extra else S),(0,0,0,0));d=ImageDraw.Draw(img)
    h=p['H'];s=p['S'];hip=p['HIP'];ground=p['GROUND'];sway=p['SWAY']
    # Long ragged mantle is a large back silhouette; leader is NOT a scaled footman.
    if not ground:
        P(d,[(s[0]-23,s[1]-5),(s[0]-15,s[1]-17),(s[0]+10,s[1]-14),(s[0]+23,s[1]-1),
              (hip[0]+20,hip[1]+7),(hip[0]+14,84),(hip[0]+5,80),
              (hip[0]-1,88),(hip[0]-12,80),(hip[0]-23,85),(hip[0]-19,hip[1]+3)],'mantle')
        P(d,[(s[0]-19,s[1]-2),(s[0]-10,s[1]+3),(hip[0]-17,hip[1]+16),(hip[0]-22,83)],'mantle2')
        P(d,[(s[0]+9,s[1]+4),(s[0]+17,s[1]+8),(hip[0]+11,82),(hip[0]+5,76)],'mantle2')
    else:
        P(d,[(20,79),(34,74),(58,76),(79,86),(76,90),(40,91),(13,88)],'mantle')
        L(d,[(23,85),(73,88)],'mantle3',2)
    # Both legs and feet remain present, with distinct grounded walk pose.
    for k,f in [('RK','RF'),('LK','LF')]:
        BONE(d,hip,p[k],5);E(d,(p[k][0]-3,p[k][1]-3,p[k][0]+3,p[k][1]+3),'bone')
        BONE(d,p[k],p[f],4)
        x,y=p[f];P(d,[(x-5,y-3),(x+4,y-5),(x+7,y-2),(x-5,y-1)],'iron')
        L(d,[(x-4,y-4),(x+4,y-4)],'iron_hi',1)
    # Animated ribcage/body: chain-strapped ceremonial front with giant uneven pauldron.
    P(d,[(s[0]-14,s[1]-10),(s[0]+10,s[1]-7),(hip[0]+13,hip[1]-4),
          (hip[0]+6,hip[1]+5),(hip[0]-9,hip[1]+7),(s[0]-14,s[1]+5)],'iron')
    for k in range(4):
        L(d,[(s[0]-9,s[1]-1+4*k),(s[0]+8,s[1]+4*k)],'bone_sh',3)
        L(d,[(s[0]-7,s[1]-1+4*k),(s[0]+5,s[1]+4*k)],'bone',1)
    P(d,[(s[0]-20,s[1]-14),(s[0]-11,s[1]-20),(s[0]+1,s[1]-14),(s[0]+5,s[1]-2),(s[0]-10,s[1]+2)],'iron')
    L(d,[(s[0]-17,s[1]-12),(s[0]-10,s[1]-16)],'iron_hi',3)
    P(d,[(s[0]+8,s[1]-13),(s[0]+18,s[1]-12),(s[0]+22,s[1]-3),(s[0]+16,s[1]+3),(s[0]+6,s[1])],'mantle3')
    DOT(d,s[0]-10,s[1]-7,'rust',2);DOT(d,s[0]+13,s[1]-5,'amber',2)
    # Exposed cervical bones and skull, hunch but head still readable.
    BONE(d,(s[0]-4,s[1]-10),(h[0],h[1]+5),3)
    skull(d,h[0],h[1])
    # Palms grasp a heavy cross-yoke while hanging cages swing on chains.
    left=(s[0]-17,s[1]+8);rshould=(s[0]+16,s[1]-2)
    BONE(d,left,p['LH'],4)
    BONE(d,rshould,p['ARM'],4);BONE(d,p['ARM'],p['HAND'],3)
    for hand in (p['LH'],p['HAND']):E(d,(hand[0]-2,hand[1]-2,hand[0]+2,hand[1]+2),'bone')
    cx,cy=p['CROSS'];angle=p['TILT'];chs=p['CHAIN']
    if not ground:
        beam=((max(14,cx-33),cy+round(angle*0.2)),(min(81,cx+23),cy-round(angle*0.25)))
        L(d,beam,'ink',6);L(d,beam,'iron',4);L(d,beam,'iron_hi',1)
        L(d,[(cx+14,cy-8),(cx+14,cy+7)],'iron',4)
        L(d,[(cx+14,cy-10),(cx+14,cy+7)],'iron_hi',1)
        # Three independently swinging lanterns; no VFX damage radius in art.
        supports=[(max(15,cx-27),cy+2, 37, chs[0]),(min(81,cx+21),cy-2, 40, chs[1]),(min(78,cx+12),cy+2,60,chs[2])]
        for index,(sx,sy,target,lag) in enumerate(supports):
            ey=min(78,sy+(target-23)+(1 if index==2 else 0))
            ex=min(84,max(11,sx+lag))
            L(d,[(sx,sy),(sx+(ex-sx)//2,sy+8),(ex,ey-4)],'ink',3)
            L(d,[(sx,sy),(sx+(ex-sx)//2,sy+8),(ex,ey-4)],'chain',1)
            for z in range(2):DOT(d,sx+(ex-sx)*z/3,sy+5+z*5,'iron_hi',1)
            lamp(d,ex,ey,p['LIT'])
    else:
        # Heavy fallen yoke along ground, detached cages remain inside cel.
        L(d,[(14,86),(80,89)],'ink',5);L(d,[(15,85),(78,88)],'iron_hi',2)
        lamp(d,16,79,p['LIT']);lamp(d,67,78,p['LIT']);lamp(d,80,76,False)
    # Restrained cloth/metal age spots; seeded, no transparent-noise pixels.
    rng=random.Random(218000+['idle','walk','attack','hit','death'].index(st)*10+i)
    pixels=img.load()
    for _ in range(16):
        x=rng.randint(19,76);y=rng.randint(25,86)
        if pixels[x,y] == tuple(bytes.fromhex(C['mantle'].lstrip('#')))+(255,):
            pixels[x,y]=tuple(bytes.fromhex(C['mantle2'].lstrip('#')))+(255,)
    # Render tall death geometry to an expanded canvas BEFORE lifting it into
    # the cel. Unlike cropping, this keeps low ribs, bones and lantern intact.
    return img.crop((0,3,S,99)) if extra else img

def main():
    OUT.mkdir(parents=True,exist_ok=True)
    atlas=Image.new('RGBA',(576,480),(0,0,0,0));frames=[]
    for row,(st,n) in enumerate(STATES):
        for col in range(n):
            im=paint(st,col);atlas.alpha_composite(im,(col*S,row*S));frames.append((st,col,im))
    hashes={hashlib.sha256(im.tobytes()).hexdigest() for _,_,im in frames}
    report=dict(atlas_size=[576,480],cell=[96,96],rows=dict(STATES),nonempty=0,distinct=len(hashes),clear_unused=0,border_warnings=[],bbox={})
    for st,col,im in frames:
        box=im.getchannel('A').getbbox()
        if box:report['nonempty']+=1
        report['bbox'][f'{st}_{col+1}']=box
        a=im.getchannel('A')
        for edge,rect in [('left',(0,0,2,96)),('right',(94,0,96,96)),('top',(0,0,96,2)),('bottom',(0,94,96,96))]:
            if a.crop(rect).getbbox():report['border_warnings'].append(f'{st}_{col+1}_{edge}')
    for row,(st,n) in enumerate(STATES):
        for col in range(n,6):
            if atlas.crop((col*96,row*96,(col+1)*96,(row+1)*96)).getbbox():raise RuntimeError('Unused cell contains data')
            report['clear_unused']+=1
    if report['nonempty']!=25 or report['distinct']!=25 or report['clear_unused']!=5:raise RuntimeError('bad frame count or duplicate')
    atlas.save(OUT/'extinguished_guide_d218_candidate.png')
    atlas.save(OUT/'extinguished_guide_d218_candidate.webp',format='WEBP',lossless=True,method=6)
    webp=(OUT/'extinguished_guide_d218_candidate.webp').read_bytes()
    (OUT/'extinguished_guide_d218_candidate.webp.b64').write_text(base64.b64encode(webp).decode('ascii')+'\n',encoding='ascii')
    report['webp_sha256']=hashlib.sha256(webp).hexdigest()
    (OUT/'d218_art_qc.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf8')
    board=Image.new('RGB',(1485,1086),(23,24,30));d=ImageDraw.Draw(board)
    d.text((24,23),'D218 / EXTINGUISHED GUIDE / ORIGINAL 25 FRAME QA CANDIDATE / 96PX CELLS',fill=(223,205,175))
    d.text((24,47),'LARGE PROCESSION LEADER / THREE CHAINED LANTERNS / GODOT 6x5 STATE-ROW PACK / ART REVIEW',fill=(150,160,156))
    ck=Image.new('RGBA',(576,480),(39,43,48,255));cd=ImageDraw.Draw(ck)
    for y in range(0,480,12):
        for x in range(0,576,12):
            if (x//12+y//12)%2==0:cd.rectangle((x,y,x+11,y+11),fill=(52,56,61,255))
    ck.alpha_composite(atlas)
    board.paste(ck.resize((1152,960),Image.Resampling.NEAREST).convert('RGB'),(245,92))
    for row,(name,n) in enumerate(STATES):d.text((34,150+row*192),name.upper()+f' ({n})',fill=(220,188,143))
    for col in range(7):d.line([(245+col*192,92),(245+col*192,1052)],fill=(95,101,98),width=1)
    for row in range(6):d.line([(245,92+row*192),(1397,92+row*192)],fill=(95,101,98),width=1)
    board.save(OUT/'D218_guide_animation_contact_sheet.png')
    print(json.dumps({k:v for k,v in report.items() if k!='bbox'},ensure_ascii=False,indent=2))
    if report['border_warnings']:raise RuntimeError('border warnings detected - correct source poses before GitHub')
if __name__=='__main__':main()