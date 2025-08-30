from fastapi import APIRouter, HTTPException
from app.CRUD.fetchall_crud import check_live

router = APIRouter()

@router.get("/fetchall")

def fetch_all():
    result = check_live()
    if not result:
        raise HTTPException(status_code=401 , detail="Nothing to show here")
    
    #returns list of object not individual list so we have to convert it to dict

    live_sessions = [
        {"id" : s.id, "title":s.title , "desc" : s.desc , "thumb" : s.thumb , "is_live" : s.is_live , "is_chat" : s.is_chat,
        "user_id" : s.user.username if s.user else None
        } for s in result
    ]

    return{
        "message" : "There are live sessions",
        "sessions" :live_sessions
    }