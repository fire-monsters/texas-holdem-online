# Texas Hold'em Online

A real-time multiplayer Texas Hold'em poker game built with Node.js, Express, Socket.IO, and React (Vite).

---

## Quick Start

### Option 1: Docker (Recommended)

**Prerequisites:**
- Docker Engine 24+
- Docker Compose v2+

```bash
# 1. Clone the repo
git clone https://github.com/YOUR_USERNAME/texas-holdem-online.git
cd texas-holdem-online

# 2. Copy environment template
cp .env.example config/local.env

# 3. Start all services
docker compose up --build
```

| Service  | URL                   |
|----------|-----------------------|
| Frontend | http://localhost:3000 |
| Backend  | http://localhost:7777 |

**Demo login:**
- Email: `player1@demo.com`
- Password: any (e.g. `demo123`)

---

### Option 2: Local (Without Docker)

**Prerequisites:**
- Node.js 18+
- npm 8+

```bash
# 1. Install all dependencies (backend + frontend)
npm run install:all

# 2. Copy environment template
cp .env.example config/local.env

# 3. Start both servers together
npm start
```

---

## Environment Variables

Copy `.env.example` to `config/local.env` for local development.
**Never commit `config/local.env` to git.**

| Variable               | Required | Default                          | Description                        |
|------------------------|----------|----------------------------------|------------------------------------|
| `PORT`                 | No       | `7777`                           | Backend server port                |
| `NODE_ENV`             | No       | `development`                    | Environment mode                   |
| `JWT_SECRET`           | No       | `demo-secret-key-...`            | JWT signing secret                 |
| `JWT_TOKEN_EXPIRES_IN` | No       | `7d`                             | JWT token expiry                   |
| `MONGO_URI`            | No       | `undefined`                      | MongoDB URI (app runs without it)  |
| `CLIENT_URL`           | No       | -                                | Frontend URL (production only)     |

---

## CI/CD Pipeline

GitHub Actions runs automatically on every push and PR.

**Pipeline jobs:**
1. **Backend CI** — installs deps, starts server, health check
2. **Frontend CI** — installs deps, runs tests, builds app
3. **Docker Build** — builds both images, smoke tests compose

**Adding secrets to CI:**
1. Go to your GitHub repo
2. Settings → Secrets and variables → Actions
3. Add `JWT_SECRET` with a secure value

---

## Health Checks & Service Order

Services start in this order:

1. Backend  (port 7777) → starts first
2. Frontend (port 3000) → starts after backend

Verify both are healthy:
```bash
# Check backend is responding
curl http://localhost:7777

# Check containers are running
docker compose ps

# View live logs
docker compose logs -f
```

---

## Troubleshooting

### Port already in use

```bash
# Find what is using the port
lsof -i :7777
lsof -i :3000

# Kill the process by PID
kill -9 <PID>

# Then restart
docker compose up --build
```

### Docker permission denied

```bash
# Add your user to docker group
sudo usermod -aG docker $USER

# Apply without logging out
newgrp docker
```

### Frontend cannot reach backend

- Ensure backend container is running: `docker compose ps`
- Check backend logs: `docker compose logs backend`
- Confirm port 7777 is not blocked by firewall

### Container builds but app crashes

```bash
# View logs for specific service
docker compose logs backend
docker compose logs frontend

# Rebuild from scratch (no cache)
docker compose down --volumes
docker compose up --build
```

### MongoDB connection errors

The app runs without MongoDB using in-memory/mock data.
To enable real persistence, uncomment the `mongo` service
in `docker-compose.yml` and set `MONGO_URI=mongodb://mongo:27017/texasholdem`
in `config/local.env`.

---

## Rollback Guide

```bash
# Stop current containers
docker compose down

# Go back to last working commit
git log --oneline -5        # find the good commit hash
git checkout <commit-hash>  # switch to it

# Restart from that state
docker compose up --build
```

---

## Known Limitations

- MongoDB is optional; user data does not persist between restarts without it
- Vite throws a harmless `xdg-open ENOENT` error in Docker (no browser in container)
- Hot reload works in Docker via volume mounts but may be slower than native
- No Kubernetes or cloud deployment configured (out of scope)

---

## Project Structure
texas-holdem-online/
├── .github/workflows/    # CI pipeline
├── client/               # React + Vite frontend
│   └── Dockerfile
├── config/               # App configuration
├── controllers/          # Route handlers
├── core/                 # Game logic (Deck, Table, Player)
├── middleware/            # Express middleware
├── models/               # Mongoose models
├── routes/               # API routes
├── socket/               # Socket.IO game events
├── utils/                # Helper functions
├── Dockerfile            # Backend container
├── docker-compose.yml    # Multi-service orchestration
├── .env.example          # Environment variable template
└── server.js             # App entry point

