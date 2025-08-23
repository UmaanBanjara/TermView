from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, EmailStr
from app.CRUD.signup_crud import create_user

class UserCreate(BaseModel):
        username:str
        email:EmailStr
        password:str

router = APIRouter()

@router.post("/signup")
async def signup(user : UserCreate):
    try:
        new_user = await create_user(user.username, user.email, user.password)
        return {
            "message" : "User created Successfully", "user_id" : new_user.id
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))