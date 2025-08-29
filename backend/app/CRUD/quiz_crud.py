from sqlalchemy.orm import Session
from app.models.quiz import Quiz
from app.testdb.db import SessionLocal

#function to add quiz

def new_quiz(user_id : int , ques : str , a1 : str , a2 : str , a3 : str , a4 : str , ans : str):
    db: Session = SessionLocal()
    try:
        quiz_new = Quiz(
            user_id=user_id,
            ques=ques,
            a1=a1,
            a2=a2,
            a3=a3,
            a4=a4,
            ans=ans
        )
        db.add(quiz_new)
        db.commit()
        db.refresh(quiz_new)
        return quiz_new
    except Exception as e:
        db.rollback()
        raise e
    finally:
        db.close()