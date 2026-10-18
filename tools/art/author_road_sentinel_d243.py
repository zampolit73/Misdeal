"""D243 original frame-by-frame pixel-geometry animation study: QA ONLY.

No reuse of D239/D241 body cutouts, no whole-image rotation/scaling.
Character anatomy, equipment and fabric are redrawn from per-pose joint locations.
Visual fidelity to approved D235 illustration is NOT presumed: compare in Godot.
"""
from __future__ import annotations
from dataclasses import dataclass
from pathlib import Path
from PIL import Image, ImageDraw
import base64,hashlib,io,json,math

ROOT = Path(__file__).resolve().parents[2] if (Path(__file__).resolve().parents[2]/'assets').exists() else Path(__file__).parent
OUT = ROOT/'assets/pixel/units/black_lantern_road_qa/road_sentinel_d243_articulated25_qa.webp.b64'
QC = ROOT/'docs/qa/D243_SENTINEL_ARTICULATED_QC.json'
SIZE=96
COUNTS=[4,6,6,3,6]
NAMES=['idle','walk','attack','hit','death']
INK='#11151c'; INK2='#20242a'; MAROON='#49232b'; MAROON_HI='#7b3434'; MAROON_EDGE='#ac5e4a'
STEEL='#394149'; STEEL_D='#272c35'; STEEL_B='#586169'; STEEL_HI='#949894'; BONE='#c5b3a0'; BONE_SH='#928676'
DARK='#151a22'; LEATHER='#513829'; GOLD='#b88248'; GLOW='#f8ad42'

@dataclass(frozen=True)
class Pose:
    head:tuple; neck:tuple; shoulder:tuple; hip:tuple
    shoulder_back:tuple; elbow_s:tuple; hand_s:tuple; elbow_l:tuple; hand_l:tuple
    knee_back:tuple; ankle_back:tuple; knee_front:tuple; ankle_front:tuple
    spear_tip:tuple; lantern_angle:int=0; fabric:int=0; look:str='left'
    back_foot_ground:bool=True; front_foot_ground:bool=True

def p(x,y): return (int(round(x)),int(round(y)))
def add(a,b):return (a[0]+b[0],a[1]+b[1])
def path(d,points,fill,w=1): d.line([p(*pt) for pt in points],fill=fill,width=w,joint='curve')
def oval(d,center,rx,ry,fill,outline=None):
    x,y=center; d.ellipse((round(x-rx),round(y-ry),round(x+rx),round(y+ry)),fill=fill,outline=outline)
def quad(d,pts,fill,outline=None):d.polygon([p(*x) for x in pts],fill=fill);d.line([p(*x) for x in pts]+[p(*pts[0])],fill=outline or fill,width=1)
def segment(d,a,b,r,base,edge=INK,shine=None):
    dx=b[0]-a[0];dy=b[1]-a[1]; length=max(1,math.hypot(dx,dy)); nx=-dy/length;ny=dx/length
    q=[(a[0]+nx*r,a[1]+ny*r),(b[0]+nx*(r*.8),b[1]+ny*(r*.8)),(b[0]-nx*(r*.8),b[1]-ny*(r*.8)),(a[0]-nx*r,a[1]-ny*r)]
    quad(d,q,base,edge)
    if shine: path(d,[(a[0]+nx*r*.45,a[1]+ny*r*.45),(b[0]+nx*r*.25,b[1]+ny*r*.25)],shine,1)

def base(head=(46,20),neck=(48,29),shoulder=(49,36),hip=(51,60),
         shoulder_back=(54,37), elbow_s=(39,43), hand_s=(34,48),elbow_l=(60,43),hand_l=(61,48),
         knee_back=(61,74),ankle_back=(64,90),knee_front=(44,73),ankle_front=(41,90),
         spear_tip=(11,8),**kw):
    return Pose(head,neck,shoulder,hip,shoulder_back,elbow_s,hand_s,elbow_l,hand_l,
                knee_back,ankle_back,knee_front,ankle_front,spear_tip,**kw)

def poses():
    idle=[
     base(fabric=0),
     base(head=(46,19),neck=(48,28),hand_l=(61,49),elbow_l=(59,43),fabric=1,spear_tip=(11,7)),
     base(head=(45,20),shoulder=(48,37),hip=(50,60),hand_l=(62,48),lantern_angle=1,fabric=-1,spear_tip=(10,9)),
     base(head=(46,21),neck=(48,30),shoulder=(49,37),hand_l=(60,47),lantern_angle=-1,fabric=2,spear_tip=(12,10))]
    # Authentic two-leg support/swing: each frame moves hips, knees and BOTH ankles
    # while the head, cape and carried objects respond to center-of-mass shifts.
    walks=[
     base(head=(46,19),hip=(50,59),knee_front=(42,73),ankle_front=(39,90),knee_back=(58,73),ankle_back=(60,89),fabric=3),
     base(head=(45,20),hip=(49,60),knee_front=(39,75),ankle_front=(40,91),knee_back=(55,73),ankle_back=(58,85),front_foot_ground=True,back_foot_ground=False,hand_l=(61,50),spear_tip=(10,10),fabric=2),
     base(head=(45,21),shoulder=(48,37),hip=(49,61),knee_front=(48,75),ankle_front=(48,90),knee_back=(53,73),ankle_back=(55,85),front_foot_ground=True,back_foot_ground=False,hand_l=(59,48),fabric=0),
     base(head=(46,19),hip=(50,59),knee_front=(44,73),ankle_front=(42,87),knee_back=(60,74),ankle_back=(63,91),front_foot_ground=False,back_foot_ground=True,hand_l=(62,48),fabric=-2),
     base(head=(47,20),hip=(51,60),knee_front=(46,72),ankle_front=(44,85),knee_back=(62,74),ankle_back=(62,91),front_foot_ground=False,back_foot_ground=True,hand_l=(63,50),spear_tip=(12,10),fabric=-3),
     base(head=(47,21),shoulder=(50,37),hip=(51,61),knee_front=(43,74),ankle_front=(41,89),knee_back=(55,74),ankle_back=(57,90),fabric=-1)]
    # Important: spear hand is moved with elbow/torso through windup -> real
    # near-horizontal contact -> follow-through -> recoiling guard; no rotated
    # pasted weapon. Each thrust has its own planted/kneeling leg positions.
    attacks=[
     base(head=(48,21),neck=(50,31),shoulder=(53,38),hip=(55,61),elbow_s=(46,40),hand_s=(43,46),elbow_l=(63,46),hand_l=(64,49),knee_front=(43,76),ankle_front=(39,90),knee_back=(63,76),ankle_back=(67,90),spear_tip=(25,7),fabric=1),
     base(head=(51,20),neck=(52,30),shoulder=(55,37),hip=(57,60),elbow_s=(44,43),hand_s=(39,46),elbow_l=(65,43),hand_l=(66,48),knee_front=(43,74),ankle_front=(38,91),knee_back=(66,75),ankle_back=(70,91),spear_tip=(15,22),fabric=3),
     base(head=(51,22),neck=(53,33),shoulder=(56,40),hip=(58,60),elbow_s=(42,45),hand_s=(33,47),elbow_l=(66,46),hand_l=(67,51),knee_front=(43,76),ankle_front=(37,91),knee_back=(67,75),ankle_back=(72,91),spear_tip=(7,43),fabric=4),
     base(head=(52,24),neck=(55,34),shoulder=(58,41),hip=(59,61),elbow_s=(43,47),hand_s=(31,49),elbow_l=(68,46),hand_l=(67,53),knee_front=(42,75),ankle_front=(36,91),knee_back=(68,75),ankle_back=(73,91),spear_tip=(5,47),fabric=5),
     base(head=(50,23),neck=(52,32),shoulder=(54,39),hip=(56,61),elbow_s=(43,44),hand_s=(38,47),elbow_l=(65,46),hand_l=(66,51),knee_front=(43,75),ankle_front=(38,91),knee_back=(64,75),ankle_back=(69,90),spear_tip=(13,30),fabric=3),
     base(head=(47,20),neck=(49,29),shoulder=(51,37),hip=(53,60),elbow_s=(40,43),hand_s=(35,47),elbow_l=(61,44),hand_l=(63,49),knee_front=(44,74),ankle_front=(40,90),knee_back=(62,75),ankle_back=(64,90),spear_tip=(12,9),fabric=1)]
    hits=[
     base(head=(55,19),neck=(53,31),shoulder=(51,39),hip=(50,62),elbow_s=(43,38),hand_s=(38,47),elbow_l=(61,38),hand_l=(64,47),knee_front=(40,76),ankle_front=(39,90),knee_back=(61,77),ankle_back=(65,91),spear_tip=(19,13),fabric=-5),
     base(head=(60,29),neck=(54,39),shoulder=(50,45),hip=(50,66),elbow_s=(40,46),hand_s=(35,57),elbow_l=(63,46),hand_l=(67,56),knee_front=(40,77),ankle_front=(39,91),knee_back=(60,80),ankle_back=(66,91),spear_tip=(9,27),fabric=-6),
     base(head=(51,23),neck=(51,32),shoulder=(51,40),hip=(50,62),elbow_s=(42,44),hand_s=(37,49),elbow_l=(62,44),hand_l=(63,51),knee_front=(42,76),ankle_front=(40,91),knee_back=(60,75),ankle_back=(64,91),spear_tip=(13,14),fabric=-3)]
    # Six separate anatomical arrangements, not whole-portrait rotation/squash.
    deaths=[
     base(head=(57,20),neck=(53,32),shoulder=(51,40),hip=(50,64),elbow_s=(43,43),hand_s=(37,53),elbow_l=(62,44),hand_l=(67,57),knee_front=(41,77),ankle_front=(39,91),knee_back=(60,78),ankle_back=(66,91),spear_tip=(13,22),fabric=-6),
     base(head=(60,29),neck=(55,40),shoulder=(50,47),hip=(48,70),elbow_s=(37,51),hand_s=(29,62),elbow_l=(61,51),hand_l=(66,66),knee_front=(38,83),ankle_front=(34,91),knee_back=(59,84),ankle_back=(66,91),spear_tip=(8,37),fabric=-8),
     base(head=(64,45),neck=(57,49),shoulder=(50,54),hip=(47,75),elbow_s=(38,59),hand_s=(29,73),elbow_l=(63,57),hand_l=(67,71),knee_front=(37,85),ankle_front=(29,91),knee_back=(57,87),ankle_back=(65,91),spear_tip=(8,55),fabric=-7),
     base(head=(50,69),neck=(55,68),shoulder=(59,71),hip=(69,81),shoulder_back=(63,72),elbow_s=(44,74),hand_s=(35,85),elbow_l=(67,73),hand_l=(74,82),knee_front=(72,86),ankle_front=(83,91),knee_back=(78,85),ankle_back=(87,91),spear_tip=(7,82),fabric=0),
     base(head=(36,79),neck=(45,78),shoulder=(52,80),hip=(65,84),shoulder_back=(57,80),elbow_s=(44,84),hand_s=(30,87),elbow_l=(65,81),hand_l=(74,87),knee_front=(73,85),ankle_front=(83,91),knee_back=(77,86),ankle_back=(85,91),spear_tip=(7,86),fabric=-1),
     base(head=(32,82),neck=(42,82),shoulder=(50,83),hip=(64,84),shoulder_back=(56,82),elbow_s=(40,86),hand_s=(28,88),elbow_l=(63,84),hand_l=(73,88),knee_front=(72,86),ankle_front=(83,91),knee_back=(78,86),ankle_back=(85,91),spear_tip=(6,87),fabric=-2)]
    return [idle,walks,attacks,hits,deaths]

def render(a:Pose,state:str,index:int):
    im=Image.new('RGBA',(SIZE,SIZE));d=ImageDraw.Draw(im)
    h=a.head;n=a.neck;s=a.shoulder;hip=a.hip
    sx,sy=s
    fallen=(state=='death' and index>=2)
    # Cloak: a new silhouette connecting *this pose's* shoulders to hips.
    outer=add(a.shoulder_back,(2,-5)); cape_tip=(max(2,min(89,hip[0]+20+a.fabric)), min(90,hip[1]+18))
    cloaky = min(90,hip[1]+(5 if fallen else 15))
    cloak=[(n[0]+5,n[1]-4),outer,(sx+15+a.fabric,min(88,sy+14) if fallen else sy+14),(cape_tip[0],cape_tip[1]),(hip[0]+2,cloaky),(hip[0]-4,hip[1]+4)]
    quad(d,cloak,INK)
    quad(d,[outer,(sx+12+a.fabric,min(88,sy+10) if fallen else sy+10),cape_tip,(hip[0]+4,min(90,hip[1]+(4 if fallen else 13))),(hip[0]+1,hip[1]-1)],MAROON)
    path(d,[(sx+12+a.fabric,min(87,sy+13) if fallen else sy+13),(cape_tip[0]-2,cape_tip[1]-2)],MAROON_HI,2)
    # ragged hems: deterministic unequal slits, not uniform procedural noise
    tip=cape_tip;path(d,[add(tip,(-7,-6)),add(tip,(-4,-1)),add(tip,(-1,-5))],MAROON_EDGE,1)
    # Rear leg bone+matching plate greave, drawn from actual connected joints.
    def leg(knee,ankle,rear):
        sock=STEEL_D if rear else STEEL
        segment(d,hip,knee,5,sock,INK,STEEL_B if not rear else None)
        oval(d,knee,4,4,STEEL_B if rear else STEEL_HI,INK)
        segment(d,knee,(ankle[0],ankle[1]-5),4,STEEL_D if rear else STEEL,INK,STEEL_B)
        # matching flared greave without overlaying someone else's boots
        if not fallen:
            segment(d,(knee[0],knee[1]+5),(ankle[0],ankle[1]-5),3.2,STEEL_B if not rear else STEEL_D,INK)
        else:
            path(d,[knee,(ankle[0],ankle[1]-4)],STEEL_B if not rear else STEEL_D,2)
        # articulated matching iron sabot points LEFT, solid ground stance
        boot_y=min(91,ankle[1]); ankle_x=ankle[0]
        boot=[(ankle_x-5,boot_y-6),(ankle_x+5,boot_y-6),(ankle_x+6,boot_y-1),(ankle_x-10,boot_y),(ankle_x-12,boot_y-2)]
        quad(d,boot,INK);path(d,[(ankle_x-7,boot_y-3),(ankle_x+3,boot_y-3)],STEEL_HI if not rear else STEEL_B,1)
    leg(a.knee_back,a.ankle_back,True)
    leg(a.knee_front,a.ankle_front,False)
    # Distinct tunic and belt rotate by torso JOINTS, not pasted still.
    segment(d,s,hip,7 if fallen else 11,INK)
    quad(d,[(sx-9,sy-2),(sx+11,sy-5),(hip[0]+10,hip[1]-2),(hip[0]-11,hip[1]+1)],STEEL_D,INK)
    segment(d,(sx-4,sy+3),(hip[0]-2,hip[1]-5),6,STEEL,INK,STEEL_B)
    # overlapping rib/fluted plates on chest
    for frac in (.20,.48,.76):
        xx=(sx-2)*(1-frac)+(hip[0]-2)*frac; yy=(sy+3)*(1-frac)+(hip[1]-5)*frac
        path(d,[(xx-6,yy-2),(xx+6,yy-1)],STEEL_HI if frac==.2 else STEEL_B,1)
    path(d,[(sx+7,sy-2),(hip[0]+6,hip[1]-5)],STEEL_HI,2)
    segment(d,(hip[0]-8,hip[1]),(hip[0]+9,hip[1]),3,LEATHER,INK)
    oval(d,(hip[0],hip[1]),2,2,GOLD,INK)
    # Inlaid small rivets; preserve sparse purposeful clusters.
    for px,py in [(sx-7,sy+1),(sx+8,sy+2),(hip[0]-7,hip[1]-4)]: oval(d,(px,py),1,1,STEEL_HI)
    # Bearer side: free arm moves WITH lantern and never loses handle grip.
    segment(d,a.shoulder_back,a.elbow_l,4,STEEL_D,INK,STEEL_B)
    oval(d,a.elbow_l,3,3,STEEL_B,INK)
    segment(d,a.elbow_l,a.hand_l,3,STEEL,INK,STEEL_HI)
    # Spear-side arm articulated from shoulder through elbow and gauntlet.
    segment(d,s,a.elbow_s,5,STEEL_D,INK,STEEL_B)
    oval(d,a.elbow_s,3,3,STEEL_B,INK)
    segment(d,a.elbow_s,a.hand_s,3,STEEL,INK,STEEL_HI)
    # Hood+skull at changing actual neck/head positions.
    segment(d,n,h,4,MAROON,INK)
    if fallen:
        # Separate lying skull/hood model, not a sideways rotated upright head.
        quad(d,[(h[0]-11,h[1]-6),(h[0]+9,h[1]-6),(h[0]+11,h[1]+6),(h[0]-10,h[1]+6)],MAROON,INK)
        path(d,[(h[0]-10,h[1]-5),(h[0]+7,h[1]-5)],MAROON_HI,2)
        oval(d,(h[0]-1,h[1]),7,5,BONE,INK)
        oval(d,(h[0]-5,h[1]-1),2,2,DARK)
        d.point((h[0]-6,h[1]-1),fill='#e5ad4b')
        path(d,[(h[0]-6,h[1]+3),(h[0]+4,h[1]+3)],INK,2)
    else:
        oval(d,h,9,11,INK)
        hood=[(h[0]-10,h[1]-1),(h[0]-7,h[1]-10),(h[0]+2,h[1]-12),(h[0]+10,h[1]-4),(h[0]+10,h[1]+8),(h[0]+4,h[1]+13),(h[0]-8,h[1]+9)]
        quad(d,hood,MAROON)
        path(d,hood[:5],MAROON_HI,2)
        oval(d,(h[0]-1,h[1]+2),6,7,BONE,INK)
        oval(d,(h[0]-4,h[1]+1),2,2,DARK)
        oval(d,(h[0]+2,h[1]+2),2,2,DARK)
        d.point((h[0]-4,h[1]+1),fill='#e5ad4b')
        path(d,[(h[0]-3,h[1]+7),(h[0]+3,h[1]+8)],INK,2)
        for j in [-2,1,4]:d.point((h[0]+j,h[1]+8),fill=BONE_SH)
    # Purposeful forehead visor fragments and corroded shoulder cap.
    path(d,[(h[0]-7,h[1]-3),(h[0]+4,h[1]-4)],STEEL_B,2)
    oval(d,s,7,5,STEEL_D,INK)
    path(d,[(sx-6,sy-2),(sx+3,sy-5),(sx+6,sy-3)],STEEL_HI,1)
    # Weapon is redrawn as shaft from this frame's gauntlet toward exact tip.
    # Blade orientation derives from tip vector; NEVER rotate a source picture.
    grip=a.hand_s;tip=a.spear_tip
    vx=tip[0]-grip[0];vy=tip[1]-grip[1];ln=max(1,math.hypot(vx,vy));ux=vx/ln;uy=vy/ln;nx=-uy;ny=ux
    butt=(grip[0]-ux*16,grip[1]-uy*16)
    path(d,[butt,tip],INK,5);path(d,[butt,tip],LEATHER,3)
    path(d,[(butt[0]+1,butt[1]),(tip[0]+1,tip[1])],GOLD,1)
    spear_base=(tip[0]-ux*10,tip[1]-uy*10)
    blade=[(tip[0],tip[1]),(spear_base[0]+nx*3,spear_base[1]+ny*3),
           (spear_base[0]-ux*5,spear_base[1]-uy*5),
           (spear_base[0]-nx*3,spear_base[1]-ny*3)]
    quad(d,blade,STEEL_HI,INK)
    path(d,[(tip[0],tip[1]),(spear_base[0]-ux*6,spear_base[1]-uy*6)],'#c1b7a3',1)
    # Iron-sheathed hand OVER shaft: an unambiguous maintained grip.
    oval(d,grip,4,3,INK);oval(d,grip,3,2,STEEL_HI,INK)
    # Lantern hook/grip is a mechanically connected set (no floating glass).
    gh=a.hand_l
    # clipped short chain and hanging iron handle, suspension directly BELOW gauntlet
    cx=gh[0]+a.lantern_angle;cy=gh[1]+3
    hook_y = min(90, cy+5) if fallen else cy+5
    path(d,[(gh[0],min(90,gh[1]+1) if fallen else gh[1]+1),(cx,min(90,cy) if fallen else cy),(cx,hook_y)],INK,3)
    path(d,[(gh[0],min(90,gh[1]+1) if fallen else gh[1]+1),(cx,hook_y)],GOLD,1)
    lamp_center=(cx,cy+12)
    if not fallen:
        quad(d,[(cx-5,cy+8),(cx+5,cy+8),(cx+6,cy+20),(cx-6,cy+20)],INK)
        quad(d,[(cx-3,cy+10),(cx+3,cy+10),(cx+4,cy+17),(cx-4,cy+17)],'#8a4c26')
        quad(d,[(cx-2,cy+11),(cx+2,cy+11),(cx+3,cy+16),(cx-3,cy+16)],GLOW)
        path(d,[(cx,cy+8),(cx,cy+21)],STEEL_HI,1)
        path(d,[(cx-6,cy+9),(cx+6,cy+9)],GOLD,2)
        path(d,[(cx-6,cy+19),(cx+6,cy+19)],GOLD,2)
    else:
        # Fallen lantern's housing remains identifiable, settles on floor.
        py=min(90,cy+12);quad(d,[(cx-6,py-5),(cx+5,py-5),(cx+6,py+1),(cx-6,py+1)],INK)
        quad(d,[(cx-4,py-3),(cx+3,py-3),(cx+4,py),(cx-4,py)],GLOW)
    # Hand repainted over lantern handle.
    oval(d,gh,3,3,STEEL,INK);path(d,[(gh[0]-2,gh[1]-1),(gh[0]+2,gh[1])],STEEL_HI,1)
    # A few deliberately placed rust pocks, stable on the material surface.
    for point in [(sx+3,sy+8),(hip[0]+3,hip[1]-5),(sx-4,sy+10)]:d.point(p(*point),fill=MAROON_EDGE)
    return im

def build():
    groups=poses();sheet=Image.new('RGBA',(576,480));seen=set();qc=[]
    for row,states in enumerate(groups):
        assert len(states)==COUNTS[row]
        for col,pose in enumerate(states):
            im=render(pose,NAMES[row],col)
            box=im.getchannel('A').getbbox()
            assert box is not None, (row,col,'empty')
            assert box[0]>=2 and box[1]>=2 and box[2]<=94 and box[3]<=94,(row,col,box)
            sha=hashlib.sha256(im.tobytes()).hexdigest();assert sha not in seen,(row,col,'duplicate')
            seen.add(sha);sheet.alpha_composite(im,(col*96,row*96))
            qc.append({'state':NAMES[row],'frame':col,'alpha_bbox':box,'rgba_sha256':sha})
    assert len(seen)==25
    for row,n in enumerate(COUNTS):
        for col in range(n,6):assert sheet.crop((col*96,row*96,col*96+96,row*96+96)).getchannel('A').getbbox() is None
    data=io.BytesIO();sheet.save(data,format='WEBP',lossless=True,method=6);raw=data.getvalue()
    assert Image.open(io.BytesIO(raw)).convert('RGBA').tobytes()==sheet.tobytes()
    OUT.parent.mkdir(parents=True,exist_ok=True);OUT.write_text(base64.b64encode(raw).decode()+'\n')
    QC.parent.mkdir(parents=True,exist_ok=True)
    QC.write_text(json.dumps({'stage':'D243 explicit 25-frame joint-posed art study','artifact_stage':'QA ONLY — native visual NOT RUN','not_final_art':True,'approved_d235_painted_reference_matched':False,'full_body_pasted_transforms':False,'counts':COUNTS,'empty':5,'unique':len(seen),'frames':qc,'sha256':hashlib.sha256(raw).hexdigest()},ensure_ascii=False,indent=2)+'\n')
    return sheet
if __name__=='__main__':
    img=build();img.save(Path(__file__).with_suffix('.png'))
    print('D243 created',OUT,'25 poses, 5 empty, exact lossless WebP')
