# Troubleshooting Guide

Common issues and solutions for FinovaBank.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Service Startup Issues](#service-startup-issues)
- [Database Issues](#database-issues)
- [Authentication Issues](#authentication-issues)
- [API Issues](#api-issues)
- [Frontend Issues](#frontend-issues)
- [Docker/Kubernetes Issues](#dockerkubernetes-issues)
- [Performance Issues](#performance-issues)

## Installation Issues

### Maven Build Fails

**Problem:** `mvn clean install` fails with dependency errors

**Solutions:**

```bash
# Clean Maven cache
rm -rf ~/.m2/repository

# Rebuild with force update
mvn clean install -U

# Skip tests if needed
mvn clean install -DskipTests
```

### Node Modules Installation Fails

**Problem:** `npm install` fails with permission errors

**Solutions:**

```bash
# On Linux/Mac - fix permissions
sudo chown -R $USER:$USER ~/.npm

# Clear npm cache
npm cache clean --force

# Use specific Node version (via nvm)
nvm install 18
nvm use 18
npm install
```

### Docker Build Fails

**Problem:** Docker build fails with network or layer errors

**Solutions:**

```bash
# Clear Docker cache
docker system prune -a

# Build with no cache
docker-compose build --no-cache

# Check Docker disk space
docker system df
```

## Service Startup Issues

### Eureka Server Won't Start

**Problem:** Eureka server fails on port 8001

**Check:**

```bash
# Check if port is in use
lsof -ti:8001
# Or on Windows
netstat -ano | findstr :8001

# Kill process using port
kill -9 $(lsof -ti:8001)
# Or on Windows
taskkill /PID <PID> /F
```

**Solutions:**

- Change port in `application.yml` and environment variables
- Ensure no other Eureka instance is running

### Service Can't Register with Eureka

**Problem:** Services show as DOWN in Eureka dashboard

**Check:**

```bash
# Verify Eureka is running
curl http://localhost:8001/eureka/apps

# Check service logs
docker-compose logs eureka-server
docker-compose logs api-gateway
```

**Solutions:**

1. Verify `EUREKA_SERVER_URL` in each service
2. Ensure network connectivity between containers
3. Wait 30-60 seconds for initial registration
4. Check `eureka.client.register-with-eureka=true`

### API Gateway Returns 503

**Problem:** Gateway returns "Service Unavailable"

**Causes:**

- Target service not registered in Eureka
- Service is DOWN
- Network issues

**Solutions:**

```bash
# Check Eureka dashboard
http://localhost:8001

# Verify service health
curl http://localhost:8011/actuator/health  # Auth service
curl http://localhost:8081/actuator/health  # Account service

# Restart services in order
docker-compose restart eureka-server
docker-compose restart api-gateway
docker-compose restart auth-service
```

## Database Issues

### Connection Refused

**Problem:** `Connection refused` or `Could not connect to database`

**Solutions:**

```bash
# Check PostgreSQL is running
docker-compose ps postgres
# Or if running locally
sudo systemctl status postgresql

# Verify connection parameters
echo $DB_URL
echo $DB_USERNAME

# Test connection
psql -h localhost -U finova_user -d finovabank
```

### Database Initialization Fails

**Problem:** Tables not created or migrations fail

**Solutions:**

```bash
# Manually initialize databases
./scripts/finovabank_db.sh init

# Check Flyway migration status
./scripts/finovabank_db.sh status

# Force migration
./scripts/finovabank_db.sh migrate --force
```

### Too Many Connections

**Problem:** `FATAL: too many connections`

**Solutions:**

1. Increase PostgreSQL max_connections
2. Reduce HikariCP pool sizes
3. Check for connection leaks

```yaml
# application.yml
spring:
  datasource:
    hikari:
      maximum-pool-size: 10 # Reduce from 20
      minimum-idle: 2
```

## Authentication Issues

### JWT Token Invalid

**Problem:** `401 Unauthorized` or "Invalid JWT token"

**Causes:**

- Token expired
- Wrong JWT_SECRET
- Token format invalid

**Solutions:**

1. Refresh token using `/api/auth/refresh`
2. Verify JWT_SECRET is same across services
3. Check token expiration time

```bash
# Decode JWT (online or use jwt-cli)
# Check exp (expiration) claim

# Get new token
curl -X POST http://localhost:8002/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user","password":"pass"}'
```

### Login Fails with Correct Credentials

**Problem:** Login returns 401 despite correct password

**Check:**

```bash
# Verify user exists in database
psql -U finova_user -d finovabank_auth
SELECT * FROM users WHERE username = 'testuser';

# Check password encoding
SELECT password_hash FROM users WHERE username = 'testuser';
```

**Solutions:**

1. Ensure BCrypt encoding is used
2. Check password length (>8 chars)
3. Verify user account is active

### Session Expired Too Quickly

**Problem:** Users logged out after short time

**Solution:**

```yaml
# Increase token expiration in application.yml
app:
  jwt:
    access-token-expiration: 7200 # 2 hours instead of 1
    refresh-token-expiration: 172800 # 2 days
```

## API Issues

### CORS Errors

**Problem:** Browser console shows CORS error

**Solutions:**

```yaml
# Update API Gateway SecurityConfig
spring:
  security:
    cors:
      allowed-origins: "http://localhost:3000"
      allowed-methods: GET,POST,PUT,DELETE
      allowed-headers: "*"
      allow-credentials: true
```

### Rate Limit Exceeded

**Problem:** `429 Too Many Requests`

**Solutions:**

1. Implement exponential backoff
2. Request rate limit increase
3. Use batch APIs where available

```javascript
// Exponential backoff example
async function fetchWithRetry(url, options, maxRetries = 3) {
  for (let i = 0; i < maxRetries; i++) {
    try {
      const response = await fetch(url, options);
      if (response.status !== 429) return response;
      await new Promise((resolve) =>
        setTimeout(resolve, Math.pow(2, i) * 1000),
      );
    } catch (error) {
      if (i === maxRetries - 1) throw error;
    }
  }
}
```

### API Returns 500 Error

**Problem:** Internal server error

**Debug Steps:**

```bash
# Check service logs
docker-compose logs service-name

# Check Actuator health
curl http://localhost:PORT/actuator/health

# Enable debug logging
export LOG_LEVEL=DEBUG
./scripts/finovabank.sh restart service-name
```

## Frontend Issues

### Web App Won't Load

**Problem:** White screen or `ERR_CONNECTION_REFUSED`

**Solutions:**

```bash
# Check if frontend is running
curl http://localhost:3000

# Rebuild frontend
cd web-frontend
rm -rf node_modules build
npm install
npm run build
npm start

# Check API Gateway is accessible
curl http://localhost:8002/actuator/health
```

### API Calls Fail from Frontend

**Problem:** Network errors in browser console

**Check:**

1. Browser console for details
2. Network tab for request/response
3. API Gateway logs

**Solutions:**

```javascript
// Update .env file
REACT_APP_API_BASE_URL=http://localhost:8002

// Or if using Docker
REACT_APP_API_BASE_URL=http://api-gateway:8002
```

### Mobile App Build Fails

**Problem:** React Native build fails

**Solutions:**

```bash
# iOS
cd mobile-frontend/ios
pod deintegrate
pod install
cd ..
npm run ios

# Android
cd mobile-frontend/android
./gradlew clean
cd ..
npm run android

# Clear Metro cache
npm start -- --reset-cache
```

## Docker/Kubernetes Issues

### Container Keeps Restarting

**Problem:** Service restarts continuously

**Debug:**

```bash
# Check container logs
docker-compose logs service-name

# Check container status
docker-compose ps

# Inspect container
docker inspect container-name

# Check resource limits
docker stats
```

**Common Causes:**

1. Application crash on startup
2. Out of memory
3. Failed health check
4. Missing environment variables

### Out of Disk Space

**Problem:** `no space left on device`

**Solutions:**

```bash
# Check Docker disk usage
docker system df

# Clean up
docker system prune -a --volumes

# Remove unused images
docker image prune -a

# Remove unused volumes
docker volume prune
```

### Kubernetes Pod Not Starting

**Problem:** Pod stuck in Pending/CrashLoopBackOff

**Debug:**

```bash
# Describe pod
kubectl describe pod pod-name -n finovabank

# Check logs
kubectl logs pod-name -n finovabank

# Check events
kubectl get events -n finovabank --sort-by='.lastTimestamp'
```

**Solutions:**

1. Check resource quotas
2. Verify image pull secrets
3. Check persistent volume claims
4. Review pod security policies

## Performance Issues

### Slow API Response

**Problem:** API calls take >2 seconds

**Debug:**

```bash
# Check database query performance
# Enable SQL logging
spring.jpa.show-sql=true

# Check database connections
SELECT count(*) FROM pg_stat_activity;

# Profile with Spring Actuator
curl http://localhost:PORT/actuator/metrics
```

**Optimizations:**

1. Add database indexes
2. Implement caching
3. Use pagination
4. Optimize N+1 queries

```java
// Use @EntityGraph to fetch associations
@EntityGraph(attributePaths = {"transactions"})
Account findByAccountNumber(String accountNumber);
```

### High Memory Usage

**Problem:** Service using too much memory

**Solutions:**

```bash
# Adjust JVM heap size
JAVA_OPTS="-Xmx512m -Xms256m"

# Enable GC logging
JAVA_OPTS="$JAVA_OPTS -XX:+PrintGCDetails"

# Profile with VisualVM or JProfiler
```

### Database Connection Pool Exhausted

**Problem:** `Cannot get connection from pool`

**Solutions:**

```yaml
# Increase pool size
spring:
  datasource:
    hikari:
      maximum-pool-size: 30
      minimum-idle: 10

# Decrease connection timeout
connection-timeout: 20000
```

## Common Error Messages

| Error                    | Cause                  | Solution                    |
| ------------------------ | ---------------------- | --------------------------- |
| `Address already in use` | Port conflict          | Kill process or change port |
| `Connection refused`     | Service not running    | Start service               |
| `Unauthorized`           | Missing/invalid token  | Login again                 |
| `Service Unavailable`    | Service not registered | Check Eureka                |
| `Too many connections`   | DB pool exhausted      | Increase pool size          |
| `OutOfMemoryError`       | Insufficient heap      | Increase -Xmx               |
| `ClassNotFoundException` | Missing dependency     | Check pom.xml/build         |
| `Cannot resolve symbol`  | IDE index issue        | Invalidate caches           |

## Getting Help

If issues persist:

1. **Check logs** - Always check service logs first
2. **Search GitHub Issues** - Someone may have reported it
3. **Create Issue** - Provide logs, steps to reproduce
4. **Ask Community** - Use Discussions for questions

### Creating a Good Bug Report

Include:

- **Environment** (OS, Java version, Docker version)
- **Steps to reproduce**
- **Expected behavior**
- **Actual behavior**
- **Logs** (relevant portions)
- **Configuration** (anonymize secrets)

### Useful Debug Commands

```bash
# Check service health
curl http://localhost:PORT/actuator/health

# Check service info
curl http://localhost:PORT/actuator/info

# Check metrics
curl http://localhost:PORT/actuator/metrics

# Test connectivity
telnet localhost PORT

# Check DNS resolution
nslookup service-name

# Verify environment variables
docker-compose config

# Check Java version
java -version

# Check Maven version
mvn -version

# Check Node version
node -v && npm -v
```

## Preventive Measures

1. **Regular Updates** - Keep dependencies updated
2. **Monitoring** - Use Prometheus/Grafana
3. **Logging** - Centralize logs for analysis
4. **Backups** - Regular database backups
5. **Testing** - Comprehensive test coverage
6. **Documentation** - Keep docs updated

## See Also

- [INSTALLATION.md](INSTALLATION.md) - Installation guide
- [CONFIGURATION.md](CONFIGURATION.md) - Configuration options
- [CLI.md](CLI.md) - CLI commands
- [CONTRIBUTING.md](CONTRIBUTING.md) - Development guide
