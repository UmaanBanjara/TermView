from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, EmailStr
from app.CRUD.login_crud import check_user

class UserCheck(BaseModel):
    email:EmailStr
    password:str

router = APIRouter()

@router.post("/login")

def login(user : UserCheck):
    user_in_db = check_user(user.email , user.password)
    if not user_in_db:
        raise HTTPException(status_code=401 , detail="Invalid Email or Password")

    return {"message" : "Login Successfull", "user" : user_in_db.username}        