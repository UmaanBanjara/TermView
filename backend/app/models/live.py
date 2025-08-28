from sqlalchemy import Column , Integer , String , Boolean, ForeignKey
from app.testdb.db import Base
from sqlalchemy.orm import relationship

class Live(Base):
    __tablename__ = "live"

    id = Column(Integer , primary_key = True , index = True)
    title = Column(String , nullable = False)
    desc = Column(String , nullable=False)
    thumb = Column(String)
    is_live = Column(Boolean , default = False , nullable=False)

    #foreign key to user table
    user_id = Column(Integer , ForeignKey("users.id"), nullable=False)

    #optional : relationships for easy access

    user = relationship("User" , back_populates="lives")