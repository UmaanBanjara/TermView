from sqlalchemy.orm import Session
from app.models.chat import Chat
from app.testdb.db import SessionLocal

#function to save live chats to db
def new_chat(session_id : str , user_id : int , message : str):
    db:Session = SessionLocal()
    try:
        chat = Chat(
            session_id = session_id,
            user_id = user_id,
            message = message
        )
        db.add(chat)
        db.commit()
        db.refresh(chat)
        return chat
    except Exception as e:
        db.rollback()
        raise e
    finally:
        db.close()