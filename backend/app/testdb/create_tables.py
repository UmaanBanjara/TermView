from app.testdb.db import engine, Base
import app.models #importing all table models

Base.metadata.create_all(bind=engine)
print("Tables created successfully")
