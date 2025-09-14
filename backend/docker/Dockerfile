# Base image with Python
FROM python:3.13-slim

# Set working directory inside the container
WORKDIR /app

# Install system dependencies including Docker CLI
RUN apt-get update && \
    apt-get install -y docker.io bash curl && \
    rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies
COPY ../requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy backend codec
COPY . .

# Expose FastAPI port
EXPOSE 8000

# Start FastAPI
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
