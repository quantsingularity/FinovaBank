# FinovaBank Kubernetes Helm Chart

This directory contains the Helm chart for deploying the FinovaBank microservices architecture to a Kubernetes cluster.

### Prerequisites

- [Helm 3](https://helm.sh/) installed.
- Access to a configured Kubernetes cluster.

### Installation

1.  **Review Configuration:** Examine the `values.yaml` file and adjust the service-specific settings under the `services` map as needed.
2.  **Install the Chart:**
    ```bash
    helm install finovabank ./kubernetes -f ./kubernetes/values.yaml
    ```

### Configuration

The `values.yaml` file is the primary configuration source.

| Parameter                               | Description                                                   | Default Value             |
| :-------------------------------------- | :------------------------------------------------------------ | :------------------------ |
| `replicaCount`                          | Global default number of pod replicas for all services.       | `1`                       |
| `image.repository`                      | The base Docker image repository.                             | `quantsingularity/finovabackend` |
| `image.tag`                             | Global default image tag for all services.                    | `latest`                  |
| `environment.API_BASE_URL`              | The base URL for the API Gateway, used by other services.     | `http://api-gateway:8002` |
| `resources`                             | Global default resource requests and limits for all services. | (See `values.yaml`)       |
| `services.<serviceName>.enabled`        | Whether to deploy the specific microservice.                  | `true`                    |
| `services.<serviceName>.port`           | The container and service port for the microservice.          | (Service-specific)        |
| `services.<serviceName>.tag`            | Overrides the global image tag for a specific microservice.   | (Service-specific)        |
| `services.<serviceName>.probes.enabled` | Enables liveness and readiness probes.                        | `true`                    |

For a complete list of configurable parameters, please refer to `values.yaml`.
