# Drivest AI Car App — Docker Deployment Guide

This document contains instructions for building, running, and managing the Drivest multi-service application inside Docker containers.

---

## 🏗️ Project Architecture

The application is structured into the following services:
- **Nginx (`nginx`)**: Acts as a reverse proxy on port `80`, routing traffic to the frontend and api endpoints.
- **Next.js Frontend (`frontend`)**: Next.js 15 app router running in standalone production mode on port `3000`.
- **Express Backend (`backend`)**: Node.js ESM server listening on port `5001`.
- **AI Service (`ai`)**: FastAPI app running on port `8000`, containing ML models and Selenium scraping automations.
- **MongoDB (`mongodb`)**: Persistent database instance storing scraper results and user profiles.

---

## ⚙️ Environment Configuration

Before launching, copy the root template file to create your environment configuration:

```bash
cp .env.example .env
```

Open `.env` and fill in the required external credentials (e.g. OpenAI API Key, Cloudinary, Pusher, Stripe).

---

## 🚀 Getting Started

### 1. Development Mode (With Hot-Reload & Exposed Ports)
This mode mounts your local code directories directly into the containers. Any modifications you make to the source code will trigger hot-reloading (nodemon, uvicorn reload, Next.js HMR).

```bash
# Build and start services in the foreground
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up --build

# Run in background (detached mode)
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```

In development, you can connect directly to individual services:
- **Frontend**: [http://localhost:3000](http://localhost:3000)
- **Nginx Entrypoint**: [http://localhost:80](http://localhost:80)
- **Backend API**: [http://localhost:5001](http://localhost:5001)
- **AI / Scraper API Docs**: [http://localhost:8000/docs](http://localhost:8000/docs)
- **MongoDB Connection**: `mongodb://admin:admin_password@localhost:27017`

---

### 2. Production Mode (Locked Code, Optimized Images, Hidden Ports)
This mode builds highly optimized, minimal images (e.g. Next.js Standalone, Alpine/Slim dependencies) without local volume mounts or exposed internal ports.

```bash
# Build and run production containers
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build
```

In production, all internal ports are protected. Traffic is routed exclusively through Nginx on port `80` (and `443` if SSL certificates are configured).

---

## 🧹 Volume and Network Setup

Docker Compose handles these configurations automatically:

### Networks
- `drivest-network`: An internal bridge network. Containers communicate securely using service names (e.g., `http://backend:5001`, `mongodb://mongodb:27017`).

### Volumes
- `mongodb_data`: Persists database collections.
- `backend_uploads`: Preserves temporary upload streams.
- `backend_logs`: Stores backend application logs.
- `ai_logs` / `ai_data`: Persists scraping automation logs and scraped car database JSONs.

---

## 🕷️ Selenium Scraper Operations

The AI Service is preconfigured with Chromium and ChromeDriver binaries.
To manually trigger the scraper within the running environment, send a POST request to the API:

```bash
curl -X POST http://localhost/ai-api/run-scraper
```

### Automated Scheduling
For production deployment, you can set up a system-level cron job on your host server to trigger the scraper every 7 days:

```bash
0 0 */7 * * curl -X POST http://localhost/ai-api/run-scraper >/dev/null 2>&1
```

---

## 🛠️ Troubleshooting & Shell Commands

### View Logs
```bash
# View all container logs
docker-compose logs -f

# View logs for a specific service
docker-compose logs -f backend
docker-compose logs -f ai
```

### Check Container Health Status
```bash
docker-compose ps
```

### Execute a Shell Inside a Container
```bash
# Open an interactive shell inside the FastAPI container
docker-compose exec ai sh

# Connect to the MongoDB CLI
docker-compose exec mongodb mongosh -u admin -p admin_password
```

### Shutdown Services
```bash
# Stops and removes containers
docker-compose down

# Stops, removes containers, and clears all volume data (Destructive)
docker-compose down -v
```
