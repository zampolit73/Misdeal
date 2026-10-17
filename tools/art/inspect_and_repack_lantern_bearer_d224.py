# QA-only converter for the exact D224 user-approved original from GitHub.
# Run from a writable directory: python tools/art/inspect_and_repack_lantern_bearer_d224.py
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
import numpy as np, io, json, hashlib, base64, math
ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / 'assets/pixel/units/black_lantern_road_qa/lantern_bearer_d224_approved_original_lossless.webp.b64'
OUT = Path.cwd() / 'd224_bearer_build'
OUT.mkdir(parents=True, exist_ok=True)
COL_COUNTS=[4,6,6,3,6]
YBOUNDS=[0,239,468,690,913,1145]
webp_bytes = base64.b64decode(SOURCE.read_text(encoding='utf-8').strip())
image=Image.open(io.BytesIO(webp_bytes)).convert('RGBA'); original=np.asarray(image)
alpha=np.asarray(image)[:,:,3]
reference_sha=hashlib.sha256(webp_bytes).hexdigest()
cell=96; source_cell=229
out=Image.new('RGBA',(576,480),(0,0,0,0))
report={'source':str(SOURCE),'source_size':list(image.size),'source_webp_sha256':reference_sha,'source_is_valid_godot_atlas':False,'source_blending_warning':'Cell art lies across nominal grid boundaries; at least one cut still crosses 20 source alpha pixels. Repack requires native F6 visual inspection; offline 0-border flags are not proof of zero silhouette loss.','cut_rows':YBOUNDS,'states':['idle','walk','attack','hit','death'],'expected_counts':COL_COUNTS,'cells':[],'cuts_x':{},'scale':0.37,'native_QA':'pending'}
for r,n in enumerate(COL_COUNTS):
    y0,y1=YBOUNDS[r],YBOUNDS[r+1]
    rowmask=(alpha[y0:y1,:]>48)
    occupancy=rowmask.sum(axis=0)
    cuts=[0]
    for b in range(1,6):
        nominal=b*source_cell
        lo=max(cuts[-1]+120,nominal-46)
        hi=min(image.width-100,nominal+45)
        cut=min(range(lo,hi+1),key=lambda x: (int(occupancy[x])*100 + abs(x-nominal)*0.25))
        cuts.append(int(cut))
    cuts.append(image.width)
    report['cuts_x'][str(r)]=cuts
    for c in range(n):
        x0,x1=cuts[c],cuts[c+1]
        src=image.crop((x0,y0,x1,y1))
        bbox=src.getbbox()
        if not bbox: raise RuntimeError(f'Unexpected empty frame {r}:{c}')
        clipped=src.crop(bbox)
        scale=0.37
        target=(round(clipped.width*scale),round(clipped.height*scale))
        if target[0]>90 or target[1]>90:
            scale=min(88/clipped.width,88/clipped.height)
            target=(int(round(clipped.width*scale)),int(round(clipped.height*scale)))
        # Precise nearest-neighbor conversion maintains pixels without blur.
        thumb=clipped.resize(target,Image.Resampling.NEAREST)
        px=int((96-target[0])/2)
        py=92-target[1]
        if px<2 or py<2 or px+target[0]>94 or py+target[1]>94: raise RuntimeError((r,c,target,px,py))
        out.alpha_composite(thumb,(c*96+px,r*96+py))
        report['cells'].append({'state':report['states'][r],'row':r,'col':c,'source_region':[x0,y0,x1,y1],'crop_bbox':[int(x) for x in bbox],'source_crop':list(clipped.size),'target_size':list(target),'offset':[px,py],'seam_loss_unquantified':True})
out.save(OUT/'lantern_bearer_d224_repacked_qa.png',optimize=True)
webp=OUT/'lantern_bearer_d224_repacked_qa.webp'
out.save(webp,format='WEBP',lossless=True,method=6)
(OUT/'lantern_bearer_d224_repacked_qa.webp.b64').write_text(base64.b64encode(webp.read_bytes()).decode('ascii'))
# strict validation matching Godot _inspect
full=np.asarray(out)[:,:,3]
hashes=set(); warnings=[]; filled=0; empties=0
for r in range(5):
 for c in range(6):
  reg=np.asarray(out.crop((c*96,r*96,c*96+96,r*96+96)))
  mask=reg[:,:,3]>51
  fp=hashlib.sha256(reg.tobytes()).hexdigest()
  if c>=COL_COUNTS[r]:
   empties+=1
   if mask.any():warnings.append(f'unused nontransparent {r}:{c}')
   continue
  filled+=1
  if mask.sum()<70:warnings.append(f'undersized frame {r}:{c}')
  if (mask[:2,:].any() or mask[94:,:].any() or mask[:,:2].any() or mask[:,94:].any()):warnings.append(f'border contact {r}:{c}')
  if fp in hashes:warnings.append(f'identical frame {r}:{c}')
  hashes.add(fp)
report.update({'candidate_webp_sha256':hashlib.sha256(webp.read_bytes()).hexdigest(),'source_webp_size':webp.stat().st_size,'filled':filled,'unique':len(hashes),'unused':empties,'warnings':warnings})
(OUT/'d224_art_qc.json').write_text(json.dumps(report,indent=2,ensure_ascii=False))
if warnings: raise RuntimeError(warnings)
# QA contact printout, no claims of full native acceptance
board=Image.new('RGB',(1100,1000),'#11131a')
d=ImageDraw.Draw(board)
for row,state in enumerate(report['states']):
 d.text((20,28+row*195),f'{state.upper()} ({COL_COUNTS[row]} cels)',fill='#e6cfaf')
 for col in range(COL_COUNTS[row]):
  cel=out.crop((col*96,row*96,col*96+96,row*96+96)).resize((144,144),Image.Resampling.NEAREST)
  check=Image.new('RGB',cel.size,'#242833');cb=ImageDraw.Draw(check)
  for dy in range(0,144,18):
   for dx in range(0,144,18):
    if (dx//18+dy//18)%2:cb.rectangle([dx,dy,dx+17,dy+17],fill='#343947')
  check.paste(cel,(0,0),cel)
  x=20+col*175; y=54+row*195
  board.paste(check,(x,y)); d.text((x+62,y+149),str(col+1),fill='#aaa')
board.save(OUT/'D224_approved_sprite_grid_qa.png')
print(json.dumps({k:report[k] for k in ['source_size','source_webp_sha256','candidate_webp_sha256','source_webp_size','filled','unique','unused','warnings','cuts_x']},indent=2))