from sqlalchemy import Integer, String , ForeignKey, DateTime
from sqlalchemy.orm import relationship
from app.testdb.db import Base
from datetime import datetime

class Chat(Base):
    __tablename__ = "chat"

    id = Column(Integer , primary_key=True , nullable=False , index=True)
    session_id = Column(String , ForeignKey("live.session_id"), nullable=False)
    user_id = Column(Integer , ForeignKey("users.id") , nullable=False)
    message = Column(String, nullable=False)
    created_at = Column(DateTime , default=datetime.utcnow , nullable=False)

    #Relationships

    session=relationship("Live" ,back_populates="chats")
    user = relationship("User" ,back_populates="chats")