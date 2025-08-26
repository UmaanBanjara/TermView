from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routes.auth import signup_auth
from app.routes.auth import login_auth

app = FastAPI(title = "TermView API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]

)

app.include_router(signup_auth.router , prefix="/auth" , tags=["Authentication"])
app.include_router(login_auth.router , prefix="/auth" , tags=["Authorization"])

#root endpoint
@app.get("/")
async def root():
    return{
        "message" : "Welcome to TermView Api"
    }