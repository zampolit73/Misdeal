from io import BytesIO
from pathlib import Path
import os
import urllib.request
from PIL import Image

# D333 hand-picked artwork is captured in Canva as an uploaded user-approved
# reference. This transport uses its authorized signed preview (199/200px).
# DO NOT treat this as full-resolution master; upgrade from approved chat
# original later without changing art direction.
with urllib.request.urlopen(urllib.request.Request(
        os.environ["APPROVED_PREVIEW"], headers={"User-Agent": "Mozilla/5.0"}
    ), timeout=45) as response:
    payload = response.read()
image = Image.open(BytesIO(payload)).convert("RGB")
print("D333 approved original preview:", image.size, len(payload))
if image.width < 190 or image.height < 115:
    raise RuntimeError("D333 approved scene could not be fetched at usable preview dimensions")
image = image.resize((448, 274), Image.Resampling.LANCZOS)
output = Path("assets/pixel/card_unification_v1/run/bone_patrol_d333_approved_tower.webp")
output.parent.mkdir(parents=True, exist_ok=True)
image.save(output, "WEBP", quality=88, method=6)
assert Image.open(output).size == (448, 274)
assert output.stat().st_size > 3500
print("D333 card art written:", output, output.stat().st_size)

p = Path("scripts/ui/card_unification_v1.gd")
src = p.read_text(encoding="utf-8")
old = '"bone_patrol": "run/bone_patrol.webp",'
new = '"bone_patrol": "run/bone_patrol_d333_approved_tower.webp",'
assert src.count(old) == 1, "original map changed; stop before overwriting"
p.write_text(src.replace(old, new, 1), encoding="utf-8")
