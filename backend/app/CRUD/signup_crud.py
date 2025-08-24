from sqlalchemy.orm import Session
from app.models.users import User
from app.testdb.db import SessionLocal

#function to create a new user
def create_user(fname:str, lname:str ,username:str , email:str , password:str):
    db: Session = SessionLocal()
    try:
        new_user = User(
            fname=fname,
            lname=lname,
            username=username,
            email=email,
            password=password
        )
        db.add(new_user)
        db.commit()
        db.refresh(new_user)
        return new_user
    except Exception as e:
        db.rollback()
        raise e
    finally:
        db.close()