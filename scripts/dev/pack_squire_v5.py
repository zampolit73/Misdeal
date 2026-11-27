from PIL import Image, ImageDraw
import numpy as np
from scipy.ndimage import map_coordinates, distance_transform_edt
from pathlib import Path
import sys
# Offline authoring helper. Usage: python scripts/dev/pack_squire_v5.py GENERATED_SHEET.png
# Requires Pillow, numpy and scipy only when repacking, never in Godot runtime.
ROOT=Path(__file__).resolve().parents[2]
sheet=Image.open(sys.argv[1]).convert('RGB')
ref=Image.open(ROOT/'assets/pixel/travel/campfire_without_master/approved_reference.png').convert('RGB').crop((230,145,700,660))
output=ROOT/'assets/pixel/travel/cinematic_v5/squire'
output.mkdir(parents=True,exist_ok=True)
W,H=ref.size
Y,X=np.mgrid[:H,:W]
# Exact source face and insignia retained in all work cels. The masks cover
# both old and new wrist/hand positions; all boundaries lie in cloth/boot.
work_poly=[(76,213),(176,212),(197,251),(204,292),(239,327),(263,346),(329,344),(339,288),(333,222),(360,194),(412,201),(437,244),(435,304),(422,359),(406,413),(409,451),(399,478),(384,494),(254,492),(231,479),(208,474),(184,455),(160,424),(123,408),(79,390),(47,357),(44,304),(54,252)]
# Pull retains cloak fabric and original skeleton upper arm where possible.
# A broad feather at the wrist/boot edges prevents hard local rectangles.
def feather(polys,radius):
 m=Image.new('L',(W,H));d=ImageDraw.Draw(m)
 for p in polys:d.polygon(p,fill=255)
 a=np.array(m)>0
 dist=distance_transform_edt(a)
 w=np.minimum(dist/radius,1.0)
 w=w*w*(3-2*w)
 return w
glance_poly=[(178,2),(355,2),(389,28),(408,78),(388,149),(347,204),(310,222),(239,214),(204,198),(196,159),(172,131),(172,78)]
for i,name in enumerate(['pull','thread','glance','press']):
 # The artifact has tightly matched four crops; correct grid ratio exactly.
 x0,x1=i%2*sheet.width//2,(i%2+1)*sheet.width//2
 y0,y1=i//2*sheet.height//2,(i//2+1)*sheet.height//2
 q=np.array(sheet.crop((x0,y0,x1,y1)).resize((W,H),Image.Resampling.LANCZOS),dtype=float)
 # Align working hand position against original buckle and reduce motion of
 # the fixed boot/knee. Local vertical registration fades out at the crop edges.
 # No transformed face in the glance, no transformed backdrop.
 mapping=np.interp(Y,[0,150,215,260,330,350,410,455,490,515],[0,150,210,243,302,318,383,432,480,515])
 # use distortion only in authored work region and avoid pulling fixed head.
 if name=='glance':
  mapping=np.where(Y<205,Y,mapping)
 # press hand extends down; less upward difference than pull.
 if name=='press':
  mapping=Y+(mapping-Y)*0.60
 rgb=np.stack([map_coordinates(q[:,:,c],[mapping,X],order=3,mode='nearest') for c in range(3)],axis=2)
 rgb=np.clip(rgb,0,255).astype('uint8')
 # Register the original twin-bone shaft to each moving skeletal hand.
 # Retain the source bone anatomy rather than the generated single shaft.
 top_x,top_y, wrist_x,wrist_y={'pull':(369,237,390,326),'thread':(368,232,390,304),'glance':(368,235,390,313),'press':(369,230,390,309)}[name]
 f=(Y-top_y)/(wrist_y-top_y)
 src_y=250+f*95
 src_x=X-(top_x-380+(wrist_x-376-(top_x-380))*f.clip(0,1))
 shaft_mask=feather([[(346,220),(397,218),(414,245),(417,270),(411,302),(404,334),(396,352),(364,352),(347,334),(344,294),(337,259),(336,237)]],7)
 shaft_weight=map_coordinates(shaft_mask,[src_y,src_x],order=1,mode='constant',cval=0)
 shaft_rgb=np.stack([map_coordinates(np.asarray(ref)[:,:,c].astype(float),[src_y,src_x],order=3,mode='nearest') for c in range(3)],axis=2)
 rgb=(rgb*(1-shaft_weight[...,None])+shaft_rgb*shaft_weight[...,None]).clip(0,255).astype('uint8')
 w=feather([work_poly],16)
 if name=='glance':w=np.maximum(w,feather([glance_poly],13))
 # Ensure alpha never touches the crop boundary, which is completely outside the motion.
 w*=np.minimum(np.minimum(X,W-1-X),np.minimum(Y,H-1-Y)).clip(0,12)/12
 a=(w*255).round().astype('uint8')
 # Keep the fixed left background and crop's original facial pixels outside mask.
 patch=Image.fromarray(np.dstack([rgb,a]),'RGBA')
 data=np.array(patch)
 data[data[:,:,3]==0,:3]=0
 Image.fromarray(data).save(output/(name+'.webp'),lossless=True,method=6)
