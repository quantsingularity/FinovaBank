# CLI Reference

Command-line interface reference for FinovaBank management scripts and tools.

## Table of Contents

- [Main Management Script](#main-management-script)
- [Database Management](#database-management)
- [Service Management](#service-management)
- [Deployment Scripts](#deployment-scripts)
- [Testing Scripts](#testing-scripts)
- [Monitoring Scripts](#monitoring-scripts)
- [Docker Management](#docker-management)

## Main Management Script

Script: `scripts/finovabank.sh`

### Usage

```bash
./scripts/finovabank.sh [COMMAND] [OPTIONS]
```

### Commands

| Command       | Arguments      | Description                            | Example                                     |
| ------------- | -------------- | -------------------------------------- | ------------------------------------------- |
| setup         | -              | Initialize and setup the environment   | `./scripts/finovabank.sh setup`             |
| start         | [service-name] | Start all services or specific service | `./scripts/finovabank.sh start`             |
| stop          | [service-name] | Stop all services or specific service  | `./scripts/finovabank.sh stop auth-service` |
| restart       | [service-name] | Restart all or specific service        | `./scripts/finovabank.sh restart`           |
| status        | -              | Check status of all services           | `./scripts/finovabank.sh status`            |
| logs          | [service-name] | View logs for all or specific service  | `./scripts/finovabank.sh logs api-gateway`  |
| test          | -              | Run all tests                          | `./scripts/finovabank.sh test`              |
| clean         | -              | Clean build artifacts and logs         | `./scripts/finovabank.sh clean`             |
| build         | -              | Build all services                     | `./scripts/finovabank.sh build`             |
| deploy        | [environment]  | Deploy to environment                  | `./scripts/finovabank.sh deploy staging`    |
| --help, -h    | -              | Show help message                      | `./scripts/finovabank.sh --help`            |
| --version, -v | -              | Show version information               | `./scripts/finovabank.sh --version`         |

### Examples

#### Setup and Start

```bash
# Initial setup (first time)
./scripts/finovabank.sh setup

# Start all services
./scripts/finovabank.sh start

# Wait for services to be ready
# Check status
./scripts/finovabank.sh status
```

#### Service Management

```bash
# Start specific service
./scripts/finovabank.sh start auth-service

# Stop specific service
./scripts/finovabank.sh stop transaction-service

# Restart API gateway
./scripts/finovabank.sh restart api-gateway

# View logs for eureka server
./scripts/finovabank.sh logs eureka-server

# View logs with follow mode
./scripts/finovabank.sh logs --follow notification-service
```

#### Build and Clean

```bash
# Build all services
./scripts/finovabank.sh build

# Clean artifacts
./scripts/finovabank.sh clean

# Clean and rebuild
./scripts/finovabank.sh clean && ./scripts/finovabank.sh build
```

### Service Names

Valid service names for commands:

- `eureka-server` - Service discovery server (port 8001)
- `api-gateway` - API Gateway (port 8002)
- `auth-service` - Authentication service (port 8011)
- `security-service` - Security service (port 8089)
- `account-management` - Account management (port 8081)
- `transaction-service` - Transaction service (port 8082)
- `notification-service` - Notification service (port 8083)
- `loan-management` - Loan management (port 8084)
- `compliance-service` - Compliance service (port 8085)
- `reporting` - Reporting service (port 8086)
- `risk-assessment` - Risk assessment service (port 8087)
- `savings-goals` - Savings goals service (port 8088)
- `ai-service` - AI service (port 8090)

### Environment Variables

Script can be configured via environment variables:

```bash
# Set custom ports
export EUREKA_PORT=8001
export GATEWAY_PORT=8002

# Set Java options
export JAVA_OPTS="-Xmx512m -Xms256m"

# Set log level
export LOG_LEVEL=DEBUG

# Run with custom config
./scripts/finovabank.sh start
```

## Database Management

Script: `scripts/finovabank_db.sh`

### Commands

| Command  | Arguments     | Description                     | Example                                         |
| -------- | ------------- | ------------------------------- | ----------------------------------------------- |
| init     | -             | Initialize all databases        | `./scripts/finovabank_db.sh init`               |
| migrate  | [service]     | Run database migrations         | `./scripts/finovabank_db.sh migrate`            |
| rollback | [version]     | Rollback to specific version    | `./scripts/finovabank_db.sh rollback 001`       |
| seed     | [dataset]     | Seed test data                  | `./scripts/finovabank_db.sh seed dev`           |
| backup   | [output-file] | Backup all databases            | `./scripts/finovabank_db.sh backup backup.sql`  |
| restore  | <backup-file> | Restore from backup             | `./scripts/finovabank_db.sh restore backup.sql` |
| clean    | -             | Clean all database data         | `./scripts/finovabank_db.sh clean`              |
| status   | -             | Show database connection status | `./scripts/finovabank_db.sh status`             |

### Examples

#### Initialize and Setup

```bash
# Initialize databases
./scripts/finovabank_db.sh init

# Run migrations
./scripts/finovabank_db.sh migrate

# Seed development data
./scripts/finovabank_db.sh seed dev
```

#### Backup and Restore

```bash
# Create backup
./scripts/finovabank_db.sh backup /backups/finovabank_$(date +%Y%m%d).sql

# Restore from backup
./scripts/finovabank_db.sh restore /backups/finovabank_20251230.sql

# Verify
./scripts/finovabank_db.sh status
```

#### Migration Management

```bash
# Run all pending migrations
./scripts/finovabank_db.sh migrate

# Migrate specific service
./scripts/finovabank_db.sh migrate auth-service

# Rollback last migration
./scripts/finovabank_db.sh rollback

# Rollback to specific version
./scripts/finovabank_db.sh rollback 005
```

### Configuration

Database configuration via environment variables:

```bash
# PostgreSQL settings
export DB_HOST=localhost
export DB_PORT=5432
export DB_USERNAME=finova_user
export DB_PASSWORD=finova_password

# MongoDB settings (if using)
export MONGO_HOST=localhost
export MONGO_PORT=27017
export MONGO_DB=finovabank

# Redis settings
export REDIS_HOST=localhost
export REDIS_PORT=6379
```

## Service Management

Script: `scripts/manage-services.sh`

### Commands

| Command | Arguments              | Description             | Example                                              |
| ------- | ---------------------- | ----------------------- | ---------------------------------------------------- |
| start   | <service-name>         | Start specific service  | `./scripts/manage-services.sh start auth-service`    |
| stop    | <service-name>         | Stop specific service   | `./scripts/manage-services.sh stop api-gateway`      |
| restart | <service-name>         | Restart service         | `./scripts/manage-services.sh restart eureka-server` |
| status  | [service-name]         | Show service status     | `./scripts/manage-services.sh status`                |
| logs    | <service-name> [lines] | Show service logs       | `./scripts/manage-services.sh logs auth-service 100` |
| health  | [service-name]         | Check health endpoints  | `./scripts/manage-services.sh health`                |
| scale   | <service-name> <count> | Scale service instances | `./scripts/manage-services.sh scale api-gateway 3`   |
| list    | -                      | List all services       | `./scripts/manage-services.sh list`                  |

### Examples

```bash
# Check health of all services
./scripts/manage-services.sh health

# Scale API gateway to 3 instances
./scripts/manage-services.sh scale api-gateway 3

# View last 50 lines of logs
./scripts/manage-services.sh logs transaction-service 50

# Check status of specific service
./scripts/manage-services.sh status auth-service
```

## Deployment Scripts

### Kubernetes Deployment

Script: `scripts/kubernetes-auto-deploy.sh`

#### Commands

```bash
# Deploy to Kubernetes
./scripts/kubernetes-auto-deploy.sh

# Deploy to specific namespace
./scripts/kubernetes-auto-deploy.sh --namespace production

# Check deployment status
./scripts/kubernetes-auto-deploy.sh status

# Rollback deployment
./scripts/kubernetes-auto-deploy.sh rollback

# Delete deployment
./scripts/kubernetes-auto-deploy.sh delete
```

#### Options

| Flag            | Description                 | Example               |
| --------------- | --------------------------- | --------------------- |
| --namespace, -n | Target namespace            | `--namespace staging` |
| --dry-run       | Preview without applying    | `--dry-run`           |
| --verbose, -v   | Verbose output              | `--verbose`           |
| --wait          | Wait for rollout completion | `--wait`              |
| --timeout       | Timeout for operations      | `--timeout 300`       |

### Docker Deployment

Script: `scripts/docker-build-and-compose.sh`

```bash
# Build all Docker images
./scripts/docker-build-and-compose.sh

# Build specific service
./scripts/docker-build-and-compose.sh auth-service

# Build and push to registry
./scripts/docker-build-and-compose.sh --push

# Build with no cache
./scripts/docker-build-and-compose.sh --no-cache
```

### Deploy Script

Script: `scripts/finovabank_deploy.sh`

```bash
# Deploy to development
./scripts/finovabank_deploy.sh dev

# Deploy to staging
./scripts/finovabank_deploy.sh staging

# Deploy to production (requires confirmation)
./scripts/finovabank_deploy.sh production

# Deploy with specific version
./scripts/finovabank_deploy.sh staging --version 1.2.3

# Rollback deployment
./scripts/finovabank_deploy.sh staging --rollback
```

## Testing Scripts

Script: `scripts/finovabank_test.sh`

### Commands

| Command     | Description              | Example                                    |
| ----------- | ------------------------ | ------------------------------------------ |
| unit        | Run unit tests           | `./scripts/finovabank_test.sh unit`        |
| integration | Run integration tests    | `./scripts/finovabank_test.sh integration` |
| e2e         | Run end-to-end tests     | `./scripts/finovabank_test.sh e2e`         |
| all         | Run all tests            | `./scripts/finovabank_test.sh all`         |
| coverage    | Generate coverage report | `./scripts/finovabank_test.sh coverage`    |
| performance | Run performance tests    | `./scripts/finovabank_test.sh performance` |
| security    | Run security scans       | `./scripts/finovabank_test.sh security`    |

### Run All Tests Script

Script: `scripts/run_all_tests.sh`

```bash
# Run all tests for all modules
./scripts/run_all_tests.sh

# Run tests with coverage
./scripts/run_all_tests.sh --coverage

# Run tests for specific module
./scripts/run_all_tests.sh --module auth-service

# Generate HTML report
./scripts/run_all_tests.sh --report
```

### Examples

```bash
# Run unit tests only
./scripts/finovabank_test.sh unit

# Run integration tests with verbose output
./scripts/finovabank_test.sh integration --verbose

# Generate coverage report
./scripts/finovabank_test.sh coverage

# Run tests and open report
./scripts/finovabank_test.sh all --open-report

# Run security scan
./scripts/finovabank_test.sh security
```

## Monitoring Scripts

Script: `scripts/finovabank_monitoring.sh`

### Commands

| Command   | Description               | Example                                        |
| --------- | ------------------------- | ---------------------------------------------- |
| setup     | Setup monitoring stack    | `./scripts/finovabank_monitoring.sh setup`     |
| start     | Start monitoring services | `./scripts/finovabank_monitoring.sh start`     |
| stop      | Stop monitoring services  | `./scripts/finovabank_monitoring.sh stop`      |
| status    | Check monitoring status   | `./scripts/finovabank_monitoring.sh status`    |
| logs      | View monitoring logs      | `./scripts/finovabank_monitoring.sh logs`      |
| dashboard | Open Grafana dashboard    | `./scripts/finovabank_monitoring.sh dashboard` |
| metrics   | View metrics summary      | `./scripts/finovabank_monitoring.sh metrics`   |
| alerts    | View active alerts        | `./scripts/finovabank_monitoring.sh alerts`    |

### Examples

```bash
# Setup monitoring
./scripts/finovabank_monitoring.sh setup

# Start Prometheus and Grafana
./scripts/finovabank_monitoring.sh start

# Open Grafana dashboard
./scripts/finovabank_monitoring.sh dashboard

# View current metrics
./scripts/finovabank_monitoring.sh metrics

# Check for alerts
./scripts/finovabank_monitoring.sh alerts
```

### Monitoring URLs

After starting monitoring:

- Prometheus: http://localhost:9090
- Grafana: http://localhost:3001 (admin/admin)
- AlertManager: http://localhost:9093

## Docker Management

### Docker Auto Build and Push

Script: `scripts/docker-auto-build-push.sh`

```bash
# Build all images
./scripts/docker-auto-build-push.sh

# Build and push to Docker Hub
./scripts/docker-auto-build-push.sh --push

# Build with custom tag
./scripts/docker-auto-build-push.sh --tag v1.2.3

# Push to custom registry
./scripts/docker-auto-build-push.sh --registry registry.example.com --push
```

### Docker Compose Management

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# Scale service
docker-compose up -d --scale api-gateway=3

# Rebuild and restart
docker-compose up -d --build

# Remove volumes
docker-compose down -v
```

## Global Options

Most scripts support these common options:

| Option        | Description                          |
| ------------- | ------------------------------------ |
| --help, -h    | Show help message                    |
| --version, -v | Show version                         |
| --verbose     | Enable verbose output                |
| --quiet, -q   | Suppress output                      |
| --dry-run     | Preview without executing            |
| --force, -f   | Force operation without confirmation |
| --config FILE | Use custom config file               |

## Script Exit Codes

| Code | Meaning             |
| ---- | ------------------- |
| 0    | Success             |
| 1    | General error       |
| 2    | Misuse of command   |
| 3    | Service not found   |
| 4    | Configuration error |
| 5    | Connection error    |
| 10   | Permission denied   |

## Environment Files

Scripts can load configuration from:

1. `/etc/finovabank/config.sh` - System-wide config
2. `~/.finovabank/config.sh` - User config
3. `.env` - Project root environment file
4. Environment variables

Priority: Environment variables > .env > User config > System config

## Troubleshooting CLI Issues

### Script Permission Denied

```bash
# Make scripts executable
chmod +x scripts/*.sh

# Or run with bash
bash scripts/finovabank.sh start
```

### Command Not Found

```bash
# Ensure you're in project root
cd /path/to/FinovaBank

# Use relative path
./scripts/finovabank.sh start
```

### Service Won't Start

```bash
# Check logs
./scripts/finovabank.sh logs service-name

# Check port availability
./scripts/finovabank.sh status

# Kill conflicting process
lsof -ti:8002 | xargs kill -9
```

## Advanced Usage

### Chaining Commands

```bash
# Clean, build, and start
./scripts/finovabank.sh clean && \
./scripts/finovabank.sh build && \
./scripts/finovabank.sh start
```

### Running in Background

```bash
# Start services in background
nohup ./scripts/finovabank.sh start > startup.log 2>&1 &

# Check progress
tail -f startup.log
```

### Custom Configuration

```bash
# Use custom ports
EUREKA_PORT=9001 GATEWAY_PORT=9002 ./scripts/finovabank.sh start

# Load custom env file
source custom.env && ./scripts/finovabank.sh start
```

## See Also

- [USAGE.md](USAGE.md) - Application usage guide
- [CONFIGURATION.md](CONFIGURATION.md) - Configuration reference
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Troubleshooting guide
- [EXAMPLES/](examples/) - Example scripts
