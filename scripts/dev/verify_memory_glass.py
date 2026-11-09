from PIL import Image,ImageChops
from pathlib import Path
import hashlib
p=Path('assets/story/a1v2');raw=(p/'approved_vitrazh_memory.png').read_bytes()
assert hashlib.sha256(raw).hexdigest()=='b9bc84cde40956182ad22e049c56f1db034c95d8c6ab02b8ba9c12888a0e1f27'
source=Image.open(p/'approved_vitrazh_memory.png').convert('RGBA');regions=Image.open(p/'regions.png').convert('L')
assert regions.size==source.size==(1122,1402)
assert set(regions.get_flattened_data())==set(range(1,25))
reconstructed=Image.new('RGBA',source.size)
for n in range(1,25):
 fragment=Image.open(p/f'SG{n:02}.png').convert('RGBA');mask=regions.point(lambda x:255 if x==n else 0)
 assert ImageChops.difference(fragment.getchannel('A'),mask).getbbox() is None
 reconstructed.paste(fragment,(0,0),mask)
assert ImageChops.difference(reconstructed,source).getbbox() is None
print('A1V2_MASK_PASS:24 nonempty disjoint complete regions, exact source reconstruction')
