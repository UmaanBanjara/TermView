from fastapi import APIRouter, HTTPException, Header
from pydantic import BaseModel
from app.CRUD.quiz_crud import new_quiz
from app.utils.current_user import get_user_id_from_token

class QuizCheck(BaseModel):
    ques: str
    a1: str
    a2: str
    a3: str
    a4: str
    ans: str

router = APIRouter()

@router.post("/createquiz")
async def create_quiz(
    qcheck: QuizCheck,
    authorization: str = Header(...)
):
    token = authorization.split(" ")[1]
    user_id = get_user_id_from_token(token)
    if not user_id:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    try:
        quiz = new_quiz(
            user_id=user_id,
            ques=qcheck.ques,
            a1=qcheck.a1,
            a2=qcheck.a2,
            a3=qcheck.a3,
            a4=qcheck.a4,
            ans=qcheck.ans
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

    return {
        "message" : "Quiz Created Successfully",
        "id": quiz.id,
        "ques": quiz.ques,
        "a1": quiz.a1,
        "a2": quiz.a2,
        "a3": quiz.a3,
        "a4": quiz.a4,
        "ans": quiz.ans,
        "created_at": quiz.created_at,
        "user_id": quiz.user_id
    }
