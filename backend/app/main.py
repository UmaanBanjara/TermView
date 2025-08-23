from fastapi import FastAPI
from app.routes.auth import signup_auth

app = FastAPI(title = "TermView API")

app.include_router(signup_auth.router , prefix="/auth" , tags=["Authentication"])

#root endpoin
@app.get("/")
async def root():
    return{
        "message" : "Welcome to TermView Api"
    }