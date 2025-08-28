from fastapi import HTTPException
from fastapi.security import OAuth2PasswordBearer
from app.utils.jwt_handler import verify_access_token, TokenData

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login") #points to login endpoint

def get_user_id_from_token(token : str):
    token_data = verify_access_token(token)
    if token_data is None or isinstance(token_data , dict) and token_data.get("error"):
        return HTTPException(status_code=401, detail="Invalid or Expired token")
    return token_data.user_id

