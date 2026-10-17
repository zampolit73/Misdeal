"""D233 limited study: four 96px idle poses from D232 extracted concept sprite.
Acutal cutout-part animation, NOT native authored full 25-cel art or final approval.
Includes tail-cloth and lantern swing isolated and composited in source-resolution,
then mapped to an alpha-safe 96x96 engine tile with NEAREST filtering.
"""
from PIL import Image, ImageDraw, ImageEnhance
import base64,hashlib,json,math,os,io,sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
P=Path(sys.argv[1]) if len(sys.argv) > 1 else Path.cwd() / 'd233_idle_output'
P.mkdir(parents=True, exist_ok=True)
SOURCE=ROOT / 'assets/pixel/units/black_lantern_road_qa/road_sentinel_d232_reference_cutout.webp.b64'
SRC=Image.open(io.BytesIO(base64.b64decode(SOURCE.read_text().strip()))).convert('RGBA')
assert SRC.size == (115,129)
# full figure alpha mask originally generated from a painted scene. Keep original geometry intact.
# isolate only separate lower right cloak tail, whose outline has room to move around torso.
CLOAK_POLY=[(90,75),(97,82),(101,90),(114,97),(114,106),(109,113),(107,120),(96,113),(89,102)]
LAMP_POLY=[(46,84),(62,85),(65,91),(65,109),(61,113),(46,113),(43,107),(43,91)]

def mask_for(poly):
 m=Image.new('L',SRC.size);d=ImageDraw.Draw(m);d.polygon(poly,fill=255)
 a=Image.new('L',SRC.size)
 # combine mask with original alpha, no hard rectangle artifacts in holes
 a.paste(SRC.getchannel('A'))
 from PIL import ImageChops
 return ImageChops.multiply(m,a)

CLOAK_MASK=mask_for(CLOAK_POLY)
LAMP_MASK=mask_for(LAMP_POLY)
CLOAK=Image.new('RGBA',SRC.size,(0,0,0,0));CLOAK.paste(SRC,(0,0),CLOAK_MASK)
LAMP=Image.new('RGBA',SRC.size,(0,0,0,0));LAMP.paste(SRC,(0,0),LAMP_MASK)
# erase selected parts from torso
MAIN=SRC.copy();pix=MAIN.load();a1=CLOAK_MASK.load();a2=LAMP_MASK.load()
for y in range(SRC.height):
 for x in range(SRC.width):
  if a1[x,y] or a2[x,y]:pix[x,y]=(0,0,0,0)
# under-cloth/boots behind swinging elements; low contrast only
UNDER=Image.new('RGBA',SRC.size,(0,0,0,0));du=ImageDraw.Draw(UNDER)
du.polygon([(89,75),(98,85),(104,96),(107,112),(96,107),(88,90)],fill=(34,16,21,210))
du.polygon([(43,89),(58,88),(65,109),(46,114)],fill=(35,23,18,180))
# Reinforce the otherwise very thin pointed-spear shaft behind the original
# hand layer so nearest reduction doesn't leave two floating broken pieces.
du.line([(27,36),(45,79)],fill=(74,47,30,245),width=3)
du.line([(29,41),(44,78)],fill=(125,87,52,245),width=1)
# after masks are moved, keep underlay behind body instead of dark flat artifacts

def shift(layer,dx,dy):
 out=Image.new('RGBA',SRC.size,(0,0,0,0));out.alpha_composite(layer,(dx,dy));return out

phases=[(-1,1,1,0,0.93),(1,0,2,-1,1.08),(2,-1,-2,0,1.02),(0,1,-1,1,0.99)]
tiles=[]
for i,(lamp_dx,lamp_dy,cloak_dx,cloak_dy,glow) in enumerate(phases):
 frame=Image.new('RGBA',SRC.size,(0,0,0,0))
 frame.alpha_composite(UNDER)
 frame.alpha_composite(shift(CLOAK,cloak_dx,cloak_dy))
 frame.alpha_composite(MAIN)
 ll=shift(LAMP,lamp_dx,lamp_dy)
 # light flicker only on lantern glass, non-glowing metal untouched
 p=ll.load()
 for y in range(85,113):
  for x in range(40,67):
   r,g,b,a=p[x,y]
   if a>25 and r>120 and g>35 and r > b*1.55:
    p[x,y]=(min(255,int(r*glow)),min(255,int(g*glow)),min(255,int(b*glow)),a)
 frame.alpha_composite(ll)
 # Outline/hole QA uses true original source resolution, then nearest to engine size.
 canvas=Image.new('RGBA',(96,96),(0,0,0,0))
 cut=frame.crop((8,10,114,127)) # near full detail, still brings actor spear + feet
 # nearest-native pixel pass: fit into 88x86 making every original pixel at most 1 displayed pixel
 shrunk=cut.resize((78,86),Image.Resampling.NEAREST)
 canvas.alpha_composite(shrunk,(9,5))
 tiles.append(canvas)

atlas=Image.new('RGBA',(576,480),(0,0,0,0))
for i,tile in enumerate(tiles):atlas.alpha_composite(tile,(i*96,0))
atlas.save(P/'road_sentinel_d233_idle4_proof.png',optimize=True)
atlas.save(P/'road_sentinel_d233_idle4_proof.webp',format='WEBP',lossless=True,method=6)
encoded=base64.b64encode((P/'road_sentinel_d233_idle4_proof.webp').read_bytes()).decode()
(P/'road_sentinel_d233_idle4_proof.webp.b64').write_text(encoded)
# contact sheet 4x zoom
review=Image.new('RGB',(4*288+5*25,440),(17,16,20));dr=ImageDraw.Draw(review)
for i,tile in enumerate(tiles):
 x=24+i*(288+25)
 im=tile.resize((288,288),Image.Resampling.NEAREST)
 review.paste(im,(x,44),im)
 dr.text((x+30,10),f'D233 idle {i+1}/4',fill=(220,199,172))
review.save(P/'D233_idle4_detail_comparison.png')
# technical checks
used=[];frames=[];warnings=[];sha=[]
for i,t in enumerate(tiles):
 bbox=t.getchannel('A').getbbox();used.append(bbox)
 sha.append(hashlib.sha256(t.tobytes()).hexdigest())
 if bbox is None or bbox[0]<2 or bbox[1]<2 or bbox[2]>94 or bbox[3]>94:warnings.append([i,bbox])
print('bounds',used,'unique',len(set(sha)), 'warnings',warnings)
report={'stage':'D233 4-frame IDLE cutout-rig experiment ONLY','atlas_size':[576,480],'visible_frame_count':4,'transparent_cell_count':26,'frame_bboxes':used,'unique_sha_count':len(set(sha)),'edge_warnings':warnings,'not_valid_full_animation':True,'art_source':'D232 one original illustrated pose segmented lamp and cloak, shifted per pose; no hand-painted walk/attack/hit/death','webp_sha256':hashlib.sha256((P/'road_sentinel_d233_idle4_proof.webp').read_bytes()).hexdigest()}
(P/'D233_IDLE4_QC.json').write_text(json.dumps(report,indent=2))