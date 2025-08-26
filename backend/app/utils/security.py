from passlib.context import CryptContext

# Password context using bcrypt
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Hashing plain password
def hash_password(password: str) -> str:
    return pwd_context.hash(password)

# Verifying a plain password against a hashed password
def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)
