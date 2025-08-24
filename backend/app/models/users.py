from sqlalchemy import Column, Integer, String
from app.testdb.db import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    fname = Column(String , nullable=False)
    lname = Column(String , nullable=False)
    username = Column(String(50), unique=True, nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    password = Column(String, nullable=False)
