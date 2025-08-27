from sqlalchemy import Column , Integer , String , Boolean
from app.testdb.db import Base

class Live(Base):
    __tablename__ = "Live"

    id = Column(Integer , primary_key = True , index = True)
    title = Column(String , nullable = False)
    desc = Column(String , nullable=False)
    thumb = Column(String)
    is_live = Column(Boolean , default = False , nullable=False)

