from sqlalchemy.orm import Session
from app.testdb.db import SessionLocal
from app.utils.security import verify_password
from app.models.users import User

#function to validate and delete user
def del_acc(user_id : int ,old_p : str):
    db:Session = SessionLocal()
    try:
        user = db.query(User).filter(User.id == user_id).first()
        if not user:
            return {"error" : "User not found"}
        if not verify_password(old_p , user.password):
            return {"error" : "Invalid old password"}
        db.delete(user)
        db.commit()

        return {"Success" : "User account deleted successfully"}

    except Exception as e:
        db.rollback()
        return {"error" : str(e)}

    finally:
        db.close()
        
