# FinovaBank Documentation

Welcome to the comprehensive documentation for FinovaBank - a modern digital banking platform combining traditional banking services with AI and blockchain technologies.

## Table of Contents

1. [Installation Guide](INSTALLATION.md)
2. [Usage Guide](USAGE.md)
3. [API Reference](API.md)
4. [CLI Reference](CLI.md)
5. [Configuration](CONFIGURATION.md)
6. [Feature Matrix](FEATURE_MATRIX.md)
7. [Architecture](ARCHITECTURE.md)
8. [Examples](examples/)
9. [Contributing](CONTRIBUTING.md)
10. [Troubleshooting](TROUBLESHOOTING.md)

## Quick Start

FinovaBank is a microservices-based digital banking platform built with Java Spring Boot backend services, React/React Native frontends, and Python AI services.

### Three-Step Quickstart

1. **Clone and setup environment**

   ```bash
   git clone https://github.com/abrar2030/FinovaBank.git
   cd FinovaBank
   cp .env.example .env
   ```

2. **Start with Docker Compose**

   ```bash
   docker-compose up -d
   ```

3. **Access the platform**
   - Web UI: http://localhost:3000
   - API Gateway: http://localhost:8002
   - Eureka Dashboard: http://localhost:8001
   - Grafana Monitoring: http://localhost:3001

## What is FinovaBank?

FinovaBank is a comprehensive digital banking platform featuring:

- **Core Banking Services**: Account management, transactions, loans, and payments
- **AI-Powered Features**: Fraud detection, financial recommendations, risk assessment, and analytics
- **Blockchain Integration**: Immutable transaction records and smart contracts
- **Microservices Architecture**: 12+ independent services with service discovery
- **Modern Frontend**: React web app and React Native mobile app
- **DevOps Ready**: Docker, Kubernetes, CI/CD with GitHub Actions

## Documentation Structure

- **[INSTALLATION.md](INSTALLATION.md)** - Complete installation instructions for all platforms
- **[USAGE.md](USAGE.md)** - How to use the platform (CLI, API, UI)
- **[API.md](API.md)** - Complete REST API reference
- **[CLI.md](CLI.md)** - Command-line interface reference
- **[CONFIGURATION.md](CONFIGURATION.md)** - Environment variables and configuration files
- **[FEATURE_MATRIX.md](FEATURE_MATRIX.md)** - Feature overview table
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - System architecture and design
- **[EXAMPLES/](examples/)** - Working code examples
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - How to contribute to the project
- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Common issues and solutions

## Key Technologies

| Layer             | Technologies                                             |
| ----------------- | -------------------------------------------------------- |
| Backend           | Java 17, Spring Boot 2.7.14, Spring Cloud                |
| Frontend          | React 18.3.1, TypeScript, Material-UI, React Native 0.72 |
| AI/ML             | Python 3.8+, Flask, scikit-learn, pandas, numpy          |
| Databases         | PostgreSQL, MongoDB, Redis, H2 (dev)                     |
| Infrastructure    | Docker, Kubernetes, Terraform, Ansible                   |
| Monitoring        | Prometheus, Grafana                                      |
| Message Queue     | Kafka, RabbitMQ                                          |
| Service Discovery | Netflix Eureka                                           |

## License

This project is licensed under the MIT License. See the LICENSE file for details.
