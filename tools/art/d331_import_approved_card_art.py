from pathlib import Path
import os, urllib.request
from io import BytesIO
from PIL import Image

def load(url, label):
    req=urllib.request.Request(url,headers={"User-Agent":"Mozilla/5.0"})
    with urllib.request.urlopen(req,timeout=40) as stream:
        data=stream.read()
    img=Image.open(BytesIO(data)).convert("RGB")
    if img.width<190 or img.height<115:
        raise ValueError(f"{label}: image too small {img.size}")
    print(f"{label}: CDN returned {img.size}, bytes={len(data)}")
    return img

bone=load(os.environ["BONE_URL"],"bone_crush").resize((448,274),Image.Resampling.LANCZOS)
blood=load(os.environ["BLOOD_URL"],"blood_ledger")
# Canva emits an aspect-correct miniature of approved full scene.
# Corresponding y=55..995 crop of 1536x1024 source.
top=round(blood.height * 55/1024)
bottom=round(blood.height * 995/1024)
blood=blood.crop((0,top,blood.width,bottom)).resize((448,274),Image.Resampling.LANCZOS)
root=Path("assets/pixel/card_unification_v1/run")
root.mkdir(parents=True,exist_ok=True)
for name,img in [("bone_crush_d331_approved_option2.webp",bone),("blood_ledger_d331_approved_scribe.webp",blood)]:
    path=root/name
    img.save(path,"WEBP",quality=85,method=6)
    assert Image.open(path).size==(448,274)
    assert path.stat().st_size>3500
    print(path,path.stat().st_size)

catalog=Path("scripts/ui/card_unification_v1.gd")
s=catalog.read_text(encoding="utf-8")
assert '\t"bone_crush":' not in s and '\t"blood_ledger":' not in s
needle='const RUN_CARDS := {\n'
assert needle in s
s=s.replace(needle,needle+
    '\t# D331 user-approved individual card scene compositions.\n'
    '\t"bone_crush": "run/bone_crush_d331_approved_option2.webp",\n'
    '\t"blood_ledger": "run/blood_ledger_d331_approved_scribe.webp",\n',1)
catalog.write_text(s,encoding="utf-8")
