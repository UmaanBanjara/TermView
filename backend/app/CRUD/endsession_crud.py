from sqlalchemy.orm import Session
from app.testdb.db import SessionLocal
from app.models.live import Live

#function to end session
def endsession(id:int):
    db:Session = SessionLocal()
    try:
        live_check = db.query(Live).filter(Live.id == id).first()
        if not live_check:
            return {"error" : "Live Session doesn't exits"}
        live_check.is_live = False
        db.commit()
        db.refresh(live_check)
    except Exception as e:
        db.rollback()
        raise e
    finally:
        db.close()