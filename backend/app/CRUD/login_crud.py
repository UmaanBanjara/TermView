from sqlalchemy.orm import Session
from app.models.users import User
from app.testdb.db import SessionLocal
from app.utils.security import verify_password

#function to validate user
def check_user(email:str , password:str):
    db:Session = SessionLocal()
    try:
        user_check = db.query(User).filter(User.email == email).first()
        if user_check and verify_password(password , user_check.password):
            return user_check
        return None
    finally:
        db.close()