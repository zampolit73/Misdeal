#!/usr/bin/env python3
"""D267: preserve user-approved rich Court character sheets, seam-aware export.
Input exactly the three 1374x1145 RGBA generated sources. Source metadata
preserved, target 576x480 WebP lossless with five transparent spares per role.
Reject if no complete distinct frame or over-cropped art. Never use D266 proxy.
"""
from pathlib import Path
from io import BytesIO
import base64,hashlib,json
import numpy as np
from PIL import Image
import cv2
ROOT=Path(__file__).resolve().parents[2]
SRC_ROOT=ROOT/"assets/pixel/units/court_of_the_mute_qa/source_d267"
OUT=ROOT/"assets/pixel/units/court_of_the_mute_qa"
OUT.mkdir(exist_ok=True)
CELL=229
SPEC=(('idle',4),('walk',6),('attack',6),('hit',3),('death',6))
ROLES={
'mute_magistrate':'mute_magistrate_d267_approved_source_png.b64',
'ash_scrivener':'ash_scrivener_d267_approved_source_png.b64',
'bone_bailiff':'bone_bailiff_d267_approved_source_png.b64'}
REPORT={"version":"D267","stage":"SOURCE_CONVERTED_QA_ONLY_NATIVE_GODOT_PENDING","roles":[],"source":"original user-approved transparent generated rich sheets"}


def extract_component_masks(row,used,role,state):
    alpha=row[:,:,3]
    count,labels,stats,_=cv2.connectedComponentsWithStats((alpha>40).astype(np.uint8),8)
    big=[]
    for idx in range(1,count):
        x,y,w,h,size=map(int,stats[idx]);
        if size>5000:big.append((idx,x,y,w,h,size))
    big.sort(key=lambda q:q[1])
    if len(big)!=used:
        # Bailiff late death poses blend side-by-side within one illustrated
        # connected component; don't invent separated silhouettes: split only
        # the already-authored original pixels by pose's source-cell x band.
        if role=='bone_bailiff' and state=='death' and len(big)==4 and big[-1][3]>CELL*2:
            pass
        else:raise RuntimeError(f'{role}:{state} expected {used} large source silhouettes; found {len(big)}')
    output=[];diagnostics=[]
    if len(big)==used:
        for col,comp in enumerate(big):
            idx,x,y,w,h,size=comp
            chosen=(labels==idx)
            px=np.where(chosen,alpha,0)
            crossing=int(np.count_nonzero(chosen[:, :col*CELL])+np.count_nonzero(chosen[:,(col+1)*CELL:]))
            output.append(chosen)
            diagnostics.append({'frame':col,'source_bbox':[x,y,w,h],'pixels':size,'recovered_outside_cell':crossing,'source_at_row_edges':int(np.count_nonzero(chosen[0:2,:])+np.count_nonzero(chosen[-2:,:]))})
    else:
        # Only the last three (merged) corpses: 3 independent already-drawn
        # silhouettes occupy adjacent frame columns, with overlapping cloth.
        for col in range(used):
            if col<3:
                idx,x,y,w,h,size=big[col]
                chosen=labels==idx
            else:
                idx,x,y,w,h,size=big[-1]
                xx=np.arange(row.shape[1])[None,:]
                chosen=(labels==idx)&(xx>=col*CELL)&(xx<(col+1)*CELL)
            ys,xs=np.where(chosen)
            if len(xs)<5000:raise RuntimeError(f'{role}:{state}:{col} too few source pixels')
            output.append(chosen)
            diagnostics.append({'frame':col,'source_bbox':[int(xs.min()),int(ys.min()),int(xs.max()-xs.min()+1),int(ys.max()-ys.min()+1)],'pixels':len(xs),'recovered_outside_cell':int(np.count_nonzero(chosen[:,:col*CELL])+np.count_nonzero(chosen[:,(col+1)*CELL:])),'source_at_row_edges':int(np.count_nonzero(chosen[0:2,:])+np.count_nonzero(chosen[-2:,:])),'merged_pose_split':col>=3})
    return output,diagnostics


def pack(role,path):
    source_bytes=base64.b64decode(path.read_text(encoding='ascii'))
    image=Image.open(BytesIO(source_bytes)).convert('RGBA')
    if image.size!=(1374,1145):raise RuntimeError('incorrect original image dimensions')
    src=np.array(image,dtype=np.uint8)
    atlas=Image.new('RGBA',(576,480),(0,0,0,0))
    hashes=set();details=[]; flags=[]
    for row_index,(state,used) in enumerate(SPEC):
        row=src[row_index*CELL:(row_index+1)*CELL,:,:]
        masks,met=extract_component_masks(row,used,role,state)
        for col,(mask,m) in enumerate(zip(masks,met)):
            ys,xs=np.where(mask)
            x0,x1,y0,y1=int(xs.min()),int(xs.max()+1),int(ys.min()),int(ys.max()+1)
            pixels=np.where(mask[:,:,None],row,0).astype(np.uint8)
            piece=Image.fromarray(pixels[y0:y1,x0:x1],'RGBA')
            # Preserve full original line/art, including detached silhouettes
            # recovered from neighboring columns. Width/height fit separately
            # only when needed to avoid losing a genuine weapon overhang.
            maxw,maxh=90,89
            ratio=min(maxw/piece.width,maxh/piece.height,0.440)
            neww=max(1,round(piece.width*ratio));newh=max(1,round(piece.height*ratio))
            piece=piece.resize((neww,newh),Image.Resampling.LANCZOS)
            tile=Image.new('RGBA',(96,96),(0,0,0,0))
            tile.alpha_composite(piece,((96-neww)//2,92-newh))
            # Safeguard against resampling halos crossing the reserved gutter.
            if not tile.getchannel('A').crop((2,2,94,94)).getbbox():raise RuntimeError('blank tile')
            a=np.array(tile.getchannel('A'))
            if a[:2].max()>32 or a[-2:].max()>32 or a[:,:2].max()>32 or a[:,-2:].max()>32:raise RuntimeError('cropped gutter')
            h=hashlib.sha256(tile.tobytes()).hexdigest()
            if h in hashes:raise RuntimeError('duplicate pose tile')
            hashes.add(h)
            atlas.alpha_composite(tile,(col*96,row_index*96))
            m.update({'state':state,'output_col':col,'scale':round(ratio,4),'output_span':[neww,newh],'pose_sha256':h})
            details.append(m)
            if m['source_at_row_edges']>8:
                flags.append({'state':state,'frame':col,'kind':'SOURCE_ROW_EDGE_TRUNCATION','pixels':m['source_at_row_edges']})
            if m.get('merged_pose_split'):
                flags.append({'state':state,'frame':col,'kind':'SHARED_ORIGINAL_ALPHA_CONNECTED_SILHOUETTES_REVIEW_SEAM'})
    if len(hashes)!=25:raise RuntimeError('not full25')
    raw_atlas=np.array(atlas,dtype=np.uint8)
    raw_atlas[raw_atlas[:,:,3]==0,:3]=0
    atlas=Image.fromarray(raw_atlas,"RGBA")
    buf=BytesIO();atlas.save(buf,'WEBP',lossless=True,method=6)
    raw=buf.getvalue()
    target=OUT/f'{role}_d267_rich_qa.webp.b64'
    # split base64 into accessible library text lines (small 256 chars each)
    b64=base64.b64encode(raw).decode('ascii')
    target.write_text(b64+'\n',encoding='ascii')
    arr=Image.open(BytesIO(base64.b64decode(target.read_text()))).convert('RGBA')
    if not np.array_equal(np.asarray(arr)[:,:,3],np.asarray(atlas)[:,:,3]):raise RuntimeError('alpha roundtrip')
    return atlas,{'role':role,'source_name':path.name,'source_sha256':hashlib.sha256(source_bytes).hexdigest(),'atlas_sha256':hashlib.sha256(raw).hexdigest(),'source_dimensions':[1374,1145],'atlas_dimensions':[576,480],'authored_poses':25,'unused_alpha_clear_cells':5,'full_frame_details':details,'warnings':flags,'source_warning_count':len(flags),'visual_Godot_x1':'NOT_RUN','art_approved_in_chat':'USER_APPROVED_DIRECTION_NEEDS_IN_ENGINE_CONFIRMATION'}


def run():
    contact=Image.new('RGBA',(576*3,480),(16,18,22,255))
    for i,(role,source_name) in enumerate(ROLES.items()):
        atlas,result=pack(role,SRC_ROOT/source_name)
        contact.alpha_composite(atlas,(i*576,0))
        REPORT['roles'].append(result)
        print(role,'sha',result['atlas_sha256'],'source warnings',result['source_warning_count'],'file size', (OUT/f'{role}_d267_rich_qa.webp.b64').stat().st_size)
    # Presentation contact is a local QA artifact only, not a production asset.
    # Do not include the black presentation canvas in the atlas or card image.
    REPORT['required_original_poses']=75
    REPORT['accepted_structurally']=75
    REPORT['source_warnings_total']=sum(r['source_warning_count'] for r in REPORT['roles'])
    REPORT['imported_to_production_library']=False
    REPORT['game_card39_live']=False
    report_path=ROOT/'docs/qa/D267_RICH_COURT_ART_RECOVERY_QC.json'
    report_path.parent.mkdir(parents=True,exist_ok=True)
    report_path.write_text(json.dumps(REPORT,indent=2,ensure_ascii=False)+'\n',encoding='utf-8')

if __name__=='__main__':run()
