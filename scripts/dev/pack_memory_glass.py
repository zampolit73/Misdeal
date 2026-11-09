"""A1V2 deterministic dark-lead watershed. No artwork is repainted.
Seeds are authored on narrative features; watershed follows high-contrast lead.
Every source pixel belongs to exactly one segment; masks are binary, disjoint.
"""
from PIL import Image
from pathlib import Path
import hashlib,heapq,json
ROOT=Path(__file__).resolve().parents[2]/'assets/story/a1v2'
source=ROOT/'approved_vitrazh_memory.png'
assert hashlib.sha256(source.read_bytes()).hexdigest()=='b9bc84cde40956182ad22e049c56f1db034c95d8c6ab02b8ba9c12888a0e1f27'
im=Image.open(source).convert('RGBA');assert im.size==(1122,1402)
# Scene-specific seeds: courtyard, siege, walls, promise, stores, road, seal,
# suppressed witnesses, bridge, oaths, fire; four per portrait/story region.
seeds=[(245,290),(862,251),(310,421),(545,608),(715,1230),(559,280),(626,818),(742,1101),(430,650),(923,1050),(930,1200),(710,458),(199,571),(165,770),(124,1034),(327,927),(927,590),(1034,769),(838,1007),(999,461),(548,1031),(549,1250),(365,1219),(645,1078)]
# Coarse watershed uses luminance barriers; exact final masks use nearest labels.
w,h=281,351
small=im.resize((w,h),Image.Resampling.BOX).convert('L');pixels=list(small.getdata())
cost=[float('inf')]*(w*h); labels=[0]*(w*h);queue=[]
for n,(x,y) in enumerate(seeds,1):
 k=min(h-1,int(y*h/1402))*w+min(w-1,int(x*w/1122));cost[k]=0;labels[k]=n;heapq.heappush(queue,(0,k,n))
while queue:
 d,k,n=heapq.heappop(queue)
 if d!=cost[k]:continue
 x,y=k%w,k//w
 for dx,dy in [(1,0),(-1,0),(0,1),(0,-1)]:
  xx,yy=x+dx,y+dy
  if not(0<=xx<w and 0<=yy<h):continue
  q=yy*w+xx;nd=d+1+max(0,95-pixels[q])*0.25
  if nd<cost[q]:cost[q]=nd;labels[q]=n;heapq.heappush(queue,(nd,q,n))
label=Image.new('L',(w,h));label.putdata(labels);label=label.resize(im.size,Image.Resampling.NEAREST);label.save(ROOT/'regions.png')
for n in range(1,25):
 mask=label.point(lambda v:255 if v==n else 0);assert mask.getbbox()
 out=im.copy();out.putalpha(mask);out.save(ROOT/f'SG{n:02}.png')
(ROOT/'provenance.json').write_text(json.dumps(dict(source_sha256=hashlib.sha256(source.read_bytes()).hexdigest(),size=im.size,seeds=seeds,partition='24 disjoint exhaustive binary masks; no gaps/overlap',algorithm='deterministic luminance-barrier watershed v1'),indent=2))
print('A1V2_PACK_PASS: 24 masks, original untouched')
