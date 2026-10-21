from pathlib import Path
import os, urllib.request
from io import BytesIO
from PIL import Image

def load(url, w, h, label):
    req = urllib.request.Request(url,headers={"User-Agent":"Mozilla/5.0"})
    with urllib.request.urlopen(req,timeout=40) as stream:
        data=stream.read()
    img=Image.open(BytesIO(data)).convert("RGB")
    print(label,img.size,len(data))
    if img.width < w or img.height < h:
        raise ValueError(f"{label}: CDN returned thumbnail not original {img.size}")
    return img

bone=load(os.environ["BONE_URL"],448,274,"bone_crush")
blood=load(os.environ["BLOOD_URL"],1536,1024,"blood_ledger")
blood=blood.crop((0,55,1536,995)).resize((448,274),Image.Resampling.LANCZOS)
root=Path("assets/pixel/card_unification_v1/run")
root.mkdir(parents=True,exist_ok=True)
for name,img in [("bone_crush_d331_approved_option2.webp",bone),("blood_ledger_d331_approved_scribe.webp",blood)]:
    path=root/name
    img.save(path,"WEBP",quality=75,method=6)
    assert Image.open(path).size==(448,274)
    assert path.stat().st_size>7000
    print(path,path.stat().st_size)

p=Path("scripts/ui/card_unification_v1.gd")
s=p.read_text(encoding="utf-8")
assert '\t"bone_crush":' not in s and '\t"blood_ledger":' not in s
needle='const RUN_CARDS := {\n'
assert needle in s
s=s.replace(needle,needle+
    '\t# D331 user-approved individual card scenes.\n'
    '\t"bone_crush": "run/bone_crush_d331_approved_option2.webp",\n'
    '\t"blood_ledger": "run/blood_ledger_d331_approved_scribe.webp",\n',1)
p.write_text(s,encoding="utf-8")
