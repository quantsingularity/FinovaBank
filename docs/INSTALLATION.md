# Installation Guide

This document provides comprehensive installation instructions for FinovaBank across different platforms and deployment scenarios.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation Options](#installation-options)
- [Quick Install with Docker Compose](#quick-install-with-docker-compose)
- [Manual Local Development Setup](#manual-local-development-setup)
- [Production Deployment](#production-deployment)
- [Platform-Specific Instructions](#platform-specific-instructions)
- [Verification](#verification)

## Prerequisites

### System Requirements

| Component  | Minimum                   | Recommended              |
| ---------- | ------------------------- | ------------------------ |
| CPU        | 4 cores                   | 8+ cores                 |
| RAM        | 8 GB                      | 16+ GB                   |
| Disk Space | 20 GB                     | 50+ GB                   |
| OS         | Linux, macOS, Windows 10+ | Ubuntu 20.04+, macOS 12+ |

### Required Software

| Software       | Version | Purpose                       | Installation Check         |
| -------------- | ------- | ----------------------------- | -------------------------- |
| Docker         | 20.10+  | Container runtime             | `docker --version`         |
| Docker Compose | 2.0+    | Multi-container orchestration | `docker-compose --version` |
| Java           | 17+     | Backend services              | `java -version`            |
| Maven          | 3.6+    | Backend build tool            | `mvn -version`             |
| Node.js        | 16+     | Frontend build                | `node --version`           |
| npm            | 8+      | Package manager               | `npm --version`            |
| Python         | 3.8+    | AI services                   | `python3 --version`        |
| Git            | 2.30+   | Version control               | `git --version`            |

### Optional Software

| Software             | Version | Purpose                  |
| -------------------- | ------- | ------------------------ |
| Kubernetes (kubectl) | 1.25+   | Production orchestration |
| Terraform            | 1.3+    | Infrastructure as code   |
| Ansible              | 2.12+   | Configuration management |

## Installation Options

FinovaBank can be installed in multiple ways:

1. **Docker Compose** (Recommended for development and testing)
2. **Manual Installation** (For development without Docker)
3. **Kubernetes** (For production deployment)
4. **Cloud Deployment** (AWS, Azure, GCP with Terraform)

## Quick Install with Docker Compose

This is the fastest way to get FinovaBank running.

### Step 1: Clone Repository

```bash
git clone https://github.com/abrar2030/FinovaBank.git
cd FinovaBank
```

### Step 2: Configure Environment

```bash
# Copy example environment file
cp .env.example .env

# Edit .env with your settings (optional for local development)
nano .env
```

### Step 3: Start Services

```bash
# Start all services in detached mode
docker-compose up -d

# View logs
docker-compose logs -f

# Check service status
docker-compose ps
```

### Step 4: Wait for Services to Start

Services start in dependency order:

1. Eureka Server (8001) - ~30 seconds
2. API Gateway (8002) - ~45 seconds
3. Backend Microservices (8011-8090) - ~60 seconds
4. Frontend Applications (3000, 8081) - ~30 seconds

```bash
# Monitor health status
watch -n 2 'docker-compose ps'
```

## Manual Local Development Setup

For developers who want to run services locally without Docker.

### Step 1: Install Prerequisites

#### On Ubuntu/Debian

```bash
# Update package list
sudo apt update

# Install Java 17
sudo apt install openjdk-17-jdk maven

# Install Node.js 16+
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs

# Install Python 3.8+
sudo apt install python3 python3-pip

# Install PostgreSQL
sudo apt install postgresql postgresql-contrib

# Install Redis
sudo apt install redis-server
```

#### On macOS

```bash
# Using Homebrew
brew install openjdk@17 maven node python@3.10 postgresql redis

# Link Java
sudo ln -sfn /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-17.jdk
```

#### On Windows

Use Windows Subsystem for Linux (WSL2) or install manually:

- Java: https://adoptium.net/
- Maven: https://maven.apache.org/download.cgi
- Node.js: https://nodejs.org/
- Python: https://www.python.org/downloads/
- PostgreSQL: https://www.postgresql.org/download/windows/
- Redis: https://github.com/microsoftarchive/redis/releases

### Step 2: Setup Databases

```bash
# Start PostgreSQL
sudo systemctl start postgresql

# Create database and user
sudo -u postgres psql
```

```sql
CREATE DATABASE finovabank_auth;
CREATE DATABASE finovabank_accounts;
CREATE DATABASE finovabank_transactions;
CREATE DATABASE finovabank_loans;
CREATE USER finova_user WITH PASSWORD 'finova_password';
GRANT ALL PRIVILEGES ON DATABASE finovabank_auth TO finova_user;
GRANT ALL PRIVILEGES ON DATABASE finovabank_accounts TO finova_user;
GRANT ALL PRIVILEGES ON DATABASE finovabank_transactions TO finova_user;
GRANT ALL PRIVILEGES ON DATABASE finovabank_loans TO finova_user;
\q
```

```bash
# Start Redis
sudo systemctl start redis
```

### Step 3: Build Backend Services

```bash
cd backend

# Build all modules
mvn clean install -DskipTests

# Or build individual services
cd eureka-server && mvn clean install && cd ..
cd api-gateway && mvn clean install && cd ..
cd auth-service && mvn clean install && cd ..
```

### Step 4: Build Frontend Applications

```bash
# Web Frontend
cd web-frontend
npm install
npm run build

# Mobile Frontend (for development)
cd ../mobile-frontend
npm install
```

### Step 5: Setup AI Service

```bash
cd backend/ai-service
pip install -r requirements.txt
```

### Step 6: Start Services

Start services in order using the provided scripts:

```bash
# From project root
./scripts/finovabank.sh setup    # Initial setup
./scripts/finovabank.sh start    # Start all services
```

Or start individually:

```bash
# Terminal 1: Eureka Server
cd backend/eureka-server
mvn spring-boot:run

# Terminal 2: API Gateway
cd backend/api-gateway
mvn spring-boot:run

# Terminal 3: Auth Service
cd backend/auth-service
mvn spring-boot:run

# Terminal 4: AI Service
cd backend/ai-service
python src/main.py

# Terminal 5: Web Frontend
cd web-frontend
npm start
```

## Production Deployment

### Kubernetes Deployment

#### Prerequisites

- Kubernetes cluster (1.25+)
- kubectl configured
- Docker images pushed to registry

#### Deploy with Helm

```bash
cd infrastructure/kubernetes

# Review values
cat values.yaml

# Install Helm chart
helm install finovabank . \
  --namespace finovabank \
  --create-namespace \
  --values values.yaml

# Check deployment
kubectl get pods -n finovabank
```

#### Deploy with kubectl

```bash
# Apply all manifests
kubectl apply -f infrastructure/kubernetes/templates/

# Check status
kubectl get all -n finovabank
```

#### Use Automated Script

```bash
chmod +x scripts/kubernetes-auto-deploy.sh
./scripts/kubernetes-auto-deploy.sh
```

### Cloud Deployment (AWS)

```bash
cd infrastructure/terraform

# Initialize Terraform
terraform init

# Plan deployment
terraform plan -out=tfplan

# Apply infrastructure
terraform apply tfplan

# Get outputs
terraform output
```

## Platform-Specific Instructions

### Installation by Operating System

| OS / Platform          | Recommended Install Method | Notes                                    |
| ---------------------- | -------------------------- | ---------------------------------------- |
| Ubuntu 20.04+          | Docker Compose or Manual   | Best support, recommended for production |
| Ubuntu 22.04+          | Docker Compose or Manual   | Fully tested                             |
| Debian 11+             | Docker Compose             | Compatible with Ubuntu instructions      |
| macOS 12+              | Docker Compose             | Use Homebrew for dependencies            |
| macOS on Apple Silicon | Docker Compose             | ARM64 images available                   |
| Windows 10+            | Docker Desktop + WSL2      | Use WSL2 for best performance            |
| Red Hat / CentOS 8+    | Docker Compose             | Use dnf instead of apt                   |
| Kubernetes             | Helm Chart                 | Production deployment                    |
| AWS EKS                | Terraform + Helm           | Automated cloud deployment               |

## Verification

### Check Service Health

```bash
# Check all services are running
docker-compose ps

# Expected output: All services should show "Up" status
```

### Access Web Interfaces

| Service          | URL                   | Credentials (Default) |
| ---------------- | --------------------- | --------------------- |
| Web UI           | http://localhost:3000 | Register new account  |
| API Gateway      | http://localhost:8002 | N/A (API only)        |
| Eureka Dashboard | http://localhost:8001 | No auth required      |
| Grafana          | http://localhost:3001 | admin / admin         |
| Prometheus       | http://localhost:9090 | No auth required      |

### Test API Endpoints

```bash
# Health check
curl http://localhost:8002/actuator/health

# Register a test user
curl -X POST http://localhost:8002/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com",
    "password": "Test123!",
    "firstName": "Test",
    "lastName": "User"
  }'

# Login
curl -X POST http://localhost:8002/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "password": "Test123!"
  }'
```

### View Logs

```bash
# All services
docker-compose logs

# Specific service
docker-compose logs api-gateway

# Follow logs in real-time
docker-compose logs -f auth-service

# Last 100 lines
docker-compose logs --tail=100
```

### Common Installation Issues

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for detailed solutions to common installation problems.

## Next Steps

After successful installation:

1. Read [USAGE.md](USAGE.md) for usage instructions
2. Explore [API.md](API.md) for API documentation
3. Review [CONFIGURATION.md](CONFIGURATION.md) for configuration options
4. Check [EXAMPLES/](examples/) for code examples

## Upgrading

To upgrade to a newer version:

```bash
# Stop services
docker-compose down

# Pull latest code
git pull origin main

# Rebuild images
docker-compose build --no-cache

# Start services
docker-compose up -d

# Run database migrations if needed
./scripts/finovabank_db.sh migrate
```

## Uninstallation

```bash
# Stop and remove containers
docker-compose down

# Remove volumes (WARNING: This deletes all data)
docker-compose down -v

# Remove images
docker-compose down --rmi all

# Clean up local builds
./scripts/finovabank.sh clean
```
