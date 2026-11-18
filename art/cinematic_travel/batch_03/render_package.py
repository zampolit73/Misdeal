"""Render Misdeal Batch 03 review plates and validate the delivery archive."""
from __future__ import annotations

from base64 import b64decode
from hashlib import sha256
from io import BytesIO
import json
from struct import pack
from pathlib import Path
import sys
from zipfile import ZipFile, ZipInfo, ZIP_DEFLATED

from PIL import Image, ImageChops, ImageCms, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent
REPO = ROOT.parents[2]
DATA = json.loads((ROOT / "staging.json").read_text(encoding="utf-8"))
CANVAS = (1280, 720)
PROFILE = bytearray(ImageCms.ImageCmsProfile(ImageCms.createProfile("sRGB")).tobytes())
PROFILE[24:36] = pack(">6H",2026,11,18,0,0,0)
PROFILE = bytes(PROFILE)
SPRITES = {}
CUTS = {}
RESAMPLE = Image.Resampling.LANCZOS

def write_json(path, value):
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

def save(image, path, **options):
    path.parent.mkdir(parents=True, exist_ok=True)
    image.save(path, icc_profile=PROFILE, **options)

def key_sprite(sheet, box):
    result = sheet.crop(box).convert("RGBA")
    keyed = []
    for r, g, b, a in result.getdata():
        edge = g - max(r, b)
        if g > 150 and edge > 76:
            keyed.append((0, 0, 0, 0))
        elif g > 108 and edge > 34:
            keyed.append((r, min(g, max(r, b) + 12), b, max(95, 255 - 3 * (edge - 34))))
        else:
            keyed.append((r, g, b, a))
    result.putdata(keyed)
    bounds = result.getbbox()
    assert bounds is not None, box
    return result.crop(bounds)

def sprites():
    special = ((47,72,576,625), (663,72,978,625), (1045,220,1652,548), (1692,235,2145,540))
    for index, names in enumerate(DATA["spriteSheets"], 1):
        with Image.open(ROOT / f"source/props{index:02}.png") as sheet:
            w, h = sheet.width // 4, sheet.height // 2
            for i, name in enumerate(names.split()):
                box = special[i] if index == 7 else (i%4*w, i//4*h, (i%4+1)*w, (i//4+1)*h)
                sprite = key_sprite(sheet, box)
                SPRITES[name] = sprite
                # Raw sources remain available for future re-keying.
                if name not in {"alcove", "passage", "velvet"}:
                    preview = sprite.copy()
                    preview.thumbnail((364, 364), RESAMPLE)
                    save(preview, ROOT / f"shared_sprites/{name}.png")

def grade(image, tone):
    if tone == 1:
        return image
    return image.point([round(v*tone) for v in range(256)]*3 + list(range(256)))

def stamp(target, item):
    name, x, y, width, height, *options = item.split(",")
    x, y, width, height = map(int, (x,y,width,height))
    tone = float(options[0]) if options else 1.0
    image = grade(SPRITES[name].resize((width, height), RESAMPLE), tone)
    if len(options) < 2:
        sw, sh = max(2, int(width*.84)), max(4, int(height*.17))
        ellipse = Image.new("RGBA", (sw, sh))
        shadow = ImageDraw.Draw(ellipse)
        for depth in range(5):
            inset = depth*.04
            shadow.ellipse((sw*inset, sh*inset, sw*(1-inset)-1, sh*(1-inset)-1), fill=(12,8,10,18+depth*14))
        target.alpha_composite(ellipse, (x-sw//2,y-sh//2))
    target.alpha_composite(image, (x-width//2,y-height))

def poly_patch(target, image, box, vertices, tone=1):
    x0,y0,x1,y1 = box
    image = grade(image.resize((x1-x0,y1-y0), RESAMPLE), tone)
    mask = Image.new("L", image.size, 0)
    ImageDraw.Draw(mask).polygon([(x-x0,y-y0) for x,y in vertices], fill=255)
    image.putalpha(ImageChops.multiply(image.getchannel("A"),mask))
    target.alpha_composite(image, (x0,y0))

def occluder(target, base, key):
    if key == "prison_bars":
        for x in (799,859,923):
            target.alpha_composite(base.crop((x-7,355,x+10,555)), (x-7,355))
    elif key == "well_rim":
        scene = next(s for s in DATA["scenes"] if s["id"] == "whispering_well")
        poly_patch(target,base,(0,0,1280,720),scene["occlusion"])
    elif key == "prison_open":
        poly_patch(target, SPRITES["alcove"], (526,37,1106,582),
            [(526,545),(528,181),(559,153),(674,105),(821,63),(990,39),(1100,55),(1101,577),(915,574),(744,565)], .91)
        poly_patch(target,base.crop((948,74,1138,591)),(1076,83,1139,589),
            [(1078,107),(1137,83),(1135,584),(1080,575)],.86)
    elif key == "face_clean":
        tile = SPRITES["velvet"]
        poly_patch(target,tile,(668,328,932,406),
            [(669,392),(767,329),(926,329),(929,340),(858,401),(685,404)],.62)
    elif key == "crypt_open":
        poly_patch(target,SPRITES["passage"],(822,63,1062,581),
            [(822,577),(828,162),(848,126),(885,90),(938,65),(984,92),(1021,125),(1047,166),(1057,579)],.96)
        poly_patch(target,base.crop((767,106,932,580)),(813,120,877,583),
            [(814,173),(874,127),(874,571),(819,580)],.75)
        poly_patch(target,base.crop((945,112,1117,580)),(1004,121,1062,584),
            [(1006,127),(1053,158),(1058,579),(1009,569)],.72)
    else:
        raise ValueError(key)

def layer(base, items):
    im = Image.new("RGBA", CANVAS, (0,0,0,0))
    for item in items:
        if item.startswith("@"):
            occluder(im, base, item[1:])
        else:
            stamp(im,item)
    return im

def board(cells, path, columns=3, width=416, height=234):
    nrows = (len(cells) + columns - 1) // columns
    grid = Image.new("RGB", ((width+4)*columns,(height+32)*nrows), (22,18,24))
    draw = ImageDraw.Draw(grid)
    font = ImageFont.truetype("DejaVuSans.ttf", 15)
    for i, (file,label) in enumerate(cells):
        x = i%columns * (width+4)
        y = i//columns * (height+32)
        with Image.open(file) as image:
            grid.paste(image.convert("RGB").resize((width,height),RESAMPLE), (x,y))
        draw.text((x+7,y+height+7),label,font=font,fill=(241,224,207))
    save(grid,path,quality=91)

def generate(scene):
    key = scene["id"]
    folder = ROOT / scene["folder"]
    with Image.open(ROOT / f"source/{key}.png") as source:
        im = source.crop(scene["crop"]) if "crop" in scene else source
        assert im.width >= 1280 and im.height >= 720, im.size
        base = im.convert("RGBA").resize(CANVAS,RESAMPLE)
    master = folder / "master/scene.webp"
    save(base.convert("RGB"),master,lossless=True,method=6)
    with Image.open(master) as test:
        assert test.size == CANVAS and test.tobytes() == base.convert("RGB").tobytes()
    front = Image.new("RGBA", CANVAS)
    poly_patch(front,base,(0,0,1280,720),scene["foreground"])
    assert front.getchannel("A").getextrema() == (0,255)
    save(front,folder/"layers/foreground.png",optimize=True)
    scene["master"] = "master/scene.webp"
    scene["planes"] = {"architecture": "master/scene.webp", "foreground": "layers/foreground.png"}
    if scene.get("occlusion"):
        hold = layer(base,["@well_rim"])
        save(hold,folder/"layers/handoff_occlusion.png",optimize=True)
        scene["planes"]["handoff_occlusion"] = "layers/handoff_occlusion.png"
    scene["phase_assets"] = {}
    for phase in ("entry","treatment","sink"):
        if phase in scene["paint"]:
            path = f"layers/{phase}.png"
            save(layer(base,scene["paint"][phase]),folder/path,optimize=True)
            scene["phase_assets"][phase] = path
    proof = []
    digests = set()
    for item in scene["states"]:
        action = item["action"]
        items = scene["paint"][action]
        composite = base.copy()
        final = None
        if items:
            state_image = layer(base,items)
            assert state_image.getchannel("A").getextrema() == (0,255), (key, action)
            final = f"outcomes/{action}.png"
            save(state_image,folder/final,optimize=True)
            composite.alpha_composite(state_image)
        digest = sha256(composite.tobytes()).hexdigest()
        assert digest not in digests,(key,action,"duplicate output")
        digests.add(digest)
        item["overlay"] = final
        item["preview"] = f"preview/{action}.jpg"
        save(composite.convert("RGB"),folder/item["preview"],quality=92,subsampling=0)
        proof.append((folder/item["preview"],action))
    board(proof,folder/"preview/compare.jpg")
    state_count = len(scene["states"])
    assert state_count == len(digests)
    write_json(folder/"manifest.json", {k:v for k,v in scene.items() if k != "paint"})
    return master

def actors():
    reference = REPO / "assets/pixel"
    frames = json.loads((reference / "travel/batch_02/soles.json").read_text(encoding="utf-8"))
    for role in ("knight","ranger","mage","jack"):
        if role != "jack":
            path = reference / f"units/hero_c3_d412_polish/{role}.webp.b64"
        else:
            path = reference / "units/jack/atlas.webp.b64"
        data = b64decode(path.read_bytes())
        side = Image.open(BytesIO(data)).convert("RGBA").crop((0,96,576,192))
        rear = None if role == "jack" else Image.open(
            reference / f"travel/campfire_without_master/rear_walk/{role}.png").convert("RGBA")
        for facing, image in (("side",side),("ne",rear)):
            if image is None:
                continue
            boxes = [image.crop((f*96,0,(f+1)*96,96)).getbbox() for f in range(6)]
            assert image.size == (576,96) and all(box is not None for box in boxes)
            height = max(y1-y0 for x0,y0,x1,y1 in boxes)
            sola = frames[facing].get(role, [box[3]-1 for box in boxes])
            frames[facing][role] = {"height":height, "soles":sola}
            save(image,ROOT/f"preview_actors/{facing}_{role}.png",optimize=True)
    write_json(ROOT/"preview_actors/frames.json",frames)
    return frames

def inventory():
    files = {}
    for path in sorted(ROOT.rglob("*")):
        if not path.is_file() or path.name == "ASSET_MANIFEST.json" or "__pycache__" in path.parts:
            continue
        rel = path.relative_to(ROOT).as_posix()
        payload = path.read_bytes()
        record = {"size":len(payload),"sha256":sha256(payload).hexdigest()}
        if path.suffix.lower() in (".png",".webp",".jpg"):
            with Image.open(path) as image:
                image.load()
                record.update(width=image.width,height=image.height,mode=image.mode)
        files[rel] = record
    write_json(ROOT/"ASSET_MANIFEST.json", {"source_sha":DATA["reference"], "files":files})
    return files

def main():
    sprites()
    frames = actors()
    masters = [(generate(scene),scene["title"]) for scene in DATA["scenes"]]
    board(masters,ROOT/"MISDEAL_BATCH_03_CONTACT.jpg",columns=2,width=630,height=354)
    metadata = json.dumps({"scenes":DATA["scenes"],"frames":frames},ensure_ascii=False).replace("</","<\\/")
    template = (ROOT/"production/gallery_template.html").read_text(encoding="utf-8")
    (ROOT/"MISDEAL_BATCH_03_GALLERY.html").write_text(template.replace("__DATA__",metadata),encoding="utf-8")
    files = inventory()
    output = Path(sys.argv[1] if len(sys.argv) > 1 else "MISDEAL_CINEMATIC_TRAVEL_BATCH_03.zip")
    output.parent.mkdir(parents=True,exist_ok=True)
    with ZipFile(output,"w",compression=ZIP_DEFLATED,compresslevel=6) as archive:
        for path in [*files,"ASSET_MANIFEST.json"]:
            item = ZipInfo("batch_03/"+path,date_time=(2026,11,18,0,0,0))
            archive.writestr(item,(ROOT/path).read_bytes(),compress_type=ZIP_DEFLATED,compresslevel=6)
    with ZipFile(output) as archive:
        assert archive.testzip() is None
        for name, meta in files.items():
            assert sha256(archive.read("batch_03/"+name)).hexdigest() == meta["sha256"], name
    print(f"{len(masters)} scenes, {sum(len(s['states']) for s in DATA['scenes'])} states, {len(files)} checked files")
    print(f"{output.name} {output.stat().st_size} bytes sha256 {sha256(output.read_bytes()).hexdigest()}")

if __name__ == "__main__":
    main()
