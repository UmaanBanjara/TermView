from datetime import datetime, timedelta
from jose import JWTError, jwt 
from pydantic import BaseModel
import os
from dotenv import load_dotenv
from fastapi import HTTPException

#loading dotenv
load_dotenv()

SECRET_KEY= os.getenv("secret_key")
ALGORITHM = os.getenv("algorithm")
ACCESS_TOKEN_EXPIRE_MINUTES = 30 #adjusting left prob will use refresh token

#pydantic model to hold token data
class TokenData(BaseModel):
    user_id : int | None = None

#function to create JWT_TOKEN
def create_access_token(data : dict , expires_delta : timedelta | None = None):
    to_encode = data.copy()
    expire = datetime.utcnow() + (expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp" : expire})
    encoded_jwt = jwt.encode(to_encode , SECRET_KEY , algorithm=ALGORITHM)
    return encoded_jwt

# #function to create refresh tokens
# def create_refresh_token(data : dict , expires_delta : timedelta | None = None):
#     to_encode = data.copy()
#     expire = datetime.utcnow() + (expires_delta or timedelta(days=7))
#     to_encode.update({"exp" : expire})
#     refresh_jwt = jwt.encode(to_encode , SECRET_KEY , algorithm=ALGORITHM)
#     return refresh_jwt
    
#function to verify the token

def verify_access_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: int = payload.get("user_id")
        if user_id is None:
            raise HTTPException(status_code=401, detail="Invalid token")
        return TokenData(user_id=user_id)
    except JWTError:
        raise HTTPException(status_code=401, detail="Token expired or invalid")
        


