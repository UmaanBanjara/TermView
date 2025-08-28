from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, EmailStr
from app.CRUD.login_crud import check_user
from app.utils.jwt_handler import create_access_token

class UserCheck(BaseModel):
    email:EmailStr
    password:str

router = APIRouter()

@router.post("/login")

def login(user : UserCheck):
    user_in_db = check_user(user.email , user.password)
    if not user_in_db:
        raise HTTPException(status_code=401 , detail="Invalid Email or Password")

    #create jwt token with user_id
    access_token = create_access_token(data={"user_id" : user_in_db.id})

    #return everything
    return {
        "message" : "Login Successfull",
        "access_token" : access_token,
        "token_type" : "bearer",
        "username" : user_in_db.username
    }