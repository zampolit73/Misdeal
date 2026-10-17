#!/usr/bin/env python3
"""D227: detailed B-style original 25-cel Road Sentinel, retaining D215 original pose contract.

Builds genuine hand-defined, per-pose joints with layered armor, tattered russet cloth; NOT
user/native-approved art. Original design is a plated bone guardsman with long SPEAR.
Dependencies: Pillow, Python 3. Geometry authored at native 96x96 un-antialiased pixels.
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import hashlib, io, json, base64, math, random

OUT = Path(__file__).resolve().parent
S=96
COL={
'ink':(15,15,20,255),'deep':(21,22,31,255),'cloth':(54,26,29,255),'cloth2':(78,31,37,255),
'cloth_hi':(119,52,42,255),'bone_shadow':(84,70,62,255),'bone':(172,150,117,255),
'bone_hi':(216,186,136,255),'bone_light':(239,214,157,255),'metal':(43,44,49,255),
'metal_hi':(116,109,101,255),'steel':(173,165,150,255),'rust':(128,77,44,255),
'bronze':(178,110,59,255),'flame':(246,163,48,255),'fire_hi':(255,215,105,255),
'eye':(233,129,43,255),'leather':(86,54,38,255),
 'iron_dark':(29,32,38,255),'iron_mid':(75,78,78,255),'iron_light':(149,142,128,255),
 'copper_light':(198,139,78,255),'cloth_dark':(35,18,24,255),'cloth_light':(130,58,47,255),
 'glass':(115,59,28,255),'dim_amber':(187,93,30,255),'bone_low':(117,100,77,255)
}

def dot(draw,x,y,c,sz=1):
    draw.rectangle((round(x),round(y),round(x)+sz-1,round(y)+sz-1),fill=COL[c])
def poly(draw,points,fill,outline='ink',width=1):
    ps=[(round(x),round(y)) for x,y in points]
    draw.polygon(ps,fill=COL[fill])
    if outline:draw.line(ps+[ps[0]],fill=COL[outline],width=width,joint='curve')
def line(draw,points,fill,width=1):
    draw.line([(round(x),round(y)) for x,y in points],fill=COL[fill],width=width,joint='curve')
def bone(draw,a,b,thick=4):
    line(draw,[a,b],'ink',thick+2)
    line(draw,[a,b],'bone_shadow',thick)
    line(draw,[a,b],'bone',max(1,thick-1))
    # upper highlight on same diagonal
    aa=(a[0],a[1]-1);bb=(b[0],b[1]-1)
    line(draw,[aa,bb],'bone_hi',1)
def joint(draw,p,r=3):
    x,y=p
    draw.ellipse((x-r-1,y-r-1,x+r+1,y+r+1),fill=COL['ink'])
    draw.ellipse((x-r,y-r,x+r,y+r),fill=COL['bone'])
    dot(draw,x-1,y-1,'bone_hi')
def lantern(d,x,y,swing=0,brightness=1):
    # Designed at original 96px pixel density: antique chamfered hexagonal cage,
    # two chain segments, airy amber flame, iron cornerposts. Never a flat block.
    cx=round(x+swing);cy=round(y)
    line(d,[(round(x),cy-5),(cx,cy-3),(cx,cy)],'iron_light',1)
    d.ellipse((cx-2,cy-5,cx+2,cy-2),outline=COL['copper_light'],width=1)
    # Tapered iron shoulders and suspended base; no filled square silhouette.
    poly(d,[(cx-5,cy+2),(cx-3,cy),(cx+3,cy),(cx+5,cy+2)],'iron_dark',None)
    line(d,[(cx-3,cy),(cx+3,cy)],'copper_light',1)
    d.polygon([(cx-5,cy+2),(cx+5,cy+2),(cx+4,cy+12),(cx+2,cy+14),(cx-2,cy+14),(cx-4,cy+12)],fill=COL['iron_dark'])
    poly(d,[(cx-3,cy+3),(cx+3,cy+3),(cx+2,cy+11),(cx-2,cy+11)],'glass',None)
    line(d,[(cx,cy+10),(cx-1,cy+6),(cx+1,cy+3)],'flame',2)
    dot(d,cx,cy+4,'fire_hi',1)
    dot(d,cx-2,cy+9,'dim_amber',1)
    for side in (-4,4):
        line(d,[(cx+side,cy+2),(cx+side-(1 if side<0 else -1),cy+12)],'iron_light',1)
        dot(d,cx+side,cy+5,'rust',1)
    line(d,[(cx-4,cy+12),(cx+4,cy+12)],'bronze',2)
    line(d,[(cx-3,cy+15),(cx+3,cy+15)],'iron_mid',2)
    dot(d,cx,cy+17,'copper_light')

def skull(d,x,y,tilt=0,dim=0):
    # Three-quarter LEFT skull: asymmetrical sockets, strong cheekbones and jaw,
    # narrow temple highlight for readable face against the deep burgundy hood.
    x=round(x);y=round(y)
    poly(d,[(x-7,y-8),(x-4,y-11),(x+3,y-11),(x+8,y-8),(x+8,y),(x+4,y+4),(x+1,y+8),(x-5,y+6),(x-8,y+1)],'ink',None)
    poly(d,[(x-6,y-8),(x-2,y-10),(x+4,y-9),(x+7,y-6),(x+7,y),(x+3,y+3),(x-1,y+5),(x-5,y+3),(x-7,y)],'bone_shadow',None)
    poly(d,[(x-6,y-7),(x-2,y-9),(x+3,y-9),(x+5,y-7),(x+5,y-4),(x+3,y-2),(x-5,y-2)],'bone',None)
    line(d,[(x-5,y-8),(x-2,y-9),(x+1,y-9)],'bone_light',1)
    line(d,[(x-7,y-3),(x+4,y-4)],'bone_hi',2)
    poly(d,[(x-6,y-3),(x-1,y-3),(x,y+1),(x-4,y+2),(x-6,y+1)],'ink',None)
    poly(d,[(x+2,y-3),(x+5,y-3),(x+5,y),(x+3,y+1)],'ink',None)
    dot(d,x-4,y-1,'eye');dot(d,x+3,y-1,'dim_amber')
    poly(d,[(x-2,y+1),(x,y+3),(x-2,y+4)],'ink',None)
    dot(d,x-7,y+2,'bone_hi',2)
    dot(d,x+5,y+2,'bone_low',2)
    poly(d,[(x-5,y+4),(x+2,y+5),(x+3,y+7),(x-3,y+8),(x-6,y+6)],'bone',None)
    line(d,[(x-5,y+5),(x+2,y+6)],'ink',1)
    for q in (-3,-1,1):dot(d,x+q,y+6,'bone_light',1)

def torn_cloak(d,shoulder,hip,fall=False):
    # Layered torn mantle: oxblood cloth core, dark wet hem, damaged copper hems,
    # and a free trailing strip so silhouette reads as cloth (not solid square).
    sx,sy=shoulder;hx,hy=hip
    end_y=min(90,hy+(13 if fall else 25))
    poly(d,[(sx-15,sy-4),(sx+8,sy-5),(hx+11,hy+3),(hx+20,end_y-4),
            (hx+10,end_y-9),(hx+7,end_y),(hx-2,end_y-10),
            (hx-10,end_y-2),(hx-18,end_y-14),(sx-17,sy+5)],'cloth_dark')
    poly(d,[(sx-11,sy-5),(sx+3,sy-4),(hx-5,hy+4),(hx+5,end_y-5),
            (hx-3,end_y-12),(hx-9,end_y-6),(hx-14,hy+7)],'cloth')
    line(d,[(sx-11,sy-2),(hx-12,hy+6),(hx-9,end_y-8)],'cloth2',2)
    line(d,[(sx+4,sy-2),(hx+7,hy+9),(hx+9,end_y-13)],'cloth_light',1)
    poly(d,[(hx+3,hy+2),(hx+12,hy+5),(hx+17,end_y-10),(hx+10,end_y-16)],'cloth2',None)
    line(d,[(sx-13,sy-3),(hx-13,hy+5)],'rust',1)
    for dx,dy in ((-3,5),(4,10),(-9,10)):
        dot(d,hx+dx,min(91,hy+dy),'cloth_hi')

def armor(d,shoulder,hip,tilt=0,texture_seed=0):
    # Non-symmetrical thick plate armor, rib-inlaid breastpiece and scalloped
    # overlapping pauldron, following body joint coordinates in every pose.
    sx,sy=shoulder;hx,hy=hip
    poly(d,[(sx-14,sy-4),(sx+10,sy-6),(sx+12,sy+11),(hx+6,hy+2),(hx-8,hy+4)],'cloth_dark')
    # Dark segmented brigandine chest behind iron scales.
    poly(d,[(sx-10,sy-3),(sx+8,sy-4),(sx+9,sy+10),(sx+3,sy+16),(sx-8,sy+12)],'iron_dark')
    for idx in range(3):
        yy=sy+2+idx*4
        line(d,[(sx-7,yy),(sx+6,yy-1)],'iron_mid',3)
        line(d,[(sx-5,yy-1),(sx+3,yy-2)],'iron_light',1)
        dot(d,sx+5,yy,'rust')
    # Unequal *bulky* right shoulder armor 3 connected plates and iron collar.
    poly(d,[(sx,sy-10),(sx+8,sy-14),(sx+16,sy-10),(sx+20,sy-4),
            (sx+18,sy+2),(sx+8,sy+3)],'iron_dark')
    poly(d,[(sx+3,sy-9),(sx+8,sy-12),(sx+15,sy-8),(sx+18,sy-3),
            (sx+13,sy-1),(sx+4,sy-2)],'iron_mid',None)
    line(d,[(sx+5,sy-10),(sx+9,sy-12),(sx+15,sy-8)],'iron_light',2)
    line(d,[(sx+5,sy-4),(sx+16,sy-2)],'rust',2)
    line(d,[(sx+6,sy),(sx+16,sy+2)],'iron_mid',2)
    for ox,oy in ((8,-9),(15,-5),(12,0)):
        dot(d,sx+ox,sy+oy,'copper_light',1)
    # Low left pauldron, a distinctive hooked steel silhouette.
    poly(d,[(sx-16,sy-8),(sx-8,sy-10),(sx-1,sy-4),(sx-2,sy+4),
            (sx-12,sy+9),(sx-17,sy+4)],'iron_dark')
    poly(d,[(sx-14,sy-7),(sx-8,sy-8),(sx-3,sy-3),(sx-5,sy+2),
            (sx-13,sy+5)],'iron_mid',None)
    line(d,[(sx-14,sy-5),(sx-8,sy-7),(sx-4,sy-2)],'iron_light',1)
    dot(d,sx-11,sy,'rust')
    dot(d,sx-7,sy+3,'copper_light')
    # A wide strapped belly guard and asymmetrical buckle/loose leather waist.
    poly(d,[(hx-8,hy-7),(hx+8,hy-7),(hx+9,hy+1),(hx-7,hy+3)],'leather')
    line(d,[(hx-7,hy-5),(hx+6,hy-5)],'iron_mid',2)
    d.rectangle((round(hx-1),round(hy-6),round(hx+3),round(hy-1)),outline=COL['bronze'],width=1)
    dot(d,hx+1,hy-4,'iron_light')
    line(d,[(hx-7,hy+3),(hx-9,hy+12)],'cloth_light',2)
    line(d,[(hx+8,hy+3),(hx+6,hy+11)],'rust',1)

def spear(d,tip,heel,hang=0,lantern_enabled=True):
    # Blade stays a long pointed SPEAR in every pose. One angular forged blade,
    # reinforced socket, wrapped leather shaft, tattered ferrule ribbon.
    tx,ty=tip;hx,hy=heel
    line(d,[tip,heel],'ink',5)
    line(d,[tip,heel],'leather',3)
    line(d,[(tx*.32+hx*.68,ty*.32+hy*.68),heel],'rust',1)
    vx=hx-tx;vy=hy-ty
    length=max(1,math.hypot(vx,vy));ux=vx/length;uy=vy/length
    px=-uy;py=ux
    head=[(tx,ty),(tx+ux*12+px*3,ty+uy*12+py*3),(tx+ux*17,ty+uy*17),
          (tx+ux*12-px*3,ty+uy*12-py*3)]
    poly(d,head,'steel')
    line(d,[(tx+ux*1,ty+uy*1),(tx+ux*13,ty+uy*13)],'bone_light',1)
    poly(d,[(tx+ux*10+px*2,ty+uy*10+py*2),
            (tx+ux*17,ty+uy*17),(tx+ux*11,ty+uy*11)],'iron_mid',None)
    rx=tx+ux*18;ry=ty+uy*18
    line(d,[(rx+px*3,ry+py*3),(rx-px*3,ry-py*3)],'iron_light',2)
    dot(d,rx,ry,'copper_light')
    # Shaft wrapped in short diagonal braided grips (NOT random speckles).
    for dist in (24,27,30,44):
        if dist>length-5:continue
        xx=tx+ux*dist;yy=ty+uy*dist
        line(d,[(xx+px*1.5,yy+py*1.5),(xx-px*1.5,yy-py*1.5)],'bronze',1)
    if lantern_enabled:
        fx=tx+ux*(length*.63)-8;fy=ty+uy*(length*.63)
        fx=max(12,min(78,fx));fy=max(26,min(63,fy))
        lantern(d,fx,fy+6,hang)

def add_texture(img,index):
    # deterministic sparse brushwork, NO noise in alpha or edge cutouts
    random.seed(1401+index)
    pix=img.load()
    for _ in range(10):
        x=random.randint(17,77);y=random.randint(21,87)
        if pix[x,y][3]<255:continue
        src=pix[x,y]
        if src in (COL['cloth'],COL['cloth2'],COL['metal']):
            ink=COL['cloth_hi'] if src!=COL['metal'] else COL['metal_hi']
            pix[x,y]=ink

def paint_frame(state,i):
    p=Image.new('RGBA',(96,96),(0,0,0,0));d=ImageDraw.Draw(p)
    phase=i
    # Default body structure; all changes are *pose-authored*, not sprite shifting.
    head=(44,25);sh=(49,38);hip=(48,57);lf=(36,90);rf=(60,90)
    lk=(39,75);rk=(56,76);tip=(25,7);tail=(55,77);hang=0
    left_hand=(38,49);right_hand=(56,47);armelbow=(58,43);fwd_elbow=(42,43)
    if state=='idle':
        idle=[(0,0,0,0),(0,1,0,1),(-1,0,1,0),(0,-1,1,-1)][i]
        hx,by,handshift,sw=idle
        head=(44+hx,25+by);sh=(49+hx,38+by);hip=(48+hx,57+by)
        left_hand=(38+handshift,49+by);right_hand=(56,47+by)
        tip=(25+sw,7);tail=(55+sw,77);hang=[-1,0,1,0][i]
        if i==2:lf=(37,90);lk=(40,74)
        if i==3:rf=(59,90);rk=(55,75)
    elif state=='walk':
        walks=[
            {'L':(32,88),'R':(60,90),'LK':(34,73),'RK':(56,76),'by':-1,'s':0},
            {'L':(29,91),'R':(61,89),'LK':(37,73),'RK':(54,76),'by':0,'s':1},
            {'L':(38,91),'R':(62,91),'LK':(40,73),'RK':(55,75),'by':2,'s':2},
            {'L':(38,90),'R':(65,88),'LK':(40,74),'RK':(64,72),'by':-1,'s':1},
            {'L':(37,90),'R':(68,91),'LK':(39,74),'RK':(61,77),'by':0,'s':-1},
            {'L':(36,91),'R':(59,91),'LK':(40,75),'RK':(55,76),'by':1,'s':-2},
        ][i]
        lf=walks['L'];rf=walks['R'];lk=walks['LK'];rk=walks['RK']
        bx=([-1,-2,0,1,2,1][i]);by=walks['by'];head=(44+bx,25+by);sh=(49+bx,38+by);hip=(48+bx,57+by)
        left_hand=(38+bx,49+by);right_hand=(56+bx,47+by)
        tip=(25+walks['s'],8+max(0,by));tail=(55+walks['s'],76+by);hang=[0,1,2,0,-2,-1][i]
    elif state=='attack':
        configs=[
            ((44,25),(49,38),(48,57),(24,8),(58,73),(40,48),(57,44)),
            ((45,25),(50,40),(49,59),(41,11),(58,81),(40,46),(57,45)),
            ((42,24),(46,39),(48,56),(9,33),(79,58),(34,46),(53,44)),
            ((40,23),(45,39),(49,55),(5,42),(81,49),(32,46),(51,43)),
            ((42,24),(47,39),(49,58),(10,42),(75,55),(35,47),(55,44)),
            ((44,25),(49,38),(48,57),(24,9),(57,75),(39,49),(56,47))
        ]
        head,sh,hip,tip,tail,left_hand,right_hand=configs[i]
        if i==1:lf=(38,90);rf=(63,90)
        if i in (2,3,4):
            lf=[(31,90),(27,91),(33,90)][i-2]
            rf=(64,90);lk=(39,73);rk=(58,75)
            fwd_elbow=(37,40);armelbow=(53,38)
        hang=[0,-1,-2,0,2,1][i]
    elif state=='hit':
        vals=[(46,27,50,41,47,59,27,9,59,81),(50,30,53,44,49,61,34,10,60,82),(45,26,50,39,48,58,25,8,56,78)][i]
        head=(vals[0],vals[1]);sh=(vals[2],vals[3]);hip=(vals[4],vals[5]);tip=(vals[6],vals[7]);tail=(vals[8],vals[9]);hang=[-2,2,0][i]
        lf=(34,90);rf=(66,90);lk=(39,75);rk=(59,77)
        left_hand=(39+i,49+i);right_hand=(57,48+i);fwd_elbow=(42,42+i)
    elif state=='death':
        # The body descends in authored poses; no static tween/scale clone.
        death=[
            {'h':(46,29),'s':(49,44),'hip':(51,63),'k1':(42,76),'k2':(58,77),'f1':(35,90),'f2':(60,91),'t':(28,13),'e':(60,80)},
            {'h':(51,35),'s':(52,49),'hip':(52,68),'k1':(42,82),'k2':(63,81),'f1':(40,90),'f2':(66,91),'t':(17,28),'e':(69,83)},
            {'h':(54,46),'s':(53,56),'hip':(50,73),'k1':(36,86),'k2':(61,85),'f1':(29,91),'f2':(66,91),'t':(8,63),'e':(82,87)},
            {'h':(49,61),'s':(50,66),'hip':(53,77),'k1':(44,86),'k2':(70,88),'f1':(32,91),'f2':(79,91),'t':(7,82),'e':(86,90)},
            {'h':(38,79),'s':(50,79),'hip':(60,81),'k1':(62,88),'k2':(75,89),'f1':(40,91),'f2':(82,91),'t':(9,85),'e':(82,90)},
            {'h':(34,80),'s':(51,80),'hip':(63,82),'k1':(67,89),'k2':(76,88),'f1':(45,91),'f2':(83,91),'t':(10,84),'e':(83,89)}
        ][i]
        head=death['h'];sh=death['s'];hip=death['hip'];lk=death['k1'];rk=death['k2'];lf=death['f1'];rf=death['f2'];tip=death['t'];tail=death['e']
        left_hand=(sh[0]-9,sh[1]+12);right_hand=(sh[0]+10,sh[1]+6)
        fwd_elbow=(sh[0]-11,sh[1]+5);armelbow=(sh[0]+12,sh[1]+2)
        hang=2 if i>2 else 0
    # Draw the new layered mantle behind limbs and breastplate.
    hX,hY=hip;sX,sY=sh
    torn_cloak(d,sh,hip,fall=(state=='death' and i>=3))
    # rear leg painted behind chest
    bone(d,hip,rk,5);joint(d,rk,3);bone(d,rk,rf,5)
    # wrapped boot
    poly(d,[(rf[0]-4,rf[1]-6),(rf[0]+3,rf[1]-7),(rf[0]+4,rf[1]-1),(rf[0]-7,rf[1])],'metal')
    line(d,[(rf[0]-6,rf[1]-1),(rf[0]+5,rf[1]-1)],'metal_hi',1)
    # nearer leg
    bone(d,hip,lk,5);joint(d,lk,3);bone(d,lk,lf,5)
    poly(d,[(lf[0]-4,lf[1]-6),(lf[0]+2,lf[1]-6),(lf[0]+3,lf[1]-1),(lf[0]-7,lf[1])],'metal')
    line(d,[(lf[0]-7,lf[1]-1),(lf[0]+4,lf[1]-1)],'metal_hi',1)
    # Layered battered greaves follow their real joint lines through walk and fall.
    for knee,foot,side in ((rk,rf,1),(lk,lf,-1)):
        if state=='death' and i>=3:
            continue  # prone limbs should not sprout vertical leg plates
        kx,ky=knee;fx,fy=foot
        line(d,[(kx+side*1,ky+4),(fx+side*1,fy-7)],'iron_dark',4)
        line(d,[(kx+side*2,ky+5),(fx+side*1,fy-7)],'iron_mid',2)
        line(d,[(kx+side*2,ky+6),(fx+side*2,fy-9)],'iron_light',1)
        dot(d,kx+side*2,ky+1,'bronze',2)
        line(d,[(fx-5,fy-2),(fx+3,fy-2)],'iron_light',1)
    # chest armature + armor
    armor(d,sh,hip)
    # far right arm, joint at shoulder plate
    r_should=(sh[0]+10,sh[1]-4)
    bone(d,r_should,armelbow,4);joint(d,armelbow,2);bone(d,armelbow,right_hand,3)
    joint(d,right_hand,2)
    # neck visible, eye-line head
    bone(d,(sh[0]-3,sh[1]-6),(head[0]+1,head[1]+7),5)
    # hood rim rather than full hood, keep skull silhouette readable
    if state!='death' or i<5:
        poly(d,[(head[0]-11,head[1]-5),(head[0]-10,head[1]-12),(head[0]-4,head[1]-14),
                (head[0]+6,head[1]-14),(head[0]+12,head[1]-7),(head[0]+13,head[1]+3),
                (head[0]+9,head[1]+9),(head[0]+8,head[1]-6),(head[0]-7,head[1]-6),
                (head[0]-10,head[1]+8)],'cloth')
        line(d,[(head[0]-8,head[1]-10),(head[0]-3,head[1]-13),(head[0]+7,head[1]-11)],'cloth_hi',1)
        line(d,[(head[0]+9,head[1]-7),(head[0]+10,head[1]+3)],'deep',2)
    skull(d,*head)
    # near left arm in front of chest, visible hand grips shaft
    l_shoulder=(sh[0]-8,sh[1]-3)
    if state in ('attack', 'hit') and (state!='attack' or i>1):
        fwd_elbow=(round((l_shoulder[0]+left_hand[0])/2),round((l_shoulder[1]+left_hand[1])/2)-5)
    bone(d,l_shoulder,fwd_elbow,4);joint(d,fwd_elbow,2);bone(d,fwd_elbow,left_hand,3)
    joint(d,left_hand,3)
    if state!='death' or i<4:
        line(d,[(left_hand[0]-2,left_hand[1]-3),(left_hand[0]+3,left_hand[1]-3)],'iron_mid',2)
        dot(d,left_hand[0]-2,left_hand[1]-2,'copper_light')
        line(d,[(right_hand[0]-2,right_hand[1]-3),(right_hand[0]+2,right_hand[1]-2)],'iron_light',2)
    # Original spear drawn in front except death final - spear always readable and intact.
    spear(d,tip,tail,hang=hang,lantern_enabled=(state!='death' or i<3))
    # faint armor highlights/scratches; small robust pixels
    dot(d,sh[0]+12,sh[1]-8,'steel')
    # The individual joints stay pose-authored; these embellishments follow
    # shoulder and hip motion instead of floating independently.
    line(d,[(sh[0]-3,sh[1]+2),(sh[0]+4,sh[1]+2)],'bronze',1)
    dot(d,sh[0],sh[1]+5,'steel')
    dot(d,hip[0]+4,hip[1]-5,'bronze')
    if state=='attack':dot(d,head[0]-4,head[1]-1,'flame',1)
    if state=='death' and i>=3:
        # Prone bones must stay 2px away from the 96px cell edge.
        p2=Image.new('RGBA',(96,96),(0,0,0,0));p2.alpha_composite(p,(0,-3));p=p2
    add_texture(p,{'idle':0,'walk':4,'attack':10,'hit':16,'death':19}[state]+i)
    return p

STATES=[('idle',4),('walk',6),('attack',6),('hit',3),('death',6)]

def main():
    atlas=Image.new('RGBA',(576,480),(0,0,0,0));cells=[]
    for row,(state,count) in enumerate(STATES):
        for i in range(count):
            art=paint_frame(state,i)
            atlas.alpha_composite(art,(i*96,row*96))
            cells.append((state,i,art))
    # enforce technically checkable engineering criteria
    unique={hashlib.sha256(img.tobytes()).hexdigest() for _,_,img in cells}
    if len(unique)!=25:raise Exception(f'Frames not unique: {len(unique)}')
    report={'width':576,'height':480,'alpha':'RGBA','state_counts':dict(STATES),'poses':25,'unique_frames':len(unique),'unused_cells':5,'frame_warnings':[],'frames':[]}
    for state,i,im in cells:
        alpha=im.getchannel('A');bbox=alpha.getbbox()
        borders=[]
        for key,rect in [('left',(0,0,2,96)),('right',(94,0,96,96)),('top',(0,0,96,2)),('bottom',(0,94,96,96))]:
            if alpha.crop(rect).getbbox():borders.append(key)
        if borders:report['frame_warnings'].append(f'{state}{i+1}: near {borders}')
        report['frames'].append({'state':state,'index':i+1,'alpha_bbox':bbox,'edge_warning':borders})
    for r,(_,count) in enumerate(STATES):
        for c in range(count,6):
            assert atlas.crop((c*96,r*96,(c+1)*96,(r+1)*96)).getbbox() is None
    atlas.save(OUT/'road_sentinel_d227_art_candidate.png',optimize=True)
    atlas.save(OUT/'road_sentinel_d227_art_candidate.webp',format='WEBP',lossless=True,method=6)
    (OUT/'road_sentinel_d227_art_candidate.webp.b64').write_text(base64.b64encode((OUT/'road_sentinel_d227_art_candidate.webp').read_bytes()).decode('ascii')+'\n')
    (OUT/'d227_art_qc.json').write_text(json.dumps(report,ensure_ascii=False,indent=2))
    # preview board w/ authentic 25 art poses arranged in correct grid and readable enlarged details
    bg=Image.new('RGBA',(1440,1090),(18,20,24,255));g=ImageDraw.Draw(bg)
    # header
    g.text((45,22),'D227 / ROAD SENTINEL — B-STYLE ORIGINAL 25-CEL ART QA',fill=(222,210,180,255),stroke_width=0)
    g.text((45,48),'576x480 / 6x5 / 96PX / SPEAR+LANTERN / ART REVIEW CANDIDATE',fill=(147,162,160,255))
    # display on checkboard so transparency obvious
    display=Image.new('RGBA',(1152,960),(0,0,0,0))
    check=Image.new('RGBA',(576,480),(40,43,48,255));cd=ImageDraw.Draw(check)
    for yy in range(0,480,12):
        for xx in range(0,576,12):
            if (xx//12+yy//12)%2==0:cd.rectangle((xx,yy,xx+11,yy+11),fill=(47,51,56,255))
    check.alpha_composite(atlas)
    display=check.resize((1152,960),Image.Resampling.NEAREST)
    bg.alpha_composite(display,(205,92))
    for n,(label,count) in enumerate(STATES):
        y=92+n*192
        g.text((32,y+74),f'{label.upper()}  {count}',fill=(199,188,166,255))
        g.line([(205,y),(1357,y)],fill=(115,89,60,255),width=2)
    for col in range(7):g.line([(205+col*192,92),(205+col*192,1052)],fill=(76,77,73,255),width=1)
    g.line([(205,1052),(1357,1052)],fill=(76,77,73,255),width=1)
    bg.convert('RGB').save(OUT/'D227_sentinel_animation_contact_sheet.png')
    print(json.dumps({k:v for k,v in report.items() if k!='frames'},ensure_ascii=False,indent=2))
    print('atlas PNG', (OUT/'road_sentinel_d227_art_candidate.png').stat().st_size,'webp', (OUT/'road_sentinel_d227_art_candidate.webp').stat().st_size)
if __name__=='__main__':main()