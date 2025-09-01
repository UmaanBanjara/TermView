from sqlalchemy.orm import Session
from app.models.live import Live
from app.testdb.db import SessionLocal

def create_post(title: str, desc: str, thumbnail_url: str, user_id: int, is_live: bool, is_chat: bool):
    db:Session = SessionLocal()
    try:
        new_post = Live(
            title=title,
            desc=desc,
            thumb=thumbnail_url,
            is_live=is_live,
            is_chat=is_chat,
            user_id=user_id,
        )
        db.add(new_post)
        db.commit()
        db.refresh(new_post)
        return new_post
    except Exception as e:
        db.rollback()
        raise
