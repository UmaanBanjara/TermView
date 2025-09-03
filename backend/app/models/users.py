from sqlalchemy import Column, Integer, String, DateTime
from app.testdb.db import Base
from sqlalchemy.orm import relationship

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    fname = Column(String , nullable=False)
    lname = Column(String , nullable=False)
    username = Column(String(50), unique=True, nullable=False)
    email = Column(String(100), unique=True, nullable=False)
    password = Column(String, nullable=False)

    #relationship to live
    lives = relationship("Live" , back_populates="user" , cascade="all, delete-orphan")

    #relationship with quiz
    quizzes = relationship("Quiz" , back_populates="user" , cascade="all, delete-orphan")

    #relationship with chat

    chats = relationship("Chat" , back_populates="user" , cascade="all, delete-orphan")