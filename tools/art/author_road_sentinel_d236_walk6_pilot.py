"""D236 QA-only six-phase Road Sentinel walk, preserving D234 hand-grip.

Reproducible from in-repo D234 alpha cutout art; six hand-authored bone/boot
coordinates (not six painted full-body figures), with rust-metal plates taken
from the approved D235 visual reference. No false 25-frame production claim.
"""
from __future__ import annotations
import base64, io, json, hashlib, math, random
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter
ROOT=Path(__file__).resolve().parents[2]
SRC = ROOT/'assets/pixel/units/black_lantern_road_qa/road_sentinel_d234_handheld_idle4.webp.b64'
OUT=ROOT/'assets/pixel/units/black_lantern_road_qa/road_sentinel_d236_walk6_pilot.webp.b64'
QC=ROOT/'docs/qa/D236_SENTINEL_WALK6_PILOT_QC.json'
SIZE=96
# (left/front knee x,y, left boot x,y, right/rear knee x,y, right boot x,y,
#  left boot swing elevation, right boot swing elevation, torso horizontal lean)
PHASES=[
 (39,78,27,91, 65,78,72,91, 0,0,0),
 (43,78,37,88, 64,80,69,91, 3,0,0),
 (50,79,52,91, 57,78,58,88, 0,3,-1),
 (63,78,76,91, 42,78,29,91, 0,0,0),
 (60,79,66,88, 44,79,37,91, 3,0,1),
 (50,79,52,91, 52,79,54,88, 0,3,0),
]
assert SRC.exists(),f'missing {SRC}'
source=Image.open(io.BytesIO(base64.b64decode(SRC.read_text().strip()))).convert('RGBA')
assert source.size==(576,480)
# Sample wearable iron colors from approved D235: hand-picked restrained hues.
EDGE=(21,17,17,255)
IRON=(58,52,49,255)
IRON2=(90,77,65,255)
STEEL=(155,129,102,255)
LIGHT=(204,173,127,255)
RUST=(92,44,36,255)
CLOTH=(58,23,29,255)

def thick_segment(draw:ImageDraw.ImageDraw, a:tuple[int,int], b:tuple[int,int], widths:int):
 draw.line([a,b],fill=EDGE,width=widths+3,joint='curve')
 draw.line([a,b],fill=IRON,width=widths,joint='curve')
 draw.line([(a[0]-1,a[1]),(b[0]-1,b[1])],fill=IRON2,width=max(1,widths-3))
 draw.line([(a[0]-2,a[1]-1),(b[0]-2,b[1]-1)],fill=STEEL,width=1)

def leg_layer(phase:int,coords:tuple[int,...])->Image.Image:
 lx,ly,lfx,lfy,rx,ry,rfx,rfy,l_lift,r_lift,shift=coords
 canvas=Image.new('RGBA',(SIZE,SIZE),(0,0,0,0));d=ImageDraw.Draw(canvas)
 # Rear leg first, from left hip under cloak to articulated knee and planted shoe.
 for which,hip,knee,foot,lift in (
  ('rear',(59,65),(rx,ry),(rfx,rfy),r_lift),
  ('front',(46,66),(lx,ly),(lfx,lfy),l_lift)):
  thick_segment(d,hip,knee,7 if which=='front' else 6)
  d.ellipse((knee[0]-4,knee[1]-4,knee[0]+4,knee[1]+4),fill=EDGE)
  d.ellipse((knee[0]-3,knee[1]-3,knee[0]+2,knee[1]+1),fill=IRON2)
  d.line((knee[0]-2,knee[1]-2,knee[0]+1,knee[1]-2),fill=LIGHT,width=1)
  ankle=(foot[0]+3,foot[1]-3)
  thick_segment(d,knee,ankle,5 if which=='front' else 4)
  # Irregular iron greave plates; suit leg geometry rather than floating circles.
  dx=ankle[0]-knee[0];dy=ankle[1]-knee[1]
  for t in [0.31,0.67]:
   cx=round(knee[0]+dx*t);cy=round(knee[1]+dy*t)
   d.line((cx-2,cy,cx+2,cy+1),fill=RUST,width=2)
   d.line((cx-1,cy-1,cx+1,cy-1),fill=STEEL,width=1)
  # Boots are drawn tangent to the same y=91 floor for the planted foot.
  bx,by=foot
  boot=[(bx-9,by-1),(bx-7,by-3),(bx-2,by-4),(bx+5,by-3),(bx+6,by),(bx+3,by+1),(bx-8,by+1)]
  d.polygon(boot,fill=EDGE)
  d.polygon([(bx-7,by-2),(bx-2,by-3),(bx+4,by-2),(bx+3,by-1),(bx-6,by-1)],fill=IRON2)
  d.line((bx-6,by-3,bx-1,by-3),fill=STEEL,width=1)
  d.point((bx-5,by-2),fill=LIGHT)
 return canvas

atlas=Image.new('RGBA',(576,480),(0,0,0,0));frames=[]
for i,pose in enumerate(PHASES):
 body=source.crop(((i%4)*SIZE,0,((i%4)+1)*SIZE,SIZE)).copy()
 # Remove only the existing tiny static soles below the hem, leaving the
 # illustrated weapon, face, cloth and connected wrist-mounted lamp unchanged.
 for x0,x1,y0 in [(36,47,86),(70,82,85)]:
  for y in range(y0,SIZE):
   for x in range(x0,x1):
    body.putpixel((x,y),(0,0,0,0))
 legs=leg_layer(i,pose)
 result=Image.alpha_composite(legs,body)
 # Tiny iron-boot details remain opaque and safely away from the cel edges.
 atlas.alpha_composite(result,(i*SIZE,SIZE))
 frames.append(result)

out_bytes=io.BytesIO();atlas.save(out_bytes,format='WEBP',lossless=True,method=6)
blob=out_bytes.getvalue();assert Image.open(io.BytesIO(blob)).convert('RGBA').tobytes()==atlas.tobytes()
OUT.parent.mkdir(parents=True,exist_ok=True);OUT.write_text(base64.b64encode(blob).decode())
img_path=Path('/mnt/data/d236_walk/road_sentinel_d236_walk6_pilot.png');atlas.save(img_path)
# Diagnostic both original cels (idle) and six leg-motion state previews.
board=Image.new('RGB',(6*192,310),(22,25,29))
for i,im in enumerate(frames):
 thumb=im.resize((192,192),Image.Resampling.NEAREST)
 board.paste(thumb,(i*192,28),thumb)
 ImageDraw.Draw(board).text((i*192+83,8),f'WALK {i+1}',fill=(221,194,155))
board.save('/mnt/data/d236_walk/D236_walk6_contact_sheet.png')
qc={'stage':'D236 TRUE 6-phase articulated leg rig pilot using rich D234 illustrated upper body',
'approved_visual_reference':'D235 six-pose 1536x1024 poster (not used as engine cells)',
'states_implemented':['walk'],'poses_authored_as':'six DIFFERENT knee/boot coordinate pairs with plated leg/boot drawing; 4 handgrip-held rich D234 upper-body phases REUSED; this is NOT six fully separately painted whole bodies',
'canvas':[576,480],'cell':[96,96],'used_cells':6,'unused_cells':24,'row_index':1,
'no_full_sprite_claim':True,'native_F6_status':'PENDING','production_installed':False,
'coordinates':[],'hashes':[],'warnings':[],'webp_sha256':hashlib.sha256(blob).hexdigest()}
for i,frame in enumerate(frames):
 alpha=frame.getchannel('A');bbox=alpha.getbbox()
 sig=hashlib.sha256(frame.tobytes()).hexdigest();qc['hashes'].append(sig)
 poses=PHASES[i];qc['coordinates'].append({'frame':i,'bbox':bbox,'knee_left':[poses[0],poses[1]],'boot_left':[poses[2],poses[3]],'knee_right':[poses[4],poses[5]],'boot_right':[poses[6],poses[7]],'lift_left':poses[8],'lift_right':poses[9]})
 if bbox is None or bbox[0]<2 or bbox[1]<2 or bbox[2]>94 or bbox[3]>94:qc['warnings'].append(f'cel {i} touches 2px margins {bbox}')
assert len(set(qc['hashes']))==6
assert not qc['warnings'],qc['warnings']
QC.parent.mkdir(parents=True,exist_ok=True);QC.write_text(json.dumps(qc,ensure_ascii=False,indent=2))
print('WRITE',OUT, len(blob), 'SHA',qc['webp_sha256']);print('CHECK 6 nonempty 24 clear 0 border; bboxes', [x['bbox'] for x in qc['coordinates']])