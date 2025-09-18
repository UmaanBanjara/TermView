# from fastapi import APIRouter, HTTPException
# from pydantic import BaseModel
# from sqlalchemy.orm import Session
# from app.utils.jwt_handler import create_access_token, verify_access_token
# from app.models.users import User
# from app.testdb.db import SessionLocal

# router = APIRouter()

# # Pydantic model for incoming refresh token
# class RefreshCheck(BaseModel):
#     r_token: str

# # Helper function to decode token and extract user_id
# def get_user_id_from_token(token: str):
#     token_data = verify_access_token(token)
#     if token_data is None or (isinstance(token_data, dict) and token_data.get("error")):
#         raise HTTPException(status_code=401, detail="Invalid or expired token")
#     return token_data.user_id

# @router.post("/refresh")
# def refresh_access_token(r_token: RefreshCheck):
#     db: Session = SessionLocal()
#     try:
#         # Extract user ID from refresh token
#         user_id = get_user_id_from_token(r_token.r_token)

#         # Check if user exists
#         user = db.query(User).filter(User.id == user_id).first()
#         if not user:
#             raise HTTPException(status_code=404, detail="User not found")

#         # Create new access token
#         new_access_token = create_access_token(data={"user_id": user.id})

#         return {
#             "access_token": new_access_token,
#             "token_type": "bearer"
#         }

#     except HTTPException as e:
#         raise e
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=str(e))
#     finally:
#         db.close()
