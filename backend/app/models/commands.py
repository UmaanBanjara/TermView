from sqlalchemy import Integer, String, ForeignKey
from datetime import datetime
from sqlalchemy.orm import relationship
from app.testdb.db import Base

class Command(Base):
    __tablename__ = "command"

    id = Column(Integer , primary_key=True , index=True, nullable=False)
    session_id = Column(String , ForeignKey("live.session_id") , nullable=False)
    command_text = Column(String , nullable=False)
    created_at = Column(DateTime , default=datetime.utcnow , nullable=False)

    #relationship to live
    session = relationship("Live" , back_populates="commands")