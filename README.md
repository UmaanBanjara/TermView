# TermView

🚀 **TermView** is a web-based live learning environment for beginner Linux users.
It provides a safe, sandboxed platform where hosts can run Linux commands live, and participants can see results, chat, and take quizzes in real-time.

---

## 🌐 Hosting Requirements

To deploy TermView like the demo, you’ll need to host **3 services** (all possible on [Render Free Tier](https://render.com/)):

1. **PostgreSQL Database** (hosted on Render)
2. **Main Backend** (FastAPI + WebSockets, running inside Docker on Render)
3. **Executor API** (Docker Executor for safe command execution) → [docker-executor repo](https://github.com/UmaanBanjara/docker-executor)

Optional:

* **Cloudinary** ([cloudinary.com](https://cloudinary.com/)) for storing thumbnails for sessions.

---

## 🔑 API Keys and Config

Both the **Flutter frontend** and **FastAPI backend** require hidden API keys. You’ll configure your own:

* `algorithm` → always `HS256`
* `secret_key` → generate with:

  ```bash
  python backend/app/utils/generate_jwt.py
  ```
* `api_key`, `api_secret`, `cloud_name` → from your [Cloudinary](https://cloudinary.com/) account
* `DATABASE_URL` → external PostgreSQL link from Render
* `FRONTEND_URL` → your hosted frontend URL

⚠️ **Important**: Do **not** hardcode values you see in docs or examples. Always use your own secrets.

---

## 🗄 Database Setup

1. Create a PostgreSQL instance on Render.
2. Copy the **external database link** and add it to your `.env`:

   ```env
   DATABASE_URL=your_render_database_url
   ```
3. Run to create the tables:

   ```bash
   python -m app.testdb.create_tables.py
   ```

   ⏳ Wait a bit — tables will be created automatically.
4. To access the DB manually:

   ```bash
   psql your_render_database_url
   ```

---

## 🐳 Docker Setup (Required)

You need **Docker installed** on your machine to build and deploy TermView.

### 1. Build Images

#### Main Backend (FastAPI + WebSockets)

```bash
docker build -f docker/Dockerfile .  
```

This will return an **image ID**. Tag it with your own name:

```bash
docker tag <image_id> your-dockerhub-username/termview-backend:latest
```

#### Executor API

Clone the [docker-executor](https://github.com/UmaanBanjara/docker-executor) repo and build it the same way:

```bash
docker build -f docker/Dockerfile .  
docker tag <image_id> your-dockerhub-username/termview-executor:latest
```

---

### 2. Push to Docker Hub

You’ll need a [Docker Hub](https://hub.docker.com/) account because Render requires pulling from a public registry.

Login to Docker Hub:

```bash
docker login
```

Push your images:

```bash
docker push your-dockerhub-username/termview-backend:latest
docker push your-dockerhub-username/termview-executor:latest
```

---

### 3. Deploy to Render

* Deploy **Backend** on Render using your pushed Docker Hub image.
* Deploy **Executor API** on Render (also from Docker Hub).
* Link both to your **PostgreSQL database**.

---

## 🖼 Cloudinary (Optional)

For thumbnails:

1. Create a [Cloudinary](https://cloudinary.com/) account.
2. Add your Cloudinary credentials (`api_key`, `api_secret`, `cloud_name`) to your `.env`.
3. Thumbnails will upload automatically during sessions.

---

## 🚀 Tech Stack

* **Frontend**: Flutter Web (Riverpod)
* **Backend**: FastAPI + WebSockets
* **Database**: PostgreSQL
* **Executor**: Docker-based sandbox for commands
* **Hosting**: Render (Free Tier) + Docker Hub
* **Optional Media Storage**: Cloudinary

---

## 🧠 Key Features

* Live, real-time Linux sessions
* Safe command execution with Docker sandboxing
* Real-time chat & quizzes
* Session thumbnails (via Cloudinary)
* Secure authentication with JWT + refresh tokens

---

## 📖 Next Steps

1. Fork this repo.
2. Set up `.env` with your API keys + secrets.
3. Build and push Docker images for backend and executor.
4. Deploy services on Render.
5. Connect them together and start exploring Linux safely 🎉

---
