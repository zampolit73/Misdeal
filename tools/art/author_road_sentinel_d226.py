#!/usr/bin/env python3
"""D226: richer B-style hand-authored 25-cel Road Sentinel, retaining D215 original pose contract.

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
'ink':(15,15,20,255),'deep':(21,22,31,255),'cloth':(54,26,29,255),'cloth2':(93,38,37,255),
'cloth_hi':(136,66,48,255),'bone_shadow':(84,70,62,255),'bone':(172,150,117,255),
'bone_hi':(216,186,136,255),'bone_light':(239,214,157,255),'metal':(43,44,49,255),
'metal_hi':(116,109,101,255),'steel':(173,165,150,255),'rust':(128,77,44,255),
'bronze':(193,129,72,255),'flame':(246,163,48,255),'fire_hi':(255,215,105,255),
'eye':(247,152,60,255), 'leather':(86,54,38,255)
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
    # Short lantern hung from iron hoop. Warm effect contained in 12px glass cage.
    x=int(round(x));y=int(round(y));s=int(round(swing))
    line(d,[(x,y-5),(x+s,y+1)],'metal_hi',1)
    d.rectangle((x+s-6,y+1,x+s+6,y+15),fill=COL['ink'])
    d.rectangle((x+s-4,y+3,x+s+4,y+12),fill=COL['bronze'])
    d.rectangle((x+s-3,y+3,x+s+2,y+11),fill=COL['flame'])
    d.rectangle((x+s-1,y+4,x+s+1,y+9),fill=COL['fire_hi'])
    for k in (-5,5):
        line(d,[(x+s+k,y+1),(x+s+k,y+14)],'steel',1)
    line(d,[(x+s-6,y+12),(x+s+6,y+12)],'metal',2)
    line(d,[(x+s-4,y),(x+s+4,y)],'metal_hi',2)
    dot(d,x+s-2,y+15,'rust')

def skull(d,x,y,tilt=0,dim=0):
    # skull is frontal-left 3/4; x/y refer face center
    x=int(round(x));y=int(round(y))
    poly(d,[(x-7,y-6),(x-4,y-9),(x+3,y-10),(x+8,y-6),(x+8,y+2),(x+5,y+6),(x-4,y+5),(x-7,y+1)],'bone_shadow')
    poly(d,[(x-6,y-6),(x-3,y-9),(x+1,y-9),(x+6,y-6),(x+6,y+2),(x+3,y+5),(x-5,y+3)],'bone')
    # brow cap, 3/4 facing toward left
    line(d,[(x-5,y-3),(x+4,y-3)],'bone_hi',2)
    poly(d,[(x-6,y-2),(x-1,y-3),(x-1,y+1),(x-6,y+1)],'ink',None)
    poly(d,[(x+2,y-2),(x+5,y-2),(x+5,y+1),(x+2,y+1)],'ink',None)
    dot(d,x-4,y-1,'eye');dot(d,x+3,y-1,'eye')
    poly(d,[(x-2,y+2),(x+1,y+2),(x+3,y+5),(x-4,y+5)],'bone_shadow')
    line(d,[(x-4,y+6),(x+5,y+6)],'bone_hi',2)
    for q in (-2,1,4): dot(d,x+q,y+6,'ink')
    dot(d,x-4,y-7,'bone_light');dot(d,x+2,y-8,'bone_hi')

def torn_cloak(d,shoulder,hip,fall=False):
    # Individually tapered ochre/russet funeral cloth. Geometry follows the pose,
    # NOT a frozen texture stamped in different cells.
    sx,sy=shoulder;hx,hy=hip
    end_y=min(90,hy+(13 if fall else 25))
    poly(d,[(sx-12,sy-5),(sx+9,sy-4),(hx+10,hy+4),(hx+19,end_y-3),
            (hx+10,end_y-8),(hx+5,end_y),(hx-2,end_y-10),
            (hx-9,end_y-2),(hx-17,end_y-13),(sx-16,sy+6)],'cloth')
    line(d,[(sx-10,sy-2),(hx-12,hy+7),(hx-8,end_y-8)],'cloth_hi',2)
    line(d,[(sx+9,sy-1),(hx+12,hy+7),(hx+13,end_y-10)],'cloth2',2)
    for dx,dy in ((-3,5),(4,10),(-9,10)):
        dot(d,hx+dx,min(91,hy+dy),'cloth_hi')

def armor(d,shoulder,hip,tilt=0,texture_seed=0):
    sx,sy=shoulder;hx,hy=hip
    poly(d,[(sx-12,sy-4),(sx+7,sy-7),(sx+12,sy+5),(hx+7,hy-9),(hx-5,hy-8),(sx-11,sy+8)],'cloth')
    # canvas strips hanging beneath breastplate
    poly(d,[(sx-5,sy+12),(hx+5,hy+1),(hx+10,hy+16),(hx+2,hy+10),(hx-4,hy+18),(hx-9,hy+3)],'cloth2')
    poly(d,[(sx+6,sy+9),(hx+9,hy+1),(hx+15,hy+13),(hx+4,hy+8)],'deep')
    line(d,[(hx-4,hy+6),(hx+2,hy+10)],'cloth_hi',1)
    # broad unequal metal shoulder and rivets (design A silhouette)
    poly(d,[(sx+1,sy-10),(sx+9,sy-12),(sx+16,sy-6),(sx+18,sy+2),(sx+11,sy+6),(sx+4,sy+2)],'metal')
    line(d,[(sx+3,sy-8),(sx+10,sy-10),(sx+15,sy-5)],'metal_hi',2)
    for dx,dy in ((7,-8),(14,-3),(9,2)) :dot(d,sx+dx,sy+dy,'bronze',2)
    poly(d,[(sx-11,sy-3),(sx-2,sy-6),(sx+6,sy-1),(sx+5,sy+11),(sx-7,sy+11),(sx-12,sy+3)],'metal')
    line(d,[(sx-8,sy),(sx+1,sy-2),(sx+2,sy+7)],'metal_hi',2)
    for dx,dy in ((-6,3),(-1,7),(2,2)) :dot(d,sx+dx,sy+dy,'rust')
    # Bent plates: selective copper edges, scratches and irregular rivets.
    line(d,[(sx+6,sy-6),(sx+13,sy-3),(sx+15,sy+2)],'rust',1)
    line(d,[(sx-10,sy+5),(sx-6,sy+10),(sx+1,sy+9)],'bronze',1)
    dot(d,sx+10,sy-6,'metal_hi')
    dot(d,sx+13,sy,'rust')
    # central rib vents + decorated buckle
    for t in range(3):
        line(d,[(sx-4,sy+4+t*3),(sx+4,sy+4+t*3)],'deep',1)
    poly(d,[(hx-6,hy-7),(hx+7,hy-7),(hx+6,hy+2),(hx-4,hy+2)],'leather')
    dot(d,hx+2,hy-5,'bronze',2)

def spear(d,tip,heel,hang=0,lantern_enabled=True):
    # entire shaft is genuine pointed spear, not axe or halberd
    tx,ty=tip;hx,hy=heel
    line(d,[tip,heel],'ink',5)
    line(d,[tip,heel],'leather',3)
    line(d,[(tx*0.35+hx*0.65,ty*0.35+hy*0.65),heel],'bronze',1)
    vx=hx-tx;vy=hy-ty
    length=max(1,math.hypot(vx,vy));ux=vx/length;uy=vy/length
    px=-uy;py=ux
    # head of spear extends from pointed tip, wide shoulders 9px along shaft
    head=[(tx,ty),(tx+ux*11+px*4,ty+uy*11+py*4),(tx+ux*15,ty+uy*15),(tx+ux*11-px*4,ty+uy*11-py*4)]
    poly(d,head,'steel')
    line(d,[(tx+ux*1,ty+uy*1),(tx+ux*11,ty+uy*11)],'bone_light',1)
    # short hook, not axe blade
    rx=tx+ux*16;ry=ty+uy*16
    line(d,[(rx+px*3,ry+py*3),(rx-px*3,ry-py*3)],'bronze',2)
    if lantern_enabled:
        # keep lamp low at handle end; clamp to field
        fx=tx+ux*(length*0.64);fy=ty+uy*(length*0.64)
        if fx<9:fx=9
        if fx>85:fx=85
        if fy>67:fy=67
        if fy<24:fy=24
        lantern(d,fx,fy+4,hang)

def add_texture(img,index):
    # deterministic sparse brushwork, NO noise in alpha or edge cutouts
    random.seed(1401+index)
    pix=img.load()
    for _ in range(18):
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
    atlas.save(OUT/'road_sentinel_d226_art_candidate.png',optimize=True)
    atlas.save(OUT/'road_sentinel_d226_art_candidate.webp',format='WEBP',lossless=True,method=6)
    (OUT/'road_sentinel_d226_art_candidate.webp.b64').write_text(base64.b64encode((OUT/'road_sentinel_d226_art_candidate.webp').read_bytes()).decode('ascii')+'\n')
    (OUT/'d226_art_qc.json').write_text(json.dumps(report,ensure_ascii=False,indent=2))
    # preview board w/ authentic 25 art poses arranged in correct grid and readable enlarged details
    bg=Image.new('RGBA',(1440,1090),(18,20,24,255));g=ImageDraw.Draw(bg)
    # header
    g.text((45,22),'D226 / ROAD SENTINEL — B-STYLE ORIGINAL 25-CEL ART QA',fill=(222,210,180,255),stroke_width=0)
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
    bg.convert('RGB').save(OUT/'D226_sentinel_animation_contact_sheet.png')
    print(json.dumps({k:v for k,v in report.items() if k!='frames'},ensure_ascii=False,indent=2))
    print('atlas PNG', (OUT/'road_sentinel_d226_art_candidate.png').stat().st_size,'webp', (OUT/'road_sentinel_d226_art_candidate.webp').stat().st_size)
if __name__=='__main__':main()