"""Reproducible alpha cleanup and registration of authored relic-polish art.
Usage: python scripts/dev/pack_relic_polish.py <generated image directory>
No new art is drawn here; inputs are the generated project-reference plates/atlases.
"""
from pathlib import Path
import sys
import numpy as np
from PIL import Image
from scipy.ndimage import label

ROOT = Path(__file__).resolve().parents[2]
DST = ROOT / "assets/pixel/travel/cinematic_v5/relic_polish"
PLATES = {
    "debtor_bones": "exec-f9c86475-a301-43df-a689-721e4cef459d.png",
    "wizard_tithe": "exec-32502d5e-5f07-4aa6-9810-6e0b0d5d1771.png",
    "broken_crown": "exec-cf04ea5d-6eb5-4abb-b1f7-639ee92afe14.png",
}
ATLASES = {
    "debtor_bones": ("exec-2f043bc5-9ab6-4614-b896-24807723556b.png",
        [[(0,443),(443,887),(887,1330),(1330,1774)]]*2),
    "wizard_tithe": ("exec-9d2fd4dc-cf3a-4d02-9551-95f0d6632853.png",
        [[(0,443),(443,887),(887,1330),(1330,1774)],
        [(0,443),(443,840),(840,1350),(1350,1774)]]),
    "broken_crown": ("exec-c80e33af-5753-4e84-b6ce-b042f64e41e6.png",
        [[(0,564),(564,1168),(1168,1888),(1888,2172)]]),
}
HEROES = "exec-98eb2c4c-9841-480b-9ad9-c4673483afea.png"
NPC = {
    "debtor_bones": ("exec-7af5b4a7-d9da-4635-9494-899349f2ff11.png", (140,105)),
    "wizard_tithe": ("exec-5d036e63-06a7-410c-bc0d-ffbea8a00abc.png", (200,141)),
}

def clean(img, strongest=False):
    """Remove low-alpha color fringe and isolated generator speckles."""
    img = img.convert("RGBA")
    a = np.array(img)
    raw = a[:,:,3].astype(np.float32)
    alpha = np.clip((raw-55)*255/(246-55),0,255).astype(np.uint8)
    labels, count = label(alpha>35)
    sizes = np.bincount(labels.ravel())
    sizes[0] = 0
    if count:
        if strongest:
            keep = sizes>=max(14, sizes.max()*0.007)
        else:
            keep = sizes>=12
        alpha = np.where(keep[labels],alpha,0).astype(np.uint8)
    a[:,:,3]=alpha
    a[alpha==0]=0
    return Image.fromarray(a)

def fit_to_cell(img, canvas, margin=4):
    im=clean(img)
    bbox=im.getbbox()
    if bbox is None: raise ValueError("empty generated cell")
    im=im.crop(bbox)
    im.thumbnail((canvas-2*margin,canvas-2*margin),Image.Resampling.LANCZOS)
    out=Image.new("RGBA",(canvas,canvas))
    out.alpha_composite(im,((canvas-im.width)//2,(canvas-im.height)//2))
    return out

def pack(folder):
    for id,filename in PLATES.items():
        dest=DST/id
        dest.mkdir(parents=True,exist_ok=True)
        Image.open(folder/filename).convert("RGB").resize((1280,720),Image.Resampling.LANCZOS).save(dest/"plate.webp",quality=90,method=6)
        filename,columns=ATLASES[id]
        src=Image.open(folder/filename)
        rows=len(columns); atlas=Image.new("RGBA",(768,rows*192))
        for y,cols in enumerate(columns):
            for x,(left,right) in enumerate(cols):
                cell=src.crop((left,round(src.height*y/rows),right,round(src.height*(y+1)/rows)))
                atlas.alpha_composite(fit_to_cell(cell,192),(x*192,y*192))
        atlas.save(dest/"props.webp",quality=93,alpha_quality=100,method=6)
        if id in NPC:
            name,size = NPC[id]
            cel = Image.open(folder/name).convert("RGBA").resize(size,Image.Resampling.LANCZOS)
            yy,xx = np.indices((size[1],size[0]))
            edge = np.minimum.reduce([xx, yy, size[0]-1-xx, size[1]-1-yy])
            alpha = np.clip(edge/4.0,0,1)
            alpha = (alpha*alpha*(3-2*alpha)*255).astype(np.uint8)
            cel.putalpha(Image.fromarray(alpha))
            cel.save(dest/"npc_gesture.webp",quality=94,alpha_quality=100,method=6)
    src=Image.open(folder/HEROES)
    atlas=Image.new("RGBA",(864,864))
    for y,height in enumerate([225,222,234]):
        cells=[clean(src.crop((x*418,y*418,(x+1)*418,(y+1)*418)),True) for x in range(3)]
        ref=cells[0].getbbox()
        s=height/(ref[3]-ref[1])
        for x,cell in enumerate(cells):
            bounds=cell.getbbox(); c=cell.crop(bounds)
            # Common per-role projection; align foot midpoint instead of variable
            # extended-hand bbox, and keep upright rather than squash the body.
            alpha=np.array(c.getchannel("A"))
            ys,xs=np.where(alpha[int(c.height*0.89):,:]>150)
            sole_center=(xs.min()+xs.max())/2 if len(xs) else c.width/2
            c=c.resize((round(c.width*s),round(c.height*s)),Image.Resampling.LANCZOS)
            out=Image.new("RGBA",(288,288))
            ox=round(144-sole_center*s)
            oy=270-c.height
            if ox<0 or ox+c.width>288 or oy<0: raise ValueError(f"gesture cell crops: {x},{y},{ox},{c.width},{oy}")
            out.alpha_composite(c,(ox,oy))
            atlas.alpha_composite(out,(x*288,y*288))
    atlas.save(DST/"gesture_heroes.webp",quality=95,alpha_quality=100,method=6)

if __name__=="__main__":
    pack(Path(sys.argv[1]))
