from app.testdb.db import engine, Base
from app.models.users import User
from app.models.live import Live
from app.models.quiz import Quiz

Base.metadata.create_all(bind=engine)
print("Tables created successfully")
