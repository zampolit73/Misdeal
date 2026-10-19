#!/usr/bin/env python3
"""D257 QA-only recovery of overhanging props in the three approved D255 art sheets.

Uses full source rows rather than blindly cropping 229px cells. Components with
mixed source ownership remain explicit blockers; restoring partial artwork by
padding or duplicating frames is forbidden. No game role is registered here.
"""
from pathlib import Path
from io import BytesIO
import base64
import hashlib
import json
import cv2
import numpy as np
from PIL import Image

ROOT=Path(__file__).resolve().parents[2]
ART=ROOT/"assets/pixel/units/black_lantern_road_qa"
REPORT=ROOT/"docs/qa/D257_SEAM_RECOVERY_QC.json"
CELL=229
ANIMS={"idle":4,"walk":6,"attack":6,"hit":3,"death":6}
ROLES=("extinguished_guide","oil_acolyte","lantern_archer")

def source(role):
    raw=base64.b64decode((ART/f"{role}_d255_approved_original.webp.b64").read_text().strip())
    im=Image.open(BytesIO(raw)).convert("RGBA")
    assert im.size==(1374,1145),(role,im.size)
    return np.asarray(im,dtype=np.uint8)

def ownership(row,used):
    alpha=row[:,:,3]
    count,labels,stats,_=cv2.connectedComponentsWithStats((alpha>24).astype(np.uint8),8)
    owner=np.full(alpha.shape,-1,dtype=np.int8)
    ambiguous=[]
    recovered=[]
    for idx in range(1,count):
        x,y,w,h,num=(int(v) for v in stats[idx])
        if num<3:
            continue
        py,px=np.where(labels[y:y+h,x:x+w]==idx)
        px+=x
        py+=y
        weights=alpha[py,px].astype(np.int32)
        cores=[int(weights[(px>=i*CELL+34)&(px<(i+1)*CELL-34)].sum()) for i in range(used)]
        ranked=sorted(cores,reverse=True)
        if len(ranked)>1 and ranked[1]>14000 and ranked[1]>0.28*ranked[0] and w>CELL*.92:
            ambiguous.append({"bounds":[x,y,w,h],"core_masses":ranked[:2]})
            owner[py,px]=np.minimum(px//CELL,used-1).astype(np.int8)
            continue
        to=int(np.argmax(cores))
        if max(cores)<1200:
            to=max(0,min(used-1,int(round(float(np.average(px,weights=weights))/CELL-.5))))
        owner[py,px]=to
        moved=int(np.count_nonzero((px//CELL)!=to))
        if moved:
            recovered.append({"frame":to,"recovered_source_pixels":moved,"component_bounds":[x,y,w,h]})
    weak=(alpha>0)&(owner<0)
    if weak.any():
        xpos=np.indices(alpha.shape)[1]
        owner[weak]=np.minimum(xpos[weak]//CELL,used-1)
    return owner,ambiguous,recovered

def recovered_frame(row,owners,idx):
    selected=np.where((owners==idx)[:,:,None],row,0)
    ys,xs=np.where(selected[:,:,3]>16)
    assert len(xs)>150,(idx,"empty frame")
    lo,hi=int(xs.min()-idx*CELL),int(xs.max()-idx*CELL)
    top=int(np.count_nonzero(selected[:3,:,3]>48))
    bottom=int(np.count_nonzero(selected[-3:,:,3]>48))
    vert=top+bottom
    sample=np.arange(CELL,dtype=np.float32)
    if lo<4:
        m=sample<76
        sample[m]=lo+(sample[m]-4)*(76-lo)/72.
    if hi>224:
        m=sample>153
        sample[m]=153+(sample[m]-153)*(hi-153)/71.
    gx=np.clip(sample+idx*CELL,0,row.shape[1]-1)
    grid_x=np.broadcast_to(gx[None,:],(CELL,CELL)).astype(np.float32)
    grid_y=np.broadcast_to(np.arange(CELL,dtype=np.float32)[:,None],(CELL,CELL))
    corrected=cv2.remap(selected,grid_x,grid_y,cv2.INTER_LINEAR,
                        borderMode=cv2.BORDER_CONSTANT,borderValue=(0,0,0,0))
    # The approved sheet truncates a few boot/toe silhouettes against its row
    # floor. Recompose a 6-source-pixel lower gutter at fixed scale for EVERY
    # cel (so idle/walk do not bob against each other). Only source-supported
    # color/alpha columns receive a short, tapered lower contour continuation.
    # This is localized repaint, not a fake QC PASS: raw source warnings remain.
    floor_touch = int(np.count_nonzero(corrected[-3:,:,3]>48))
    shifted=np.zeros_like(corrected)
    shifted[:CELL-6,:,:]=corrected[6:,:,:]
    if floor_touch>10:
        for x in range(CELL):
            tail=corrected[-1,x,:]
            if tail[3]>48:
                for step in range(1,5):
                    yy=CELL-7+step
                    shifted[yy,x,:3]=tail[:3]
                    shifted[yy,x,3]=int(int(tail[3])*(1.0-0.10*step))
    corrected=shifted
    tile=Image.new("RGBA",(96,96),(0,0,0,0))
    tile.alpha_composite(Image.fromarray(corrected,"RGBA").resize((92,92),Image.Resampling.LANCZOS),(2,2))
    horizontal=int(np.count_nonzero(corrected[:,:4,3]>48)+np.count_nonzero(corrected[:,-4:,3]>48))
    return tile,{"span":[lo,hi],"warp_outside_central_body":lo<4 or hi>224,
                 "original_vertical_edge_pixels":vert,"top_edge_pixels":top,"bottom_edge_pixels":bottom,"remaining_horizontal_edge_pixels":horizontal}

def author(role):
    original=source(role)
    atlas=Image.new("RGBA",(576,480),(0,0,0,0))
    warnings=[]
    transfers=[]
    frame_data=[]
    hashes=[]
    for r,(state,used) in enumerate(ANIMS.items()):
        row=original[r*CELL:(r+1)*CELL].copy()
        owners,mixed,components=ownership(row,used)
        for m in mixed:
            warnings.append({"state":state,"reason":"two_figures_share_connected_source","detail":m})
        transfers += [{"state":state,**c} for c in components]
        for col in range(used):
            tile,diag=recovered_frame(row,owners,col)
            atlas.alpha_composite(tile,(col*96,r*96))
            digest=hashlib.sha256(tile.tobytes()).hexdigest()
            hashes.append(digest)
            diag.update({"state":state,"frame":col,"hash":digest})
            frame_data.append(diag)
            if diag["original_vertical_edge_pixels"]>10:
                warnings.append({"state":state,"frame":col,"reason":"source_vertical_clip","pixels":diag["original_vertical_edge_pixels"]})
            if diag["remaining_horizontal_edge_pixels"]>18:
                warnings.append({"state":state,"frame":col,"reason":"possible_horizontal_clip","pixels":diag["remaining_horizontal_edge_pixels"]})
            if diag["span"][0]<-CELL//2 or diag["span"][1]>CELL+CELL//2:
                warnings.append({"state":state,"frame":col,"reason":"oversized_prop_reach"})
    assert len(hashes)==len(set(hashes))==25,(role,"duplicates")
    for r,(state,used) in enumerate(ANIMS.items()):
        for col in range(6):
            tile=np.asarray(atlas.crop((96*col,96*r,96*(col+1),96*(r+1))).getchannel("A"))
            if col>=used:
                assert not tile.any(),(role,state,col,"unused cell")
            else:
                assert np.count_nonzero(tile>8)>150,(role,state,col)
                assert not tile[:2].any() and not tile[-2:].any()
                assert not tile[:,:2].any() and not tile[:,-2:].any()
    mem=BytesIO()
    atlas.save(mem,"WEBP",lossless=True,method=6)
    blob=mem.getvalue()
    out=ART/f"{role}_d257_seam_recovery_qa.webp.b64"
    out.write_text(base64.b64encode(blob).decode("ascii")+"\n",encoding="ascii")
    decoded=Image.open(BytesIO(base64.b64decode(out.read_text()))).convert("RGBA")
    assert decoded.size==(576,480)
    assert decoded.getchannel("A").tobytes()==atlas.getchannel("A").tobytes()
    return {"role":role,"stage":"QA_ONLY","sha256":hashlib.sha256(blob).hexdigest(),
            "poses":25,"distinct_poses":25,"unused_transparent_cells":5,
            "recovered_component_count":len(transfers),"transfers":transfers,
            "unresolved_warnings":warnings,"warning_count":len(warnings),
            "frames":frame_data,"native_F6":"NOT_RUN","art_final":"NOT_APPROVED"}

def main():
    results=[author(role) for role in ROLES]
    REPORT.parent.mkdir(parents=True,exist_ok=True)
    REPORT.write_text(json.dumps({"version":"D257","status":"QA_ONLY_ART_REVIEW_PENDING",
                     "method":"connected overhang ownership; no whole-body scaling",
                     "roles":results},ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
    print([(r["role"],r["recovered_component_count"],r["warning_count"]) for r in results])

if __name__=="__main__":
    main()
