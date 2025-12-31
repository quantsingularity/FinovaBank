# Configuration Reference

Complete configuration guide for FinovaBank services.

## Table of Contents

- [Environment Variables](#environment-variables)
- [Application Configuration Files](#application-configuration-files)
- [Service-Specific Configuration](#service-specific-configuration)
- [Database Configuration](#database-configuration)
- [Security Configuration](#security-configuration)
- [Monitoring Configuration](#monitoring-configuration)

## Environment Variables

### Core System Variables

| Option                 | Type   | Default    | Description                               | Where to set |
| ---------------------- | ------ | ---------- | ----------------------------------------- | ------------ |
| SPRING_PROFILES_ACTIVE | string | dev        | Active Spring profile (dev, docker, prod) | env/file     |
| JAVA_OPTS              | string | "-Xmx512m" | JVM options for Java services             | env          |
| LOG_LEVEL              | string | INFO       | Logging level (DEBUG, INFO, WARN, ERROR)  | env/file     |
| TZ                     | string | UTC        | Timezone for all services                 | env          |

### Service Discovery (Eureka)

| Option                   | Type    | Default                       | Description        | Where to set |
| ------------------------ | ------- | ----------------------------- | ------------------ | ------------ |
| EUREKA_SERVER_URL        | string  | http://localhost:8001/eureka/ | Eureka server URL  | env/file     |
| EUREKA_SERVER_PORT       | integer | 8001                          | Eureka server port | env/file     |
| EUREKA_INSTANCE_HOSTNAME | string  | localhost                     | Instance hostname  | env/file     |

### API Gateway

| Option              | Type    | Default  | Description                               | Where to set |
| ------------------- | ------- | -------- | ----------------------------------------- | ------------ |
| API_GATEWAY_PORT    | integer | 8002     | API Gateway port                          | env/file     |
| JWT_SECRET          | string  | changeme | JWT signing secret (CHANGE IN PRODUCTION) | env/file     |
| JWT_EXPIRATION_TIME | integer | 3600000  | JWT expiration (ms)                       | env/file     |

### Authentication Service

| Option                   | Type    | Default    | Description                      | Where to set |
| ------------------------ | ------- | ---------- | -------------------------------- | ------------ |
| AUTH_SERVICE_PORT        | integer | 8011       | Auth service port                | env/file     |
| JWT_SECRET               | string  | (required) | JWT secret key                   | env/file     |
| ACCESS_TOKEN_EXPIRATION  | integer | 3600       | Access token lifetime (seconds)  | env/file     |
| REFRESH_TOKEN_EXPIRATION | integer | 86400      | Refresh token lifetime (seconds) | env/file     |

### Database Configuration

| Option           | Type    | Default                                     | Description              | Where to set |
| ---------------- | ------- | ------------------------------------------- | ------------------------ | ------------ |
| DB_URL           | string  | jdbc:postgresql://localhost:5432/finovabank | Database URL             | env/file     |
| DB_USERNAME      | string  | finova_user                                 | Database username        | env/file     |
| DB_PASSWORD      | string  | finova_password                             | Database password        | env/file     |
| DB_DRIVER        | string  | org.postgresql.Driver                       | JDBC driver class        | env/file     |
| DB_MAX_POOL_SIZE | integer | 20                                          | Max connection pool size | env/file     |

### Redis Configuration

| Option         | Type    | Default   | Description               | Where to set |
| -------------- | ------- | --------- | ------------------------- | ------------ |
| REDIS_HOST     | string  | localhost | Redis server host         | env/file     |
| REDIS_PORT     | integer | 6379      | Redis server port         | env/file     |
| REDIS_PASSWORD | string  | null      | Redis password (optional) | env/file     |
| REDIS_TIMEOUT  | integer | 2000      | Connection timeout (ms)   | env/file     |

### Kafka Configuration

| Option                  | Type   | Default          | Description            | Where to set |
| ----------------------- | ------ | ---------------- | ---------------------- | ------------ |
| KAFKA_BOOTSTRAP_SERVERS | string | localhost:9092   | Kafka broker addresses | env/file     |
| KAFKA_GROUP_ID          | string | finovabank-group | Consumer group ID      | env/file     |
| KAFKA_AUTO_OFFSET_RESET | string | earliest         | Offset reset strategy  | env/file     |

### AI Service Configuration

| Option                  | Type    | Default                   | Description         | Where to set |
| ----------------------- | ------- | ------------------------- | ------------------- | ------------ |
| AI_SERVICE_PORT         | integer | 8090                      | AI service port     | env          |
| FLASK_ENV               | string  | production                | Flask environment   | env          |
| SQLALCHEMY_DATABASE_URI | string  | sqlite:///database/app.db | AI service database | env/file     |
| SECRET_KEY              | string  | (required)                | Flask secret key    | env/file     |

### Frontend Configuration

| Option                    | Type    | Default                | Description        | Where to set |
| ------------------------- | ------- | ---------------------- | ------------------ | ------------ |
| REACT_APP_API_BASE_URL    | string  | http://localhost:8002  | Backend API URL    | env/file     |
| REACT_APP_WS_URL          | string  | ws://localhost:8002/ws | WebSocket URL      | env/file     |
| PORT                      | integer | 3000                   | Web frontend port  | env          |
| REACT_NATIVE_API_BASE_URL | string  | http://localhost:8002  | API for mobile app | env          |

## Application Configuration Files

### Spring Boot YAML Configuration

Location: `backend/<service>/src/main/resources/application.yml`

Example configuration structure:

```yaml
server:
  port: 8080

spring:
  application:
    name: service-name
  datasource:
    url: ${DB_URL}
    username: ${DB_USERNAME}
    password: ${DB_PASSWORD}
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: false

eureka:
  client:
    service-url:
      defaultZone: ${EUREKA_SERVER_URL}

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
```

### Profile-Specific Configuration

- `application.yml` - Default configuration
- `application-dev.yml` - Development profile
- `application-docker.yml` - Docker profile
- `application-prod.yml` - Production profile

Activate via: `SPRING_PROFILES_ACTIVE=prod`

## Service-Specific Configuration

### Eureka Server

File: `backend/eureka-server/src/main/resources/application.yml`

```yaml
server:
  port: ${EUREKA_SERVER_PORT:8001}

spring:
  application:
    name: eureka-server

eureka:
  client:
    register-with-eureka: false
    fetch-registry: false
  server:
    enable-self-preservation: true
    eviction-interval-timer-in-ms: 60000
```

### API Gateway

File: `backend/api-gateway/src/main/resources/application.yml`

```yaml
server:
  port: ${API_GATEWAY_PORT:8002}

spring:
  application:
    name: api-gateway
  cloud:
    gateway:
      routes:
        - id: auth-service
          uri: lb://auth-service
          predicates:
            - Path=/api/auth/**

jwt:
  secret: ${JWT_SECRET}
  expiration-time: ${JWT_EXPIRATION_TIME:3600000}
```

### Account Management

File: `backend/account-management/src/main/resources/application.yml`

```yaml
server:
  port: ${ACCOUNT_MANAGEMENT_PORT:8081}

spring:
  application:
    name: account-management
  datasource:
    url: ${DB_URL:jdbc:postgresql://localhost:5432/finovabank_accounts}
```

## Database Configuration

### PostgreSQL Configuration

Environment variables:

```bash
# Main database
DB_URL=jdbc:postgresql://localhost:5432/finovabank
DB_USERNAME=finova_user
DB_PASSWORD=finova_password

# Per-service databases (optional)
AUTH_DB_URL=jdbc:postgresql://localhost:5432/finovabank_auth
ACCOUNTS_DB_URL=jdbc:postgresql://localhost:5432/finovabank_accounts
TRANSACTIONS_DB_URL=jdbc:postgresql://localhost:5432/finovabank_transactions
```

### Connection Pool Settings

```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 20 # Max connections
      minimum-idle: 5 # Min idle connections
      connection-timeout: 30000 # 30 seconds
      idle-timeout: 600000 # 10 minutes
      max-lifetime: 1800000 # 30 minutes
```

### JPA/Hibernate Configuration

```yaml
spring:
  jpa:
    hibernate:
      ddl-auto: update # Options: none, validate, update, create, create-drop
    show-sql: false # Log SQL queries
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
        format_sql: true
        jdbc:
          batch_size: 20
        order_inserts: true
        order_updates: true
```

## Security Configuration

### JWT Configuration

```yaml
app:
  jwt:
    secret: ${JWT_SECRET:myVerySecureSecretKey123456789!@#$%^&*()}
    access-token-expiration: 3600 # 1 hour in seconds
    refresh-token-expiration: 86400 # 24 hours in seconds
```

**IMPORTANT**: Change JWT_SECRET in production to a strong random string.

Generate secure secret:

```bash
openssl rand -base64 64
```

### CORS Configuration

```yaml
spring:
  security:
    cors:
      allowed-origins: "*" # Restrict in production
      allowed-methods: GET,POST,PUT,DELETE
      allowed-headers: "*"
      allow-credentials: true
      max-age: 3600
```

### SSL/TLS Configuration (Production)

```yaml
server:
  ssl:
    enabled: true
    key-store: classpath:keystore.p12
    key-store-password: ${SSL_KEYSTORE_PASSWORD}
    key-store-type: PKCS12
    key-alias: finovabank
```

## Monitoring Configuration

### Actuator Endpoints

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
      base-path: /actuator
  endpoint:
    health:
      show-details: always # Options: never, when-authorized, always
  metrics:
    export:
      prometheus:
        enabled: true
```

### Prometheus Configuration

File: `monitoring/prometheus/prometheus.yml`

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: "spring-boot-services"
    metrics_path: "/actuator/prometheus"
    static_configs:
      - targets:
          - "api-gateway:8002"
          - "auth-service:8011"
          - "account-management:8081"
```

### Grafana Configuration

File: `monitoring/grafana/datasource.yml`

```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
```

## Docker Compose Configuration

File: `docker-compose.yml`

Key configurations:

```yaml
services:
  eureka-server:
    environment:
      - EUREKA_SERVER_PORT=8001
    ports:
      - "8001:8001"
    networks:
      - finova-network

  api-gateway:
    environment:
      - EUREKA_SERVER_URL=http://eureka-server:8001/eureka/
      - API_GATEWAY_PORT=8002
      - SPRING_PROFILES_ACTIVE=docker
    depends_on:
      eureka-server:
        condition: service_healthy
```

## Kubernetes Configuration

File: `infrastructure/kubernetes/values.yaml`

```yaml
replicaCount: 2

image:
  repository: finovabank
  pullPolicy: IfNotPresent
  tag: "latest"

service:
  type: ClusterIP
  port: 8080

ingress:
  enabled: true
  className: nginx
  hosts:
    - host: api.finovabank.com
      paths:
        - path: /
          pathType: Prefix

resources:
  limits:
    cpu: 1000m
    memory: 1Gi
  requests:
    cpu: 500m
    memory: 512Mi

autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80
```

## Configuration Best Practices

### Environment-Specific Settings

1. **Development**:
   - Use H2 in-memory database
   - Enable SQL logging
   - Relaxed security
   - Debug logging

2. **Docker**:
   - Use service names for URLs
   - Enable health checks
   - Container-optimized settings

3. **Production**:
   - PostgreSQL with connection pooling
   - Disable SQL logging
   - Strict security
   - INFO/WARN logging only
   - Enable monitoring

### Security Considerations

1. **Never commit secrets** to version control
2. Use **environment variables** or secrets management
3. **Rotate credentials** regularly
4. Use **strong passwords** (min 16 characters)
5. Enable **SSL/TLS** in production
6. Implement **rate limiting**
7. Configure **CORS** properly

### Performance Tuning

```yaml
# JVM Options
JAVA_OPTS: "-Xmx1g -Xms512m -XX:MaxMetaspaceSize=256m"

# Database Connection Pool
hikari:
  maximum-pool-size: 20
  minimum-idle: 10

# Caching
spring:
  cache:
    type: redis
    redis:
      time-to-live: 600000 # 10 minutes
```

## Configuration Validation

### Check Configuration

```bash
# Test database connection
./scripts/finovabank_db.sh status

# Verify service registration
curl http://localhost:8001/eureka/apps

# Check health endpoints
curl http://localhost:8002/actuator/health
curl http://localhost:8011/actuator/health
```

### Configuration File Locations

| Service            | Config File Path                                                |
| ------------------ | --------------------------------------------------------------- |
| Eureka Server      | `backend/eureka-server/src/main/resources/application.yml`      |
| API Gateway        | `backend/api-gateway/src/main/resources/application.yml`        |
| Auth Service       | `backend/auth-service/src/main/resources/application.yml`       |
| Account Management | `backend/account-management/src/main/resources/application.yml` |
| AI Service         | `backend/ai-service/src/main.py`                                |
| Web Frontend       | `web-frontend/.env`                                             |
| Mobile Frontend    | `mobile-frontend/.env`                                          |

## Troubleshooting Configuration

Common issues:

1. **Service won't start**: Check port conflicts, database connectivity
2. **Can't connect to Eureka**: Verify EUREKA_SERVER_URL
3. **Database errors**: Check credentials and URL format
4. **JWT errors**: Ensure JWT_SECRET is consistent across services
5. **CORS issues**: Configure allowed origins properly

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for detailed solutions.

## See Also

- [INSTALLATION.md](INSTALLATION.md) - Installation guide
- [USAGE.md](USAGE.md) - Usage instructions
- [CLI.md](CLI.md) - CLI reference
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Problem solving
