from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routes.auth import signup_auth
from app.routes.auth import login_auth
from app.routes.auth import upload_auth
from app.routes.auth import changepass_auth
from app.routes.auth import deleteacc_auth
from app.routes.auth import quiz_auth

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
app.include_router(upload_auth.router , prefix="/auth" , tags=["Upload"])
app.include_router(changepass_auth.router , prefix="/auth" , tags=["Change Password"])
app.include_router(deleteacc_auth.router , prefix="/auth" , tags=["Delete Account"])
app.include_router(quiz_auth.router , prefix="/quiz" , tags=["Quiz"])

#root endpoint
@app.get("/")
async def root():
    return{
        "message" : "Welcome to TermView Api"
    }