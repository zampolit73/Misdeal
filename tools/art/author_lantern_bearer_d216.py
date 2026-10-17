#!/usr/bin/env python3
"""D216 Lantern Bearer: 25 distinct original pixel-art animation drawings.

Independent per-state art direction with articulated shield/lantern/limb positions.
Godot's 6x5 row-per-state atlas (576x480, 96px cells), alpha-safe margins.
Art is a QA candidate, not native/user-approved game media.
Run: python tools/art/author_lantern_bearer_d216.py
Uses helper pixel brushwork in tools/art/author_road_sentinel_d215.py.
"""
from pathlib import Path
from PIL import Image, ImageDraw
import hashlib, io, json, base64, math, random
from author_road_sentinel_d215 import COL, poly, line, dot, bone, joint, skull, lantern

OUT=Path(__file__).resolve().parent
S=96
STATES=[('idle',4),('walk',6),('attack',6),('hit',3),('death',6)]
COL.update({
    'oak_dark':(55,37,29,255),'oak':(105,68,43,255),'oak_hi':(145,98,57,255),
    'oak_glint':(178,133,73,255),'shield_iron':(55,59,61,255),
    'shield_edge':(107,105,92,255),'ash':(106,111,108,255),
})

def segment(d,a,b,kind='bone',thick=4):
    if kind=='bone':bone(d,a,b,thick)
    else:
        line(d,[a,b],'ink',thick+2)
        line(d,[a,b],kind,thick)

def plank_shield(img,d,center,angle=0,ground=False,drop=False):
    """Pixel-native rectangular barricade with three independently drawn old planks.

    Tilt affects plank upper-left/lower-right and decorative iron frame;
    drawn AFTER near arm so attack's actual board strike stays readable.
    """
    x,y=center
    if ground:
        # board drops to ground, broad angled fallen plank barrier
        pts=[(x-23,y-4),(x+23,y-7),(x+27,y+6),(x-20,y+8)]
        poly(d,pts,'oak_dark')
        for k in range(3):
            xx=x-20+k*15
            line(d,[(xx,y-4),(xx+3,y+7)],'oak',4)
            line(d,[(xx+2,y-3),(xx+4,y+6)],'oak_hi',1)
        line(d,[(x-21,y+2),(x+22,y-1)],'shield_edge',3)
        for px in (x-12,x+1,x+15):dot(d,px,y+1,'rust',2)
        return
    skew=float(angle)
    corners=[(x-12+skew*0.7,y-27),(x+11+skew*0.7,y-25),
             (x+12-skew*0.65,y+26),(x-11-skew*0.65,y+27)]
    poly(d,corners,'ink')
    for col in range(3):
        xb=x-9+col*7
        p1=(xb+skew*0.65,y-23)
        p2=(xb-skew*0.6,y+22)
        line(d,[p1,p2],'oak_dark',8)
        line(d,[(p1[0]+1,p1[1]),(p2[0]+1,p2[1])],'oak',5)
        line(d,[(p1[0]+3,p1[1]+1),(p2[0]+3,p2[1]-1)],'oak_hi',1)
        for k in range(4):
            step=int(-19+k*12)
            dot(d, xb-1+skew*step/35, y+step,'oak_glint',1)
    line(d,[(x-12+skew*0.7,y-15),(x+11+skew*0.7,y-14)],'shield_edge',3)
    line(d,[(x-12-skew*0.6,y+12),(x+11-skew*0.6,y+12)],'shield_edge',3)
    for rx,ry in [(-8,-14),(7,-13),(-8,13),(7,13)]:
        dot(d,x+rx+skew*0.35,y+ry,'rust',2)
    # battered central guard-boss / big readable identity
    xx=x+skew*0.05
    d.ellipse((xx-4,y-2,xx+6,y+8),fill=COL['ink'])
    d.ellipse((xx-3,y-1,xx+5,y+7),fill=COL['shield_iron'])
    d.line([(xx-2,y+1),(xx+3,y+2)],fill=COL['shield_edge'],width=2)
    dot(d,xx,y+5,'bronze',2)

def draw_chest(d,shoulder,hip,poseindex):
    sx,sy=shoulder;hx,hy=hip
    poly(d,[(sx-14,sy-4),(sx-7,sy-8),(sx+9,sy-7),(sx+14,sy+2),
            (hx+10,hy-6),(hx+6,hy+12),(hx-11,hy+12),(sx-12,sy+8)],'cloth')
    poly(d,[(sx-9,sy+4),(sx+6,sy+8),(hx+5,hy-5),(hx-9,hy-4)],'metal')
    line(d,[(sx-8,sy-2),(sx+8,sy-3)],'metal_hi',2)
    # thick bony rib cage + leather/reinforced straps
    for k in range(4):
        dy=k*3
        line(d,[(sx-10,sy+dy),(sx+5,sy+dy+1)],'bone_shadow',3)
        line(d,[(sx-9,sy+dy),(sx+4,sy+dy+1)],'bone',1)
    line(d,[(sx-10,sy-7),(hx-1,hy+3)],'leather',3)
    line(d,[(sx+5,sy-6),(hx+7,hy+5)],'leather',2)
    dot(d,hx+1,hy-3,'bronze',2)
    # broad mismatched shoulder rim visible above plank
    poly(d,[(sx+4,sy-11),(sx+16,sy-11),(sx+20,sy-4),(sx+17,sy+4),
            (sx+8,sy+4),(sx+2,sy-2)],'metal')
    line(d,[(sx+6,sy-9),(sx+14,sy-10),(sx+17,sy-4)],'metal_hi',2)
    for r in ((7,-7),(15,-5),(12,2)):dot(d,sx+r[0],sy+r[1],'rust',2)
    # dangling strips remain inside cell in standing poses
    if hip[1]<70:
        poly(d,[(hx+5,hy+5),(hx+15,hy+14),(hx+13,hy+21),(hx+8,hy+14),(hx+1,hy+17)],'cloth2')

def boot(d,pt,left=False):
    x,y=pt
    poly(d,[(x-4,y-6),(x+4,y-7),(x+5,y-2),(x-6,y-1)],'metal')
    line(d,[(x-6,y-2),(x+4,y-2)],'metal_hi',1)
    dot(d,x-1,y-5,'rust',2)

def pose_config(state,i):
    # Coordinates define independent combat motion, NOT shifted clones of one sprite.
    base=dict(H=(54,25),S=(57,40),P=(54,59),LK=(46,77),RK=(65,77),
              LF=(41,91),RF=(72,91),SH=(30,54),A=0,LAMP=(75,52),
              ELB=(69,48),HAND=(73,54),SEL=(45,46),SHAND=(43,55),
              DROPPED=False,GROUND=False,LAMP_DOWN=False)
    if state=='idle':
        poses=[
            {},
            {'H':(54,26),'S':(57,41),'P':(54,60),'LAMP':(76,53),'LK':(46,78),'RF':(71,91)},
            {'H':(53,24),'S':(56,39),'P':(54,59),'A':-2,'SH':(29,53),'LAMP':(76,54),'SHAND':(43,53)},
            {'H':(55,25),'S':(58,40),'P':(55,59),'A':1,'LAMP':(74,52),'LK':(47,76),'LF':(42,91)},
        ];base.update(poses[i])
    elif state=='walk':
        poses=[
            {'LF':(38,88),'LK':(42,74),'RF':(70,91),'H':(53,24),'S':(56,39),'P':(53,59),'LAMP':(76,51)},
            {'LF':(34,91),'LK':(42,75),'RF':(70,90),'H':(52,25),'S':(56,41),'P':(52,61),'SH':(29,54),'LAMP':(77,53)},
            {'LF':(45,91),'LK':(47,76),'RF':(70,91),'H':(55,27),'S':(58,42),'P':(55,61),'SH':(32,54),'LAMP':(79,55)},
            {'LF':(45,91),'LK':(47,76),'RF':(75,88),'RK':(72,72),'H':(55,24),'S':(58,40),'P':(54,59),'LAMP':(76,51)},
            {'LF':(44,90),'LK':(46,76),'RF':(77,91),'RK':(67,76),'H':(56,25),'S':(59,40),'P':(55,60),'SH':(32,55),'LAMP':(74,53)},
            {'LF':(40,91),'LK':(45,76),'RF':(71,91),'RK':(66,77),'H':(54,26),'S':(57,41),'P':(54,59),'LAMP':(76,54)},
        ];base.update(poses[i])
    elif state=='attack':
        poses=[
            {'H':(54,24),'SH':(31,52),'A':-1,'LAMP':(76,48),'S':(56,39),'SHAND':(43,51)},
            {'H':(57,27),'S':(59,44),'P':(58,61),'SH':(35,53),'A':4,'LF':(43,91),'RF':(76,91),'LAMP':(77,47)},
            {'H':(48,27),'S':(50,43),'P':(55,60),'SH':(24,53),'A':-5,'LF':(36,91),'RF':(74,90),'SHAND':(35,50),'LAMP':(77,52)},
            {'H':(46,26),'S':(49,42),'P':(54,60),'SH':(23,51),'A':-8,'LF':(34,91),'RF':(76,91),'SHAND':(35,49),'LAMP':(76,56)},
            {'H':(50,28),'S':(53,44),'P':(55,61),'SH':(27,53),'A':-4,'LF':(37,91),'RF':(74,91),'LAMP':(78,57)},
            {'H':(54,25),'S':(57,40),'SH':(30,54),'A':0,'LAMP':(75,52),'LF':(41,91),'RF':(72,91)},
        ];base.update(poses[i])
    elif state=='hit':
        poses=[
            {'H':(58,25),'S':(62,42),'P':(57,60),'SH':(33,58),'A':7,'LAMP':(77,57),'RF':(74,91)},
            {'H':(62,29),'S':(63,46),'P':(60,63),'SH':(39,58),'A':11,'LAMP':(76,59),'LF':(44,91),'RF':(79,91)},
            {'H':(57,26),'S':(60,42),'P':(56,60),'SH':(32,54),'A':2,'LAMP':(75,55),'LF':(43,91)},
        ];base.update(poses[i])
    elif state=='death':
        poses=[
            {'H':(55,28),'S':(58,44),'P':(55,65),'SH':(31,58),'A':9,'LF':(41,91),'RF':(72,91),'LAMP':(76,56)},
            {'H':(58,34),'S':(60,51),'P':(56,69),'SH':(38,61),'A':15,'LK':(43,82),'RK':(65,83),'LF':(36,91),'RF':(72,91),'LAMP':(77,62)},
            {'H':(55,47),'S':(57,57),'P':(54,74),'SH':(39,72),'A':19,'LK':(41,86),'RK':(62,85),'LF':(36,91),'RF':(70,91),'LAMP':(79,74)},
            {'H':(48,66),'S':(53,72),'P':(58,82),'SH':(44,81),'A':25,'LK':(46,86),'RK':(67,88),'LF':(37,91),'RF':(74,91),'LAMP':(78,79),'GROUND':True},
            {'H':(34,80),'S':(46,79),'P':(61,84),'SH':(45,85),'LK':(59,88),'RK':(74,89),'LF':(38,91),'RF':(79,91),'LAMP':(75,78),'GROUND':True},
            {'H':(32,81),'S':(48,80),'P':(63,85),'SH':(45,84),'LK':(63,88),'RK':(76,89),'LF':(40,91),'RF':(80,91),'LAMP':(74,77),'GROUND':True},
        ];base.update(poses[i])
    return base

def draw_frame(state,i):
    q=pose_config(state,i)
    img=Image.new('RGBA',(96,96),(0,0,0,0));d=ImageDraw.Draw(img)
    h=q['H'];sh=q['S'];hip=q['P']
    isdeath=state=='death'
    # cloak underneath the bone rig
    if isdeath and i>=3:
        poly(d,[(hip[0]-19,hip[1]-4),(hip[0]+13,hip[1]-9),(hip[0]+20,hip[1]+2),(hip[0]-12,hip[1]+7)],'cloth')
    else:
        poly(d,[(sh[0]-15,sh[1]-7),(sh[0]+13,sh[1]+1),(hip[0]+10,hip[1]+3),
                (hip[0]+12,min(87,hip[1]+17)),(hip[0]-10,min(87,hip[1]+21)),(hip[0]-14,hip[1]+2)],'cloth')
    # near and far legs with consistent contact
    segment(d,hip,q['RK'],thick=6);joint(d,q['RK'],3);segment(d,q['RK'],q['RF'],thick=5);boot(d,q['RF'])
    segment(d,hip,q['LK'],thick=6);joint(d,q['LK'],3);segment(d,q['LK'],q['LF'],thick=5);boot(d,q['LF'])
    draw_chest(d,sh,hip,i)
    # skull/neck
    bone(d,(sh[0]-5,sh[1]-7),(h[0],h[1]+7),4)
    skull(d,*h)
    # Lantern in OFF HAND (right side), never on/inside board
    rshould=(sh[0]+12,sh[1]-3)
    relbow=q['ELB']
    if isdeath and i>2:relbow=(sh[0]+11,sh[1]+6)
    rhand=(q['LAMP'][0]-3,q['LAMP'][1]-9)
    bone(d,rshould,relbow,4);joint(d,relbow,2);bone(d,relbow,rhand,3);joint(d,rhand,2)
    if not (isdeath and i>=4):
        lantern(d,q['LAMP'][0],q['LAMP'][1],swing=[0,1,2,0,-1,-2][i%6]);
    else:
        # fallen oil lamp at boot line, smaller dim aura but clearly a separate object
        lantern(d,74,77,-1)
    # Plank-bearing LEFT ARM, joint visible above board
    lshould=(sh[0]-10,sh[1]-4);lelbow=q['SEL'];lhand=q['SHAND']
    if state=='attack' and i in (2,3,4):
        lelbow=(35,46);lhand=(36,56)
    if isdeath and i>=3:
        lelbow=(sh[0]-14,sh[1]+3);lhand=(38,85)
    bone(d,lshould,lelbow,5);joint(d,lelbow,3);bone(d,lelbow,lhand,4);joint(d,lhand,3)
    plank_shield(img,d,q['SH'],q['A'],q['GROUND'])
    if state == "death" and i >= 2:
        # Keep collapsing shield and lantern clear of 96px cel edge.
        shifted = Image.new("RGBA", (96,96), (0,0,0,0))
        shifted.alpha_composite(img, (0,-3))
        img = shifted
    # deterministic bronze ash/iron detail without alpha noise
    rng=random.Random(21600+['idle','walk','attack','hit','death'].index(state)*10+i)
    p=img.load()
    for _ in range(14):
        x=rng.randint(20,83);y=rng.randint(24,88)
        if p[x,y]==COL['cloth']:p[x,y]=COL['cloth2']
        elif p[x,y]==COL['oak']:p[x,y]=COL['oak_hi']
    return img

def main():
    OUT.mkdir(parents=True,exist_ok=True)
    atlas=Image.new('RGBA',(576,480),(0,0,0,0));frames=[]
    for row,(state,count) in enumerate(STATES):
        for col in range(count):
            cel=draw_frame(state,col)
            atlas.alpha_composite(cel,(col*S,row*S))
            frames.append((state,col,cel))
    hashes={hashlib.sha256(im.tobytes()).hexdigest() for _,_,im in frames}
    report={'atlas_size':[576,480],'cells':[6,5],'state_counts':dict(STATES),'nonempty':0,'unique':len(hashes),'empty':0,'border_warnings':[],'bbox':{}}
    for state,i,cel in frames:
        bb=cel.getchannel('A').getbbox()
        if bb: report['nonempty']+=1
        report['bbox'][f'{state}_{i+1}']=bb
        for edge,rect in [('left',(0,0,2,96)),('right',(94,0,96,96)),('top',(0,0,96,2)),('bottom',(0,94,96,96))]:
            if cel.getchannel('A').crop(rect).getbbox():report['border_warnings'].append(f'{state}_{i+1}_{edge}')
    for row,(_,count) in enumerate(STATES):
        for col in range(count,6):
            if atlas.crop((col*96,row*96,(col+1)*96,(row+1)*96)).getbbox():raise RuntimeError('Unexpected opacity in unused slot')
            report['empty']+=1
    if len(hashes)!=25 or report['nonempty']!=25 or report['empty']!=5:raise RuntimeError('Atlas identity QC failed')
    atlas.save(OUT/'lantern_bearer_d216_candidate.png')
    atlas.save(OUT/'lantern_bearer_d216_candidate.webp',format='WEBP',lossless=True,method=6)
    (OUT/'lantern_bearer_d216_candidate.webp.b64').write_text(base64.b64encode((OUT/'lantern_bearer_d216_candidate.webp').read_bytes()).decode('ascii')+'\n',encoding='ascii')
    (OUT/'d216_art_qc.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
    # Contact sheet (checkerboard is only presentation preview, NOT atlas image)
    bg=Image.new('RGB',(1440,1090),(20,22,27));b=ImageDraw.Draw(bg)
    b.text((48,27),'D216  /  LANTERN BEARER  /  25 AUTHORED PIXEL ART ANIMATION POSES',fill=(220,208,183))
    b.text((48,53),'ORIGINAL SHIELD + HEAVY LANTERN  |  RGBA 576x480  |  GODOT ROW STATE GRID  |  QA ONLY',fill=(144,165,156))
    checker=Image.new('RGBA',(576,480),(42,47,51,255));cd=ImageDraw.Draw(checker)
    for y in range(0,480,12):
        for x in range(0,576,12):
            if (x//12+y//12)%2==0:cd.rectangle((x,y,x+11,y+11),fill=(53,58,62,255))
    checker.alpha_composite(atlas)
    enlarged=checker.resize((1152,960),Image.Resampling.NEAREST).convert('RGB')
    bg.paste(enlarged,(205,92))
    for row,(state,count) in enumerate(STATES):
        y=92+row*192
        b.text((26,y+68),f'{state.upper()} ({count})',fill=(209,189,161))
        b.line([(205,y),(1357,y)],fill=(85,88,89),width=1)
    for c in range(7):b.line([(205+c*192,92),(205+c*192,1052)],fill=(87,90,91),width=1)
    bg.save(OUT/'D216_bearer_animation_contact_sheet.png')
    print(json.dumps({k:v for k,v in report.items() if k!='bbox'},ensure_ascii=False,indent=2))
    print('webp size', (OUT/'lantern_bearer_d216_candidate.webp').stat().st_size)
if __name__=='__main__': main()