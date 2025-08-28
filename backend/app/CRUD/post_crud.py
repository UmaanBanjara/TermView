from sqlalchemy.orm import Session
from app.models.live import Live
from app.testdb.db import SessionLocal

#function to create a new post
def create_post(title : str , desc : str , enable_chat : bool , thumbnail_url):
    db:Session = SessionLocal()
    try:
        new_post = Live(
            title = title,
            desc = desc,
            thumb = thumbnail_url,
            is_live = enable_chat,
        )
        db.add(new_post)
        db.commit()
        db.refresh(new_post)
        return new_post
    except Exception as e:
        db.rollback()
        raise e
    finally:
        db.close()