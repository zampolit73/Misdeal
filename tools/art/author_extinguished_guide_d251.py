#!/usr/bin/env python3
"""D251 offline QA extractor for rich triple-yoke Guide illustration.

A NONFINAL candidate until visual and native F6 approval. The generated concept
contains extra figures and an opaque captioned background; manually identified
actor rectangles and robust local difference extraction are intentional.
Requires Pillow + OpenCV + NumPy, used offline only; Godot has no dependency.
"""
from PIL import Image,ImageDraw,ImageFont
import numpy as np, cv2, io, base64, hashlib, json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
SRC=ROOT/'assets/pixel/units/black_lantern_road_qa/extinguished_guide_d251_rich_source.webp.b64'
DST=ROOT/'assets/pixel/units/black_lantern_road_qa/extinguished_guide_d251_rich25_qa.webp.b64'
QC=ROOT/'docs/qa/D251_GUIDE_RICH25_EXTRACTION_QC.json'
OUT=Path.cwd()/'d251_guide_build';OUT.mkdir(exist_ok=True)
RAW=base64.b64decode(SRC.read_text().strip())
source=Image.open(io.BytesIO(RAW)).convert('RGB')
if source.size!=(1536,1024):raise RuntimeError(f'Original illustration is not 1536x1024: {source.size}')
array=np.asarray(source).copy()
# Exact illustration regions: original illustration labels/caption separators are outside these.
# Two rows contain 7 rendered drawings despite their textual labels saying 6. Skip
# the 7th walk and the 6th attack sprite, preserving six complete gestures.
ROIS={
 'idle':[(23,507,159,625),(159,507,290,625),(289,507,421,625),(422,507,566,625)],
 'walk':[(594,507,721,625),(724,507,852,625),(857,507,978,625),(980,507,1105,625),(1108,507,1233,625),(1235,507,1357,625)],
 'attack':[(18,667,223,771),(227,667,464,771),(467,667,698,771),(700,667,934,771),(937,667,1154,771),(1327,667,1520,771)],
 'hit':[(20,822,157,962),(160,822,288,962),(293,822,503,962)],
 'death':[(510,822,666,962),(668,822,823,962),(825,822,1002,962),(1005,822,1204,962),(1208,822,1346,962),(1349,822,1520,962)]
}
# Static source inspection deliberately prevents the model's extra paintings
# from entering a prescribed 6-column frame layout or spilling across neighbors.
NAMES=['idle','walk','attack','hit','death']; COUNTS=[4,6,6,3,6]
ATLAS=Image.new('RGBA',(576,480));report={'source_size':source.size,'source_webp_sha256':hashlib.sha256(RAW).hexdigest(),'staging':'QA, not production','row_counts':COUNTS,'frames':[],'warnings':[]}
# The image's smoothly varying brown studio background is removed by local
# color-distance from a robust 91px spatial median of each source action row.
row_bg={}
for name in NAMES:
 y0=min(v[1] for v in ROIS[name]);y1=max(v[3] for v in ROIS[name]);lo=max(0,y0-20);hi=min(array.shape[0],y1+20)
 median=cv2.medianBlur(array[lo:hi],91)
 row_bg[name]=(lo,cv2.GaussianBlur(median,(0,0),13))
for rid,name in enumerate(NAMES):
 for col,box in enumerate(ROIS[name]):
  x0,y0,x1,y1=box;roi=array[y0:y1,x0:x1];lo,bgimg=row_bg[name];bg=bgimg[y0-lo:y1-lo,x0:x1]
  dist=np.sqrt(np.sum((roi.astype('float32')-bg.astype('float32'))**2,axis=2))
  opaque=((dist>31.0).astype(np.uint8)*255)
  opaque=cv2.morphologyEx(opaque,cv2.MORPH_CLOSE,np.ones((3,3),np.uint8))
  # Keep physically articulated figure pieces, including all three non-touching lights.
  components,labels,stats,_=cv2.connectedComponentsWithStats(opaque)
  mask=np.zeros_like(opaque)
  for ci in range(1,components):
   if stats[ci,cv2.CC_STAT_AREA]>=11:mask[labels==ci]=255
  # Avoid any leftover straight separator line at the bottom of a source row.
  mask[-2:,:]=0
  yy,xx=np.nonzero(mask)
  if len(xx)<500:raise RuntimeError(f'Insufficient extracted original pixels {name} {col}: {len(xx)}')
  ax0=max(0,int(xx.min())-2);ax1=min(x1-x0,int(xx.max())+3)
  ay0=max(0,int(yy.min())-2);ay1=min(y1-y0,int(yy.max())+3)
  rgba=Image.fromarray(np.dstack((roi,mask)),'RGBA').crop((ax0,ay0,ax1,ay1))
  # Keep natural proportions, with 2px cell padding; explicitly avoid
  # stretching armor. This means very wide chained attacks read smaller.
  scale=min(88/rgba.width,88/rgba.height)
  dims=(max(1,round(rgba.width*scale)),max(1,round(rgba.height*scale)))
  if name=='attack':
   # Perspective foreshortening only the long dangling chain/lantern gesture
   # while keeping the torso, head, shoulders and armor close to the same x/y
   # scale as walking. Piecewise x remap keeps the BODY undistorted and
   # compresses the empty reaching distance of the two hanging chains.
   # This is still an internal candidate and MUST be inspected at 1x.
   h=max(1,round(rgba.height*0.71)); dims=(88,h)
   src_arr=np.asarray(rgba)
   width=rgba.width;ctr=width*0.52
   a=max(5.,ctr-38.); b=min(width-5.,ctr+38.)
   xp=np.array([0.,17.,71.,87.],dtype=np.float32)
   source_x=np.array([0.,a,b,float(width-1)],dtype=np.float32)
   # Output x -> input x (full silhouette always preserved).
   grid_x=np.interp(np.arange(88,dtype=np.float32),xp,source_x).astype(np.float32)
   src_y=np.linspace(0,rgba.height-1,h,dtype=np.float32)
   mesh_x=np.tile(grid_x,(h,1));mesh_y=np.tile(src_y[:,None],(1,88))
   warped=cv2.remap(src_arr,mesh_x,mesh_y,interpolation=cv2.INTER_LINEAR,borderMode=cv2.BORDER_CONSTANT)
   sprite=Image.fromarray(warped,'RGBA')
  else:
   sprite=rgba.resize(dims,Image.Resampling.LANCZOS)
  px=(96-dims[0])//2;py=93-dims[1]
  if px<2 or py<2:raise RuntimeError(f'Border failed {name} {col}: {px},{py} dims={dims}')
  ATLAS.alpha_composite(sprite,(col*96+px,rid*96+py))
  report['frames'].append({'state':name,'col':col,'source_roi':box,'island_bbox_local':[ax0,ay0,ax1,ay1],'source_size':[rgba.width,rgba.height],'packed_size':list(dims),'offset':[px,py],'source_pixel_mask':int((mask>0).sum()),'relative_scale':round(scale,3)})
# Normalize hidden RGB (lossless WebP cannot preserve RGB below zero alpha).
a=np.asarray(ATLAS).copy();a[a[:,:,3]==0,:3]=0;ATLAS=Image.fromarray(a,'RGBA')
# Structural verification on actual atlas and WebP after serialization.
webp=io.BytesIO();ATLAS.save(webp,format='WEBP',lossless=True,method=6)
RAW_WEBP=webp.getvalue();reopened=Image.open(io.BytesIO(RAW_WEBP)).convert('RGBA')
a1=np.asarray(reopened);a2=np.asarray(ATLAS);mask=a2[:,:,3]>0;print('WEBP decoded differences:',int((a1[:,:,3]!=a2[:,:,3]).sum()),int((a1[:,:,:3][mask]!=a2[:,:,:3][mask]).sum()),'max',int(np.abs(a1.astype('int16')-a2.astype('int16')).max()))
if np.any(a1[:,:,3]!=a2[:,:,3]) or np.any(a1[:,:,:3][mask]!=a2[:,:,:3][mask]):raise RuntimeError('Lossless WebP visible-pixel mismatch')
fp=set();border=[];unused=[]
for row,num in enumerate(COUNTS):
 for col in range(6):
  tile=reopened.crop((col*96,row*96,(col+1)*96,(row+1)*96))
  arr=np.asarray(tile)
  covered=arr[:,:,3]>51
  if col>=num:
   if covered.any():raise RuntimeError(f'Unused cell not clear {row},{col}')
   unused.append([row,col]);continue
  f=hashlib.sha256(arr.tobytes()).hexdigest()
  if f in fp:raise RuntimeError(f'Duplicate frame {row},{col}')
  fp.add(f)
  if covered[:2].any() or covered[94:].any() or covered[:,:2].any() or covered[:,94:].any():border.append([row,col])
if border:raise RuntimeError(f'Cell borders violated: {border}')
if len(fp)!=25 or len(unused)!=5:raise RuntimeError(f'Cell count mismatch {len(fp)}, {len(unused)}')
DST.parent.mkdir(parents=True,exist_ok=True);DST.write_text(base64.b64encode(RAW_WEBP).decode('ascii')+'\n')
QC.parent.mkdir(parents=True,exist_ok=True)
report.update({'packed_size':list(ATLAS.size),'packed_webp_sha256':hashlib.sha256(RAW_WEBP).hexdigest(),'full_unique':len(fp),'clear_unused':len(unused),'border_contacts':border,'generated_extra_original_source_poses_dropped':2,'manual_photo_matting_limit':'Studio background removal yields imperfect cloak and lantern halo edges; NOT automatically ready for production'})
QC.write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
ATLAS.save(OUT/'d251_guide_25_alpha.png')
# Contact board at game scale x2 with checkerboard for transparency inspection.
board=Image.new('RGB',(1152,960),'#30313b');draw=ImageDraw.Draw(board)
for y in range(0,960,24):
 for x in range(0,1152,24):
  if ((x//24+y//24)%2):draw.rectangle((x,y,x+23,y+23),fill='#252631')
large=ATLAS.resize((1152,960),Image.Resampling.NEAREST)
board.paste(large,(0,0),large)
board.save(OUT/'d251_guide_contact_x2.png')
print(json.dumps({'source_sha':report['source_webp_sha256'],'atlas_sha':report['packed_webp_sha256'],'unique':len(fp),'blank':len(unused),'chars':len(DST.read_text()),'ranges':[(name, min(f['relative_scale'] for f in report['frames'] if f['state']==name), max(f['relative_scale'] for f in report['frames'] if f['state']==name)) for name in NAMES]},indent=2))