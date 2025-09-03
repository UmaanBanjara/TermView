from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
import os
from dotenv import load_dotenv

load_dotenv() #loads dotenvv

DATABASE_URL = os.getenv("DATABASE_URL")

engine = create_engine(DATABASE_URL)

SessionLocal = sessionmaker(autocommit = False , autoflush = False , bind = engine)

Base = declarative_base()

#simple function to test the connection
def test_connection():
    try:
        conn = engine.connect()
        print("DB connection successful")
        conn.close()
    except Exception as e:
        print("DB connection failed", e)
