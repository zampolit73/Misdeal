#!/usr/bin/env python3
"""D219 Misdeal Lantern Archer QA: independently authored full-body 25-pose pixel atlas.
Native 96px cels; five state rows (idle4/walk6/attack6/hit3/death6).
Standalone offline Python + Pillow art source, not required at Godot runtime.
The drawn bow/tether/arrow are visual only; projectile gameplay is unchanged.
"""
from pathlib import Path
from PIL import Image, ImageDraw
import math, base64, hashlib, json

ROOT=Path(__file__).resolve().parent
S=96
STATES=[('idle',4),('walk',6),('attack',6),('hit',3),('death',6)]
C={'ink':'#111820','bone':'#ada58a','bone_hi':'#dbceae','bone_dark':'#6d6c5c',
   'cloth':'#263038','cloth_hi':'#424c54','leather':'#684630','leather_hi':'#916b45',
   'metal':'#454b4d','steel':'#a09c85','amber':'#c0833b','flame':'#ffd376',
   'arrow':'#b6a78a','fletch':'#9d6347','bow':'#8b6040','bow_hi':'#c1915b',
   'ghost':'#d9b56c'}

def line(d, ps, col, w=1):d.line([(round(x),round(y)) for x,y in ps],fill=C.get(col,col),width=w,joint='curve')
def poly(d,ps,col,stroke='ink'):
    ps=[(round(x),round(y)) for x,y in ps]
    d.polygon(ps,fill=C.get(col,col))
    if stroke:d.line(ps+[ps[0]],fill=C.get(stroke,stroke),width=1,joint='curve')
def dot(d,x,y,col,sz=1):d.rectangle((round(x),round(y),round(x)+sz-1,round(y)+sz-1),fill=C.get(col,col))
def bone(d,a,b,w=4):
    line(d,[a,b],'ink',w+2);line(d,[a,b],'bone_dark',w);line(d,[a,b],'bone',max(1,w-2))
    line(d,[(a[0],a[1]-1),(b[0],b[1]-1)],'bone_hi',1)
def skull(d,at,lowered=False):
    x,y=at
    poly(d,[(x-7,y-6),(x-4,y-9),(x+4,y-8),(x+7,y-3),(x+6,y+4),(x-5,y+5),(x-7,y)],'bone_dark')
    poly(d,[(x-6,y-6),(x-3,y-8),(x+3,y-7),(x+5,y-3),(x+5,y+3),(x-5,y+3)],'bone')
    poly(d,[(x-6,y-2),(x-2,y-2),(x-2,y+1),(x-6,y+1)],'ink',None)
    poly(d,[(x+1,y-2),(x+4,y-2),(x+4,y+1),(x+1,y+1)],'ink',None)
    dot(d,x-5,y-1,'ghost');dot(d,x+2,y-1,'ghost')
    line(d,[(x-4,y+5),(x+4,y+5)],'bone_hi',1)
    for dx in [-3,-1,2]:dot(d,x+dx,y+5,'ink')

def cape(d,shoulder,hip,ground=False):
    sx,sy=shoulder;px,py=hip
    if ground:
        poly(d,[(px-24,py-10),(px+10,py-10),(px+21,py+4),(px-22,py+5)],'cloth')
        line(d,[(px-18,py),(px+16,py)],'cloth_hi',2)
    else:
        poly(d,[(sx-9,sy-9),(sx+10,sy-8),(px+13,py+1),(px+22,py+21),(px+6,py+15),(px-8,py+19),(px-11,py+2)],'cloth')
        poly(d,[(sx+4,sy),(sx+11,sy+1),(px+16,py+17),(px+6,py+15)],'cloth_hi')
        line(d,[(px-7,py+16),(px-5,py+22)],'leather',1)

def quiver(d,at,angle=0,arrows=3):
    x,y=at
    poly(d,[(x-4,y-6),(x+3,y-7),(x+5,y+18),(x-3,y+17)],'leather')
    line(d,[(x-3,y+1),(x+4,y)],'leather_hi',2)
    line(d,[(x-3,y+14),(x+5,y+12)],'steel',1)
    for k in range(arrows):
        u=x-3+k*3
        line(d,[(u,y-4),(u+angle,y-16-k%2*2)],'arrow',1)
        poly(d,[(u+angle-2,y-17-k%2*2),(u+angle+1,y-16-k%2*2),(u+angle+2,y-20-k%2*2)],'fletch',None)

def fallen_quiver(d):
    # Grounded quiver: horizontal tube and knocked loose arrows, never levitating upright.
    poly(d,[(65,82),(83,84),(86,89),(63,88)],'leather')
    line(d,[(66,82),(84,85)],'leather_hi',2)
    line(d,[(65,87),(84,90)],'metal',1)
    for n in range(3):
        line(d,[(67+n*2,80-n),(82+n,87-n)],'arrow',1)
        poly(d,[(64+n*2,78-n),(66+n*2,80-n),(63+n*2,81-n)],'fletch',None)


def lantern(d,at,glow=True):
    x,y=at
    line(d,[(x,y-5),(x,y-2)],'steel',1)
    poly(d,[(x-5,y-2),(x+4,y-2),(x+5,y+10),(x-4,y+10)],'metal')
    poly(d,[(x-3,y+1),(x+3,y+1),(x+3,y+8),(x-3,y+8)],'amber' if glow else 'leather')
    if glow:dot(d,x-1,y+2,'flame',3)
    line(d,[(x-5,y+8),(x+5,y+8)],'steel',1)
    line(d,[(x-5,y-2),(x+4,y-2)],'steel',1)

def bow(d,upper,lower,handle,draw=0):
    # Classic two curved wooden limbs (not a straight pole), both left of skull.
    hx,hy=handle;ux,uy=upper;lx,ly=lower
    ctrl_u=(min(ux,hx)-5,hy-12)
    ctrl_l=(min(lx,hx)-6,hy+13)
    # curves are polygonal deliberate pixel lines, not antialiased splines
    limb_top=[upper,(ux+1,uy+6),ctrl_u,(hx,hy)]
    limb_bottom=[(hx,hy),ctrl_l,(lx+1,ly-6),lower]
    line(d,limb_top,'ink',5);line(d,limb_top,'bow',3)
    line(d,limb_bottom,'ink',5);line(d,limb_bottom,'bow',3)
    for tip in [upper,lower]:dot(d,tip[0],tip[1],'bow_hi',2)
    # String from limb tips to pulled nock point: this is what visually differentiates draw phase.
    nock=(hx+draw,hy)
    line(d,[upper,nock,lower],'ink',2)
    line(d,[upper,nock,lower],'bone_hi',1)
    dot(d,hx,hy,'leather_hi',3)
    return nock

def arrow(d,back,front,flight=False):
    # Bow faces left; arrow points toward heroes (x decreases).
    ax,ay=front;bx,by=back
    line(d,[(ax,ay),(bx,by)],'ink',3)
    line(d,[(ax,ay),(bx,by)],'arrow',1)
    poly(d,[(ax-3,ay),(ax+2,ay-2),(ax+2,ay+2)],'steel')
    line(d,[(bx-4,by-2),(bx,by),(bx-4,by+2)],'fletch',2)
    if flight:
        # Tiny, contained release streak; no projectile beyond cell.
        line(d,[(ax+5,ay+4),(ax+12,ay+4)],'ghost',1)

def pose(st,i):
    p=dict(H=(53,24),S=(54,39),HIP=(53,61),LK=(44,76),RK=(63,77),
           LF=(38,90),RF=(69,90),HB=(43,51),EL=(50,47),RE=(66,51),RH=(66,58),
           BOW=(37,48),UP=(31,18),DOWN=(31,79),DRAW=0,ARROW=False,FLIGHT=False,
           QUIVER=(72,39),LAMP=(76,69),GROUND=False,HELD=True)
    if st=='idle':
        changes=[{},dict(H=(53,25),S=(54,40),HIP=(53,62),LAMP=(76,70),BOW=(37,49)),
                 dict(H=(52,23),S=(53,38),HIP=(52,60),QUIVER=(73,38),LF=(37,90)),
                 dict(H=(54,24),S=(55,39),HIP=(53,61),RF=(68,90),BOW=(37,47))]
    elif st=='walk':
        changes=[dict(LF=(32,86),LK=(40,74),H=(52,23),S=(53,38),BOW=(35,46)),
                 dict(LF=(28,90),LK=(39,76),HIP=(51,63),H=(51,26),BOW=(34,49),LAMP=(78,71)),
                 dict(LF=(42,90),LK=(44,77),H=(53,27),S=(53,41),HIP=(53,63),BOW=(36,50)),
                 dict(RF=(73,85),RK=(65,72),H=(54,23),S=(56,38),HIP=(55,60),BOW=(39,46)),
                 dict(RF=(75,90),RK=(67,77),H=(54,25),S=(56,40),HIP=(55,62),BOW=(40,49),LAMP=(75,71)),
                 dict(RF=(69,90),RK=(63,77),H=(53,25),S=(54,40),HIP=(53,61),BOW=(37,49))]
    elif st=='attack':
        changes=[dict(BOW=(35,48),UP=(29,19),DOWN=(29,79),H=(54,23),S=(56,39),ARROW=True,DRAW=1),
                 dict(BOW=(32,45),UP=(26,15),DOWN=(26,75),H=(53,24),S=(55,41),EL=(44,44),ARROW=True,DRAW=5),
                 dict(BOW=(31,45),UP=(24,14),DOWN=(24,75),H=(52,25),S=(54,41),EL=(44,45),RH=(67,48),ARROW=True,DRAW=14),
                 dict(BOW=(30,45),UP=(23,14),DOWN=(23,75),H=(52,24),S=(54,41),EL=(43,44),RH=(70,46),ARROW=True,DRAW=24),
                 dict(BOW=(30,45),UP=(24,15),DOWN=(24,76),H=(50,23),S=(53,40),EL=(43,44),RH=(57,44),ARROW=True,FLIGHT=True,DRAW=0),
                 dict(BOW=(35,48),UP=(29,19),DOWN=(29,79),H=(53,24),S=(54,39),RH=(67,54),ARROW=False,DRAW=0)]
    elif st=='hit':
        changes=[dict(H=(58,27),S=(61,43),HIP=(57,63),BOW=(40,50),RH=(70,59),LF=(40,90)),
                 dict(H=(62,32),S=(65,48),HIP=(60,65),BOW=(45,56),QUIVER=(77,43),LAMP=(78,72),RF=(75,90)),
                 dict(H=(56,25),S=(57,40),HIP=(54,61),BOW=(39,49),QUIVER=(73,40),RH=(67,55))]
    else:
        changes=[dict(H=(54,31),S=(55,46),HIP=(53,67),LK=(45,82),RK=(64,80),LAMP=(77,72),BOW=(38,56),UP=(32,26),DOWN=(32,83)),
                 dict(H=(58,40),S=(60,54),HIP=(57,72),LK=(43,83),RK=(63,84),BOW=(44,63),UP=(35,35),DOWN=(37,83)),
                 dict(H=(55,52),S=(58,65),HIP=(59,78),LK=(43,85),RK=(64,87),BOW=(45,71),UP=(31,48),DOWN=(48,87)),
                 dict(H=(44,69),S=(51,77),HIP=(60,84),LK=(46,87),RK=(67,88),BOW=(45,81),UP=(24,75),DOWN=(55,87),GROUND=True),
                 dict(H=(37,80),S=(49,82),HIP=(63,85),LK=(49,87),RK=(69,88),BOW=(44,82),UP=(21,77),DOWN=(61,88),GROUND=True,LAMP=(74,78)),
                 dict(H=(35,80),S=(48,82),HIP=(64,85),LK=(49,88),RK=(68,88),BOW=(44,83),UP=(20,78),DOWN=(61,89),GROUND=True,LAMP=(74,79))]
    p.update(changes[i])
    return p

def draw_frame(st,i):
    p=pose(st,i)
    img=Image.new('RGBA',(S,S),(0,0,0,0)); d=ImageDraw.Draw(img)
    h=p['H'];s=p['S'];hip=p['HIP'];dead=st=='death';ground=p['GROUND']
    cape(d,s,hip,ground)
    # legs and leather boots
    for k,f in [('RK','RF'),('LK','LF')]:
        bone(d,hip,p[k],5)
        xx,yy=p[k];d.ellipse((xx-3,yy-3,xx+3,yy+3),fill=C['bone'])
        bone(d,p[k],p[f],4)
        xx,yy=p[f];poly(d,[(xx-5,yy-5),(xx+4,yy-6),(xx+6,yy-2),(xx-5,yy-1)],'metal')
        line(d,[(xx-4,yy-4),(xx+4,yy-5)],'steel',1)
    # sternum and chest with visible skeletal ribs, archer is slender not armored
    poly(d,[(s[0]-10,s[1]-6),(s[0]+9,s[1]-7),(hip[0]+8,hip[1]-8),(hip[0]+8,hip[1]+3),
            (hip[0]-9,hip[1]+3)],'cloth')
    for a in range(4):
        dy=s[1]+a*4
        line(d,[(s[0]-6,dy),(s[0]+7,dy+1)],'bone_dark',3)
        line(d,[(s[0]-5,dy),(s[0]+5,dy+1)],'bone',1)
    line(d,[(s[0]-8,s[1]-4),(hip[0]+5,hip[1]+3)],'leather',3)
    dot(d,hip[0]+2,hip[1]-1,'leather_hi',3)
    # skull and neck
    bone(d,(s[0]-2,s[1]-7),(h[0],h[1]+5),3)
    skull(d,h)
    # quiver attached behind opposite shoulder, with 3 proud feathered arrow ends
    if dead and i>=3:fallen_quiver(d)
    else:quiver(d,p['QUIVER'],arrows=3)
    # thin belt lantern, distinct from quiver, hangs at hip and stays legible
    if dead and i>=4:lantern(d,p['LAMP'],False)
    else:lantern(d,p['LAMP'],True)
    # drawing arm bends toward nock during attack
    re=p['RE'];rh=p['RH'];draw=p['DRAW']
    if st=='attack' and i in [1,2,3]:
        re=(s[0]+10,s[1]+2);rh=(p['BOW'][0]+draw,p['BOW'][1])
    if st=='attack' and i==4:rh=(s[0]+3,s[1]+1)
    bone(d,(s[0]+9,s[1]-3),re,4);bone(d,re,rh,3)
    # bow front arm
    bone(d,(s[0]-8,s[1]-3),p['EL'],4);bone(d,p['EL'],p['BOW'],3)
    nock=bow(d,p['UP'],p['DOWN'],p['BOW'],p['DRAW'])
    if p['ARROW']:
        # all projectile graphics stay within cel; full draw has arrow pointing to left at chest line
        if p['FLIGHT']:
            arrow(d,(45,45),(9,45),True)
        else:
            arrow(d,nock,(max(7,p['BOW'][0]-18),p['BOW'][1]))
    # hand grip atop bow to sell physical ownership
    dot(d,p['BOW'][0]-2,p['BOW'][1]-2,'bone_hi',4)
    # deterministic small highlights, no alpha noise
    seed=219000+(['idle','walk','attack','hit','death'].index(st)*10)+i
    for k in range(9):
        x=25+(seed*(k+3)*29)%60;y=28+(seed*(k+11)*17)%59
        if img.getpixel((x,y))==tuple(bytes.fromhex(C['cloth'][1:]))+(255,):
            dot(d,x,y,'cloth_hi')
    if dead and i>=1:
        # Move late grounded corpse art within the two-pixel alpha safety margin.
        # This is author-time placement, not a runtime crop/QA relaxation.
        safe=Image.new('RGBA',(S,S),(0,0,0,0))
        safe.alpha_composite(img,(0,-4))
        img=safe
    return img

def make():
    atlas=Image.new('RGBA',(576,480),(0,0,0,0));individual=[]
    for row,(name,count) in enumerate(STATES):
        for col in range(count):
            cel=draw_frame(name,col)
            atlas.alpha_composite(cel,(96*col,96*row))
            individual.append((name,col,cel))
    alpha=atlas.getchannel('A');all_hashes=set()
    report={'atlas_size':[576,480],'cells':[6,5],'states':dict(STATES),'nonempty':0,'unique':0,'empty':0,'border_warnings':[],'bbox':{}}
    for name,col,cel in individual:
        bb=cel.getchannel('A').getbbox()
        report['bbox'][f'{name}_{col+1}']=bb
        if bb:report['nonempty']+=1
        dig=hashlib.sha256(cel.tobytes()).hexdigest()
        all_hashes.add(dig)
        for edge,rect in [('left',(0,0,2,96)),('right',(94,0,96,96)),('top',(0,0,96,2)),('bottom',(0,94,96,96))]:
            if cel.getchannel('A').crop(rect).getbbox():report['border_warnings'].append(f'{name}_{col+1}_{edge}')
    for row,(_,count) in enumerate(STATES):
        for col in range(count,6):
            if atlas.crop((col*96,row*96,(col+1)*96,(row+1)*96)).getbbox():raise AssertionError(f'Extra pixels on row {row} col {col}')
            report['empty']+=1
    report['unique']=len(all_hashes)
    atlas.save(ROOT/'lantern_archer_d219_candidate.png')
    atlas.save(ROOT/'lantern_archer_d219_candidate.webp',format='WEBP',lossless=True,method=6)
    (ROOT/'lantern_archer_d219_candidate.webp.b64').write_text(base64.b64encode((ROOT/'lantern_archer_d219_candidate.webp').read_bytes()).decode('ascii')+'\n',encoding='ascii')
    (ROOT/'d219_art_qc.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
    bg=Image.new('RGB',(1450,1100),(20,22,27));bd=ImageDraw.Draw(bg)
    bd.text((35,24),'D219 / LANTERN ARCHER / ORIGINAL 25 POSE QA CANDIDATE',fill=(219,208,185))
    bd.text((35,52),'VISIBLE CURVED BOW + QUIVER + AMBER LANTERN  |  REAL GAME 96PX CELLS',fill=(153,166,156))
    check=Image.new('RGBA',(576,480),(44,49,52,255));ck=ImageDraw.Draw(check)
    for y in range(0,480,12):
        for x in range(0,576,12):
            if (x//12+y//12)%2==0:ck.rectangle((x,y,x+11,y+11),fill=(55,61,65,255))
    check.alpha_composite(atlas)
    bg.paste(check.resize((1152,960),Image.Resampling.NEAREST).convert('RGB'),(242,102))
    for row,(state,count) in enumerate(STATES):
        bd.text((35,102+row*192+76),f'{state.upper()} ({count})',fill=(220,200,167))
        bd.line([(242,102+row*192),(1394,102+row*192)],fill=(97,102,107),width=1)
    for c in range(7):bd.line([(242+c*192,102),(242+c*192,1062)],fill=(91,97,102),width=1)
    bg.save(ROOT/'D219_lantern_archer_animation_contact_sheet.png')
    print(json.dumps({k:v for k,v in report.items() if k!='bbox'},indent=2,ensure_ascii=False))
    print('webp bytes', (ROOT/'lantern_archer_d219_candidate.webp').stat().st_size)
if __name__=='__main__':make()
