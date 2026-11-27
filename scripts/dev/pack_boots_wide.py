"""Pack the pulled-back Boots establishing plate and source-registered worksite.
Usage: python scripts/dev/pack_boots_wide.py generated_wide_plate.png
Only offline authoring requires Pillow, numpy and scipy.
"""
import sys
from pathlib import Path
import numpy as np
from PIL import Image, ImageDraw
from scipy.ndimage import distance_transform_edt

ROOT = Path(__file__).resolve().parents[2]
SOURCE = ROOT / "assets/pixel/travel/campfire_without_master"
SQUIRE = ROOT / "assets/pixel/travel/cinematic_v5/squire"
OUT = ROOT / "assets/pixel/travel/cinematic_v5/boots_wide"
OUT.mkdir(parents=True, exist_ok=True)
# Source-space polygons: original squire, contiguous seat/gear, boot table and
# tripod/fire. A broad ground-only feather integrates the different soil.
SIZE = (1307, 941)
POSE_RECT = (230, 145, 700, 660)
def mask(polys, radius):
    m = Image.new("L", SIZE)
    d = ImageDraw.Draw(m)
    for p in polys:
        d.polygon(p, fill=255)
    dist = distance_transform_edt(np.asarray(m) > 0)
    w = np.minimum(dist / radius, 1)
    return w * w * (3 - 2 * w)

squire = [(231,529),(245,480),(250,433),(249,408),(272,363),(302,319),(339,280),
          (376,250),(420,232),(441,242),(447,210),(457,181),(481,163),(508,148),
          (550,148),(580,173),(599,203),(609,245),(585,274),(594,303),(622,334),
          (636,364),(643,402),(644,426),(680,425),(714,442),(734,473),(751,509),
          (744,545),(765,579),(764,610),(782,656),(806,688),(839,711),(851,745),
          (828,767),(746,768),(704,756),(714,779),(678,794),(583,792),(526,780),
          (492,751),(473,713),(451,675),(424,640),(411,624),(397,590),(360,555),
          (311,535),(259,540)]
seat = [(1,440),(48,443),(66,315),(91,299),(207,306),(245,333),(243,373),(270,410),
        (295,451),(339,490),(411,520),(457,539),(464,617),(447,654),(435,692),
        (506,713),(539,758),(566,801),(534,855),(359,911),(1,931)]
shield_and_helm = [(0,537),(47,518),(90,512),(169,527),(246,535),(286,555),(311,614),
                   (318,696),(345,674),(389,675),(430,694),(456,738),(470,776),
                   (520,779),(609,816),(665,895),(631,938),(0,940)]
rack = [(681,240),(688,227),(742,227),(741,203),(755,165),(780,165),(789,203),
        (791,224),(830,228),(854,253),(839,279),(840,328),(862,356),(854,423),
        (850,446),(890,432),(933,433),(965,447),(984,486),(1003,532),(1003,561),
        (956,571),(931,671),(869,704),(829,684),(817,590),(760,582),(734,556),
        (723,446),(726,319),(715,266),(684,267)]
fire = [(907,555),(925,535),(944,554),(962,616),(989,641),(1014,707),(1049,797),
        (1120,800),(1164,837),(1150,918),(1060,941),(704,940),(628,898),(625,856),
        (669,806),(751,773),(813,787),(871,771),(891,699)]
ground = [(0,590),(171,640),(302,701),(568,722),(753,727),(953,738),
          (1097,773),(1200,824),(1170,940),(0,940)]
w = np.maximum.reduce([mask([squire,seat,shield_and_helm,rack,fire],9), mask([ground],60)])
# Fade the originally cropped extreme left bench, and all ground at the bottom.
yy,xx=np.mgrid[:SIZE[1],:SIZE[0]]
w *= np.minimum(np.minimum(xx, SIZE[0]-1-xx)/18,1).clip(0,1)
w *= np.minimum((SIZE[1]-1-yy)/22,1).clip(0,1)
mask_img = Image.fromarray((w * 255).round().astype("uint8"))
# Keep the actual original outcome art. Use original foreground overlay where
# it exists, as it included the shield/helmet nearest the old camera.
fg = Image.open(SOURCE / "foreground.png").convert("RGBA")
def save_rgba(im, name):
    # The new runtime scale is 0.21 of source. Half-source art is still >2x
    # projected detail; avoid redundant megabytes of invisible RGB.
    im = im.resize((round(im.width/2),round(im.height/2)),Image.Resampling.LANCZOS)
    arr=np.asarray(im).copy()
    arr[arr[:,:,3]==0,:3]=0
    Image.fromarray(arr).save(OUT / (name+".webp"),lossless=True,method=6)

for name in ("passed","repair","hobnails"):
    im=Image.open(SOURCE/("camp_"+name+".png")).convert("RGBA")
    im.alpha_composite(fg,(0,586))
    a=np.asarray(im.getchannel("A")).astype(float)*w
    im.putalpha(Image.fromarray(a.round().astype("uint8")))
    # Clip to an even source width; masked area is well within 1280.
    save_rgba(im.crop((0,0,1280,940)),"camp_"+name)
# Original four finished animation poses clipped to same source silhouette.
# The alpha mask contains enough contour padding for the glance and hands.
for name in ("pull","thread","glance","press"):
    im=Image.open(SQUIRE/(name+".webp")).convert("RGBA")
    a=np.asarray(im.getchannel("A")).astype(float)*np.asarray(mask_img.crop(POSE_RECT))/255
    im.putalpha(Image.fromarray(a.round().astype("uint8")))
    save_rgba(im,name)

plate=Image.open(sys.argv[1]).convert("RGB").resize((1280,720),Image.Resampling.LANCZOS)
plate.save(OUT/"plate.webp",quality=93,method=6)
