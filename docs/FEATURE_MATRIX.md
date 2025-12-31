# Feature Matrix

Comprehensive overview of FinovaBank features, organized by module and capability.

## Table of Contents

- [Core Banking Features](#core-banking-features)
- [AI-Powered Features](#ai-powered-features)
- [Security & Compliance](#security--compliance)
- [Integration Features](#integration-features)
- [DevOps & Infrastructure](#devops--infrastructure)
- [Frontend Features](#frontend-features)

## Core Banking Features

| Feature               |                             Short description | Module / File                                         | CLI flag / API                   | Example (path)                                                   | Notes                           |
| --------------------- | --------------------------------------------: | ----------------------------------------------------- | -------------------------------- | ---------------------------------------------------------------- | ------------------------------- |
| User Registration     |      Create new user accounts with validation | `auth-service` / `AuthController.java`                | `POST /api/auth/register`        | [examples/user_registration.md](examples/user_registration.md)   | Includes email verification     |
| User Authentication   |               Login with JWT token generation | `auth-service` / `AuthServiceImpl.java`               | `POST /api/auth/login`           | [examples/authentication.md](examples/authentication.md)         | Supports username/email login   |
| Token Refresh         |                 Refresh expired access tokens | `auth-service` / `AuthController.java`                | `POST /api/auth/refresh`         | [examples/authentication.md](examples/authentication.md)         | Uses refresh tokens             |
| Account Creation      | Create checking, savings, investment accounts | `account-management` / `AccountServiceImpl.java`      | `POST /api/accounts`             | [examples/account_management.md](examples/account_management.md) | Supports multiple account types |
| Account Balance Query |                        Check account balances | `account-management` / `AccountController.java`       | `GET /api/accounts/{id}/balance` | [examples/account_management.md](examples/account_management.md) | Real-time balance               |
| Account Listing       |                        List all user accounts | `account-management` / `AccountService.java`          | `GET /api/accounts`              | [examples/account_management.md](examples/account_management.md) | Paginated results               |
| Money Transfer        |               Transfer funds between accounts | `transaction-service` / `TransactionServiceImpl.java` | `POST /api/transactions`         | [examples/transactions.md](examples/transactions.md)             | Atomic transactions             |
| Transaction History   |                        View past transactions | `transaction-service` / `TransactionController.java`  | `GET /api/transactions`          | [examples/transactions.md](examples/transactions.md)             | Filterable by date, account     |
| Loan Application      |          Apply for personal, auto, home loans | `loan-management` / `LoanServiceImpl.java`            | `POST /api/loans/apply`          | [examples/loan_application.md](examples/loan_application.md)     | Auto credit check               |
| Loan Payment          |                            Make loan payments | `loan-management` / `LoanController.java`             | `POST /api/loans/{id}/payments`  | [examples/loan_application.md](examples/loan_application.md)     | Auto-debit support              |
| Savings Goals         |                Create and track savings goals | `savings-goals` / `SavingsGoalService.java`           | `POST /api/savings-goals`        | [examples/savings_goals.md](examples/savings_goals.md)           | Progress tracking               |
| Notifications         |                  Real-time transaction alerts | `notification-service` / `NotificationService.java`   | `GET /api/notifications`         | [examples/notifications.md](examples/notifications.md)           | Email, SMS, push                |
| Bill Payments         |                        Schedule and pay bills | `transaction-service` / `BillPaymentController.java`  | `POST /api/bills/pay`            | docs/api-doc.md                                                  | Recurring payments              |
| Card Management       |                 Manage virtual/physical cards | `account-management` / `CardController.java`          | API under development            | docs/api-doc.md                                                  | Planned feature                 |

## AI-Powered Features

| Feature                 |                          Short description | Module / File                       | CLI flag / API                                   | Example (path)                                                   | Notes                   |
| ----------------------- | -----------------------------------------: | ----------------------------------- | ------------------------------------------------ | ---------------------------------------------------------------- | ----------------------- |
| Fraud Detection         |       Real-time transaction fraud analysis | `ai-service` / `fraud_detection.py` | `POST /api/ai/fraud/analyze`                     | [examples/ai_fraud_detection.md](examples/ai_fraud_detection.md) | ML-based risk scoring   |
| Batch Fraud Analysis    |              Analyze multiple transactions | `ai-service` / `fraud_detection.py` | `POST /api/ai/fraud/batch-analyze`               | [examples/ai_fraud_detection.md](examples/ai_fraud_detection.md) | Bulk processing         |
| Product Recommendations | Personalized financial product suggestions | `ai-service` / `recommendations.py` | `POST /api/ai/recommendations/products`          | [examples/ai_recommendations.md](examples/ai_recommendations.md) | Based on profile        |
| Financial Advice        |            Personalized financial guidance | `ai-service` / `recommendations.py` | `POST /api/ai/recommendations/financial-advice`  | [examples/ai_recommendations.md](examples/ai_recommendations.md) | Health score + advice   |
| Spending Insights       |                  Analyze spending patterns | `ai-service` / `recommendations.py` | `POST /api/ai/recommendations/spending-insights` | [examples/ai_recommendations.md](examples/ai_recommendations.md) | Category analysis       |
| Risk Assessment         |            Loan and credit risk evaluation | `ai-service` / `risk_assessment.py` | `POST /api/ai/risk/assess`                       | docs/api-doc.md                                                  | Credit score prediction |
| Financial Analytics     |                 Advanced financial metrics | `ai-service` / `analytics.py`       | `POST /api/ai/analytics/analyze`                 | docs/api-doc.md                                                  | Trend analysis          |
| Model Training          |             Update AI models with new data | `ai-service` / `fraud_detection.py` | `POST /api/ai/fraud/update-model`                | docs/api-doc.md                                                  | Continuous learning     |

## Security & Compliance

| Feature             |                 Short description | Module / File                                      | CLI flag / API               | Example (path)        | Notes                |
| ------------------- | --------------------------------: | -------------------------------------------------- | ---------------------------- | --------------------- | -------------------- |
| JWT Authentication  |           Secure token-based auth | `auth-service` / `JwtTokenProvider.java`           | N/A (automatic)              | docs/security.md      | HS256 algorithm      |
| Password Encryption |           BCrypt password hashing | `auth-service` / `SecurityConfig.java`             | N/A (automatic)              | docs/security.md      | Strength: 10 rounds  |
| Role-Based Access   |            RBAC for authorization | `auth-service` / `CustomUserDetailsService.java`   | N/A (automatic)              | docs/security.md      | USER, ADMIN roles    |
| Security Service    |     Centralized security policies | `security-service` / `SecurityController.java`     | `/api/security/*`            | docs/security.md      | Policy enforcement   |
| Compliance Checks   |  Regulatory compliance validation | `compliance-service` / `ComplianceController.java` | `POST /api/compliance/check` | docs/api-doc.md       | AML, KYC checks      |
| Audit Logging       |       Comprehensive activity logs | All services / `LoggingAspect.java`                | N/A (automatic)              | docs/architecture.md  | Centralized logging  |
| Data Encryption     | At-rest and in-transit encryption | All services / configuration                       | N/A (automatic)              | docs/security.md      | TLS 1.3, AES-256     |
| API Rate Limiting   |            Prevent abuse and DDoS | `api-gateway` / `RateLimiterConfig.java`           | N/A (automatic)              | docs/api-doc.md       | Per-user limits      |
| Input Validation    |         Prevent injection attacks | All services / `@Valid` annotations                | N/A (automatic)              | docs/security.md      | Spring Validation    |
| CORS Configuration  |             Cross-origin security | `api-gateway` / `SecurityConfig.java`              | N/A (configuration)          | docs/configuration.md | Configurable origins |

## Integration Features

| Feature               |                 Short description | Module / File                                    | CLI flag / API               | Example (path)                        | Notes                |
| --------------------- | --------------------------------: | ------------------------------------------------ | ---------------------------- | ------------------------------------- | -------------------- |
| Service Discovery     |           Eureka service registry | `eureka-server` / `EurekaServerApplication.java` | N/A (runs on 8001)           | docs/architecture.md                  | Netflix Eureka       |
| API Gateway           | Centralized routing and filtering | `api-gateway` / `ApiGatewayApplication.java`     | N/A (runs on 8002)           | docs/architecture.md                  | Spring Cloud Gateway |
| Message Queue         |            Async event processing | Kafka / configuration                            | N/A (infrastructure)         | docs/architecture.md                  | Apache Kafka         |
| Caching               |               Redis-based caching | All services / `@Cacheable`                      | N/A (automatic)              | docs/architecture.md                  | Spring Cache + Redis |
| Reporting Service     |        Generate financial reports | `reporting` / `ReportingController.java`         | `POST /api/reports/generate` | docs/api-doc.md                       | PDF, CSV, Excel      |
| OpenAPI Documentation |           Auto-generated API docs | All services / Springdoc                         | `/swagger-ui.html`           | http://localhost:8002/swagger-ui.html | Interactive docs     |
| Health Checks         |         Service health monitoring | All services / Actuator                          | `/actuator/health`           | docs/monitoring.md                    | Liveness/readiness   |
| Metrics Export        |                Prometheus metrics | All services / Micrometer                        | `/actuator/prometheus`       | docs/monitoring.md                    | For Grafana          |

## DevOps & Infrastructure

| Feature               |                 Short description | Module / File                     | CLI flag / API                     | Example (path)                | Notes                |
| --------------------- | --------------------------------: | --------------------------------- | ---------------------------------- | ----------------------------- | -------------------- |
| Docker Support        |            Containerized services | `Dockerfile` (per service)        | `docker-compose up`                | docs/docker-kubernetes.md     | Multi-stage builds   |
| Kubernetes Deploy     |          Production orchestration | `infrastructure/kubernetes/`      | `./kubernetes-auto-deploy.sh`      | docs/kubernetes-deployment.md | Helm charts          |
| CI/CD Pipeline        |  Automated testing and deployment | `.github/workflows/cicd.yml`      | GitHub Actions (auto)              | docs/deployment.md            | Test, build, deploy  |
| Terraform IaC         | Cloud infrastructure provisioning | `infrastructure/terraform/`       | `terraform apply`                  | docs/deployment.md            | AWS support          |
| Ansible Automation    |          Configuration management | `infrastructure/ansible/`         | `ansible-playbook`                 | docs/deployment.md            | Server setup         |
| Prometheus Monitoring |                Metrics collection | `monitoring/prometheus/`          | `./finovabank_monitoring.sh start` | docs/monitoring.md            | Time-series DB       |
| Grafana Dashboards    |                 Visual monitoring | `monitoring/grafana/`             | http://localhost:3001              | docs/monitoring.md            | Pre-built dashboards |
| Log Aggregation       |             ELK stack integration | Configuration (planned)           | N/A                                | docs/architecture.md          | Planned feature      |
| Backup Scripts        |        Database backup automation | `scripts/finovabank_db.sh backup` | `./finovabank_db.sh backup`        | docs/CLI.md                   | Scheduled backups    |
| Service Management    |       Start/stop/restart services | `scripts/finovabank.sh`           | `./finovabank.sh start`            | docs/CLI.md                   | All CLI operations   |

## Frontend Features

| Feature           |           Short description | Module / File                                    | CLI flag / API              | Example (path)       | Notes                |
| ----------------- | --------------------------: | ------------------------------------------------ | --------------------------- | -------------------- | -------------------- |
| Web Dashboard     |   React-based web interface | `web-frontend/src/pages/Dashboard.tsx`           | http://localhost:3000       | docs/usage.md        | Material-UI design   |
| User Login Page   |           Authentication UI | `web-frontend/src/pages/Login.tsx`               | http://localhost:3000/login | docs/usage.md        | Form validation      |
| Account Details   | Account information display | `web-frontend/src/pages/AccountDetails.tsx`      | /accounts/:id               | docs/usage.md        | Real-time updates    |
| Transaction View  |      Transaction history UI | `web-frontend/src/pages/Transactions.tsx`        | /transactions               | docs/usage.md        | Filterable list      |
| Loan Management   |         Loan application UI | `web-frontend/src/pages/Loans.tsx`               | /loans                      | docs/usage.md        | Multi-step form      |
| Savings Goals UI  |     Goal tracking interface | `web-frontend/src/pages/SavingsGoals.tsx`        | /savings-goals              | docs/usage.md        | Progress bars        |
| Protected Routes  | Authorization-based routing | `web-frontend/src/components/ProtectedRoute.tsx` | N/A (automatic)             | docs/architecture.md | JWT verification     |
| Error Boundary    |     Graceful error handling | `web-frontend/src/components/ErrorBoundary.tsx`  | N/A (automatic)             | docs/architecture.md | React error boundary |
| Mobile App        |  React Native mobile client | `mobile-frontend/src/`                           | `npm run android/ios`       | docs/usage.md        | iOS & Android        |
| Responsive Design |      Mobile-friendly web UI | CSS/Material-UI                                  | N/A (automatic)             | docs/usage.md        | All screen sizes     |

## Platform Support Matrix

| Feature Category | Web UI | Mobile App | API | CLI |
| ---------------- | ------ | ---------- | --- | --- |
| Core Banking     | ✅     | ✅         | ✅  | ✅  |
| AI Features      | ✅     | 🚧         | ✅  | ❌  |
| Security         | ✅     | ✅         | ✅  | ❌  |
| Reporting        | ✅     | 🚧         | ✅  | ✅  |
| Admin Functions  | 🚧     | ❌         | ✅  | ✅  |

## See Also

- [API.md](API.md) - Complete API reference for all features
- [USAGE.md](USAGE.md) - How to use each feature
- [EXAMPLES/](examples/) - Working code examples
- [ARCHITECTURE.md](ARCHITECTURE.md) - System design and architecture
