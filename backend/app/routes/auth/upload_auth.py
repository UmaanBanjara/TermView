from fastapi import APIRouter, UploadFile, File, Form, HTTPException, Header
from app.CRUD.post_crud import create_post
from app.utils.cloudinary import upload_to_cloudinary
from app.utils.current_user import get_user_id_from_token
import os
from dotenv import load_dotenv

load_dotenv()

FRONTEND_URL= os.getenv("FRONTEND_URL")

router = APIRouter()

@router.post("/upload/thumbnail")
async def upload_thumbnail(
    file: UploadFile = File(...),
    title: str = Form(...),
    desc: str = Form(...),
    is_chat: bool = Form(...),
    is_live: bool = Form(...),
    authorization: str = Header(...),
):  
    # extract token from header
    try:
        token = authorization.split(" ")[1]
    except IndexError:
        raise HTTPException(status_code=400, detail="Invalid Authorization header")
    
    user_id = get_user_id_from_token(token)

    # upload file to Cloudinary
    upload = await upload_to_cloudinary(file)
    if "error" in upload:
        raise HTTPException(status_code=500, detail=upload["error"])
    
    url = upload.get("url")
    if not url:
        raise HTTPException(status_code=500, detail="No URL returned from Cloudinary")
    
    # store in DB
    new_post = create_post(
        title=title,
        desc=desc,
        thumbnail_url=url,
        is_live=is_live,
        is_chat=is_chat,
        user_id=user_id,
    )

    #generating dynamic links using session_id from DB
    dynamic_link = f"{FRONTEND_URL}/live?session_id={new_post.session_id}"

    #sending session_id back
    ses_id = new_post.session_id

    return {
        "success": True,
        "post_id": new_post.id,
        "thumbnail": url,
        "title": new_post.title,
        "desc": new_post.desc,
        "enable_chat": new_post.is_chat,
        "link" : dynamic_link,
        "ses_id" : ses_id
    }
