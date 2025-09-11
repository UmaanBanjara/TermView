from app.models.chat import Chat
from app.models.commands import Command
from app.testdb.db import SessionLocal
from app.models.quiz import Quiz


#function to fetch chat history
def get_chat_history(session_id : str):
    db = SessionLocal()
    try:
        return db.query(Chat).filter(Chat.session_id == session_id).order_by(Chat.id.asc()).all()
    finally:
        db.close()

#function to fetch command history
def get_command_history(session_id : str):
    db = SessionLocal()
    try:
        return db.query(Command).filter(Command.session_id == session_id).order_by(Command.id.asc()).all()
    finally:
        db.close()

#function to fetch quiz history
def get_quiz_history(session_id:str):
    db = SessionLocal()
    try:
        return db.query(Quiz).filter(Quiz.session_id == session_id).order_by(Quiz.id.asc()).all()
    finally:
        db.close()