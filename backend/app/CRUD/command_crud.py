from sqlalchemy.orm import Session
from app.models.commands import Command
from app.testdb.db import SessionLocal

#function to save commands in db
def new_command(session_id : str , command_txt : str):
    db:Session = SessionLocal()
    try:
        command = Command(
            session_id = session_id,
            command_text = command_txt
        )
        db.add(command)
        db.commit()
        db.refresh(command)
        return command
    except Exception as e:
        db.rollback()
        raise e
    finally:
        db.close()