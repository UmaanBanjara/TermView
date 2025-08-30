from sqlalchemy.orm import Session, joinedload
from app.testdb.db import SessionLocal
from app.models.live import Live

#function to check all 'is_live' sessions:
def check_live():
    db:Session = SessionLocal()
    try:
        return db.query(Live).options(joinedload(Live.user)).filter(Live.is_live == True).all()
    except Exception as e:
        return {"error" : str(e)}
    finally:
        db.close()
    