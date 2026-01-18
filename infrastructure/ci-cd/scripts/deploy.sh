#!/bin/bash

# This script is refactored to use a loop for microservices, reducing duplication.

# Exit immediately if a command exits with a non-zero status.
set -e

# Set Docker registry from environment variable or use default
DOCKER_REGISTRY=${DOCKER_USERNAME:-quantsingularity}
IMAGE_REPO="finovabackend"

# List of all backend microservices
MICROSERVICES=(
    "api-gateway"
    "account-management"
    "transaction-service"
    "loan-management"
    "savings-goals"
    "risk-assessment"
    "compliance"
    "notification-service"
    "reporting"
)

# Function to build and push a Docker image
build_and_push() {
    local service_name=$1
    local context_path=$2
    local dockerfile_path=$3

    echo "Building and pushing $service_name..."

    # Use a consistent image name structure
    local image_name="$DOCKER_REGISTRY/$IMAGE_REPO/$service_name"

    # Build
    docker buildx build -t "$image_name:latest" -f "$dockerfile_path" "$context_path"

    # Push
    docker push "$image_name:latest"

    echo "$service_name built and pushed successfully."
}

# 1. Build and push backend microservices
for service in "${MICROSERVICES[@]}"; do
    build_and_push "$service" "backend/$service" "backend/$service/Dockerfile"
done

# 2. Build and push frontend
build_and_push "web-frontend" "web-frontend" "web-frontend/Dockerfile"

# 3. Deploy to Kubernetes using the refactored Helm chart
echo "Deploying to Kubernetes using Helm..."
# Assuming the user is running this script from the FinovaBank root directory
helm upgrade --install finovabank kubernetes --wait

echo "Deployment complete."
