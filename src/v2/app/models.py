from sqlalchemy import Column, Integer, String

from .db import Base


class Restaurant(Base):
    __tablename__ = "restaurants"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True)
    address = Column(String, index=True)
    phone = Column(String, index=True)
    email = Column(String, index=True)
