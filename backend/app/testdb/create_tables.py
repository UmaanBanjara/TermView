from app.testdb.db import engine, Base
from app.models.users import User

Base.metadata.create_all(bind=engine)
print("Tables created successfully")
