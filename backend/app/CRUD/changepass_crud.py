from sqlalchemy.orm import Session
from app.models.users import User
from app.testdb.db import SessionLocal
from app.utils.security import verify_password, hash_password

#function to validate old password and change password
def change_password(user_id : int , old_p : str , new_p : str):
    db:Session = SessionLocal()
    try:
        user = db.query(User).filter(User.id == user_id).first()
        if not user:
            return {"error" : "User not found"}
        if not verify_password(old_p , user.password):
            return {"error" : "Invalide old password"}
        if verify_password(new_p , user.password):
            return {"error": "New password can't be same as old password"}
        user.password = hash_password(new_p)
        db.add(user)
        db.commit()
        db.refresh(user)
        return {"success" : "Password updated successfully"}
    except Exception as e:
        db.rollback()
        return {"error" : str(e)}
    finally:
        db.close()