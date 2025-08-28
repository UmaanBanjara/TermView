from fastapi import APIRouter , UploadFile , File , Form , HTTPException
from app.CRUD.post_crud import create_post
from app.utils.cloudinary import upload_to_cloudinary

router = APIRouter()

@router.post("/upload/thumbnail")
async def upload_thumbnail(
    file : UploadFile = File(...),
    title : str = Form(...),
    desc : str = Form(...),
    enable_chat : bool = Form(...),

):  

    #upload file to cloudinary via uplaod function
    upload = await upload_to_cloudinary(file)
    print("Upload response",upload)

    if "error" in upload:
        return HTTPException(status_code = 500 , detail=upload["error"])
    
    url = upload.get("url") #get url

    if not url:
        return HTTPException(status_code=500 , detail="No URL returned from Cloudinary")
    
    new_post = create_post(title , desc , enable_chat , url , userId) #store in db

    return {
        "success" : True,
        "post_id" : new_post.id,
        "thumbnail" : url,
    }

