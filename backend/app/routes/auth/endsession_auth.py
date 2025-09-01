from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from app.CRUD.endsession_crud import endsession

class IdCheck(BaseModel):
    id: int

router = APIRouter()

@router.post("/endsession")
def end(check: IdCheck):
    try:
        endsession(check.id)
        return {
            "message": "Session Ended Successfully"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
