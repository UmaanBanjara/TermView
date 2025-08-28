from fastapi import APIRouter , UploadFile , File , Form , HTTPException, Header
from app.CRUD.post_crud import create_post
from app.utils.cloudinary import upload_to_cloudinary
from app.utils.current_user import get_user_id_from_token

router = APIRouter()

@router.post("/upload/thumbnail")
async def upload_thumbnail(
    file : UploadFile = File(...),
    title : str = Form(...),
    desc : str = Form(...),
    enable_chat : bool = Form(...),
    authorization: str = Header(...)
    

):  

    #extract token from header
    token = authorization.split(" ")[1]
    user_id = get_user_id_from_token(token)

    #upload file to cloudinary via uplaod function
    upload = await upload_to_cloudinary(file)
    print("Upload response",upload)

    if "error" in upload:
        raise HTTPException(status_code = 500 , detail=upload["error"])
    
    url = upload.get("url") #get url

    if not url:
        raise HTTPException(status_code=500 , detail="No URL returned from Cloudinary")
    
    new_post = create_post(title , desc , enable_chat , url , user_id) #store in db

    return {
        "success" : True,
        "post_id" : new_post.id,
        "thumbnail" : url,
    }

