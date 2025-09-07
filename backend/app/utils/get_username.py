from sqlalchemy.orm import Session
from app.testdb.db import SessionLocal
from app.models.users import User

def getusername(user_id: int) -> str:
    db: Session = SessionLocal()
    try:
        user = db.query(User).filter(User.id == user_id).first()
        if user:
            return user.username  # return the username
        return "Unknown"  # fallback if user not found
    finally:
        db.close()  # always close the session
