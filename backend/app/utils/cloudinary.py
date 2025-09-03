import cloudinary
import cloudinary.uploader
from cloudinary.utils import cloudinary_url
import os
from dotenv import load_dotenv
from fastapi import UploadFile, HTTPException

#importing dotenv
load_dotenv()


#configuration
cloudinary.config(
    cloud_name = os.getenv("cloud_name"),
    api_key = os.getenv("api_key"),
    api_secret = os.getenv("api_secret"),
    secure = True
)

#function to upload to cloudinaryy
async def upload_to_cloudinary(file : UploadFile):
    try:
        result = cloudinary.uploader.upload(file.file , public_id=file.filename , overwrite=False)
        return {"url" : result.get("secure_url")}
    except Exception as e:
        return {"error" : str(e)}