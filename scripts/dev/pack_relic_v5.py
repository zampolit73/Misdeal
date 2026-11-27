"""Pack registered project-owned V5 relic worksites.
Usage: python scripts/dev/pack_relic_v5.py <generated plate directory>
Plates are independent generated paintings, masks only extract existing art.
"""
from pathlib import Path
import sys
from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "assets/pixel/travel/batch_02"
DST = ROOT / "assets/pixel/travel/cinematic_v5/relic_batch"
SPECS = {
    "debtor_bones": (
        "exec-45947f60-6a6c-4507-a8c8-22c2174e0746.png",
        [(498,410),(524,398),(582,382),(674,377),(686,349),(727,349),(734,391),
         (748,319),(776,286),(806,269),(825,236),(849,221),(875,194),(904,183),(928,190),(949,218),(967,265),(982,313),(1000,368),
         (1018,373),(1018,366),(1060,359),(1126,370),(1140,385),(1142,342),(1151,341),(1151,394),
         (1194,397),(1201,417),(1184,456),(1183,504),(1169,569),(1135,606),(1092,620),(989,608),(869,601),(755,590),(642,562),(545,523),(498,480),(479,444)],
        ["gamble_success","gamble_failure","safe","break"]),
    "wizard_tithe": (
        "exec-9ade9cf9-cd4f-4eeb-bc55-dfb0abfdb1a1.png",
        [(170,463),(204,442),(227,432),(231,389),(290,381),(320,372),(322,334),(332,315),(344,334),(351,371),
         (367,372),(370,267),(365,220),(355,185),(362,157),(374,159),(386,170),(394,156),(405,158),(410,184),(419,188),(439,174),
         (475,159),(494,139),(500,115),(506,91),(524,74),(551,67),(575,78),(591,102),(604,139),(630,153),(654,177),(680,187),(716,198),
         (733,181),(743,169),(753,175),(746,192),(759,186),(778,177),(783,185),(772,207),(750,226),(749,280),(754,361),
         (849,373),(858,331),(874,314),(885,330),(892,372),(928,380),(938,404),(943,467),(971,481),(971,508),(925,536),(845,549),(684,557),(530,568),(361,568),(238,549),(162,528),(147,505)],
        ["gold","blood","refuse"]),
    "broken_crown": (
        "exec-d7f57a11-d187-4646-91b6-336f678d1536.png",
        [(514,417),(572,410),(584,389),(588,365),(602,365),(611,395),(624,417),
         (664,407),(649,369),(647,333),(653,314),(663,338),(686,345),(704,331),(709,299),(720,273),(733,266),(748,286),(761,298),(758,316),(779,336),
         (802,321),(793,298),(789,264),(798,260),(827,269),(850,286),(870,309),(873,322),(898,339),(908,308),(916,295),(935,321),
         (940,317),(940,289),(949,266),(974,247),(1003,243),(1039,245),(1071,262),(1090,283),(1107,320),
         (1125,334),(1156,218),(1150,201),(1158,185),(1182,189),(1208,109),(1223,97),(1235,104),(1236,117),(1203,185),(1219,188),(1243,189),(1240,203),(1211,208),(1185,268),(1160,365),
         (1178,373),(1185,344),(1199,346),(1203,357),(1213,328),(1220,304),(1231,304),(1235,332),(1246,336),(1247,390),(1276,402),(1279,477),(1255,481),(1219,489),(1200,525),(1135,542),(1081,573),(1015,616),(924,641),(820,643),(727,630),(635,622),(557,594),(525,554),(513,503)],
        ["wear","break","melt"]),
}

def pack(plates):
    for name,(filename,polygon,actions) in SPECS.items():
        src = SRC/name/"layers"
        dst = DST/name
        dst.mkdir(parents=True,exist_ok=True)
        plate = Image.open(plates/filename).convert("RGB").resize((1280,720),Image.Resampling.LANCZOS)
        plate.save(dst/"plate.webp",quality=89,method=6)
        base = Image.open(src/"base_1280.png").convert("RGBA")
        for action in ["base",*actions]:
            composite = base.copy()
            if action != "base":
                composite.alpha_composite(Image.open(src/f"{action}_state.png").convert("RGBA"))
            mask = Image.new("L",base.size)
            ImageDraw.Draw(mask).polygon(polygon, fill=255)
            # The reduced wide shot keeps the table, but the removed crown must
            # not retain a wall-shaped ghost above it. Exact state is in insert.
            if name=="broken_crown" and action!="base":
                ImageDraw.Draw(mask).polygon([(631,255),(937,255),(937,360),(919,382),(882,383),(845,375),(811,391),(771,390),(733,411),(680,415),(631,401)],fill=0)
            mask = mask.filter(ImageFilter.GaussianBlur(2.2))
            composite.putalpha(mask)
            composite.resize((640,360),Image.Resampling.LANCZOS).save(dst/f"worksite_{action}.webp",quality=92,alpha_quality=100,method=6)

if __name__ == "__main__":
    pack(Path(sys.argv[1]))
