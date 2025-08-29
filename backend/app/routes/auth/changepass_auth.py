from fastapi import APIRouter, HTTPException, Header
from pydantic import BaseModel
from app.CRUD.changepass_crud import change_password
from app.utils.current_user import get_user_id_from_token

class PCheck(BaseModel):
    old_p : str
    new_p : str

router = APIRouter()

@router.post("/forpass")
async def forgotpass(
    passs : PCheck,
    authorization : str = Header(...)
):
    token = authorization.split(" ")[1]
    user_id = get_user_id_from_token(token)
    if not user_id:
        raise HTTPException(status_code=401 , detail="Invalid token")
    result = change_password(user_id , passs.old_p , passs.new_p)

    if "error" in result:
        raise HTTPException(status_code=400 , detail=result["error"])
    
    return result
