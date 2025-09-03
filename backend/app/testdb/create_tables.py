from app.testdb.db import engine, Base
from app.models.users import User
from app.models.live import Live
from app.models.quiz import Quiz
from app.models.chat import Chat
from app.models.commands import Command

Base.metadata.create_all(bind=engine)
print("Tables created successfully")
