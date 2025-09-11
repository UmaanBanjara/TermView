from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from app.testdb.db import Base
from sqlalchemy.orm import relationship
from datetime import datetime

class Quiz(Base):
    __tablename__ = "quiz"

    id=Column(Integer , primary_key=True, nullable=False)
    ques = Column(String , nullable=False)
    a1 = Column(String , nullable=False)
    a2 = Column(String ,nullable=False)
    a3 = Column(String , nullable=False)
    a4 = Column(String , nullable=False)
    ans = Column(String , nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow , nullable=False)

    #foreign key to user tablew
    user_id = Column(Integer, ForeignKey("users.id") , nullable=False)
    #foreing key to live session id
    session_id = Column(String, ForeignKey("live.session_id"), nullable=False)

    #relationship with user
    user = relationship("User" , back_populates="quizzes")