from os import getenv

from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

load_dotenv()
PG_USER = getenv("POSTGRES_USER", "postgres")
PG_PASSWORD = getenv("POSTGRES_PASSWORD", "password")
PG_HOST = getenv("POSTGRES_HOST", "localhost")
PG_PORT = getenv("POSTGRES_PORT", 5432)
PG_DB = getenv("POSTGRES_DB", "db")


SQLALCHEMY_DATABASE_URL = f"postgresql://{PG_USER}:{PG_PASSWORD}@{PG_HOST}/{PG_DB}"

engine = create_engine(SQLALCHEMY_DATABASE_URL)

SessionLocal = sessionmaker(bind=engine)
Base = declarative_base()


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
