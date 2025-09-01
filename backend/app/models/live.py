from sqlalchemy import Column, Integer, String, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from app.testdb.db import Base
import uuid

class Live(Base):
    __tablename__ = "live"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    desc = Column(String, nullable=False)
    thumb = Column(String)
    is_live = Column(Boolean, default=False, nullable=False)
    is_chat = Column(Boolean, default=False, nullable=False)
    
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    session_id = Column(String , unique=True, default=lambda: str(uuid.uuid4()))

    # optional: relationship to user
    user = relationship("User", back_populates="lives")
