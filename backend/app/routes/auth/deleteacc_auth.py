from fastapi import APIRouter, HTTPException, Header
from pydantic import BaseModel
from app.CRUD.deleteacc_crud import del_acc
from app.utils.current_user import get_user_id_from_token

class passCheck(BaseModel):
    old_p : str

router = APIRouter()

@router.post("/delacc")
async def deleteaccount(
    passc : passCheck,
    authorization : str = Header(...)

):
    token = authorization.split(" ")[1]
    user_id = get_user_id_from_token(token)
    if not user_id:
        raise HTTPException(status_code=401 , detail="Invalid token")
    result = del_acc(user_id,passc.old_p)

    if "error" in result:
        raise HTTPException(status_code=400 , detail=result["error"])
    
    return result