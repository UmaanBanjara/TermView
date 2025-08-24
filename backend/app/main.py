from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routes.auth import signup_auth

app = FastAPI(title = "TermView API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]

)

app.include_router(signup_auth.router , prefix="/auth" , tags=["Authentication"])

#root endpoint
@app.get("/")
async def root():
    return{
        "message" : "Welcome to TermView Api"
    }