# Variables
ENV ?= development
NODE_ENV = $(ENV)
APP_NAME = my-application

# Phony targets
.PHONY: all build test clean docker-build docker-push help

# Default target
all: clean build test

# Install dependencies
install:
	@echo "Installing dependencies..."
	npm ci

# Build the application
build: install
	@echo "Building application for $(ENV) environment..."
	NODE_ENV=$(NODE_ENV) npm run build

# Run tests
test:
	@echo "Running tests..."
	npm run test

# Run linting
lint:
	@echo "Running linter..."
	npm run lint

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf dist node_modules/.cache
	npm run clean

# Build Docker image
docker-build:
	@echo "Building Docker image..."
	docker build -t my-registry/$(APP_NAME):latest --build-arg ENV=$(ENV) .

# Push Docker image
docker-push: docker-build
	@echo "Pushing Docker image to registry..."
	docker push my-registry/$(APP_NAME):latest

# Help command
help:
	@echo "Available commands:"
	@echo "  make              - Install dependencies, build and test"
	@echo "  make build        - Build the application"
	@echo "  make test         - Run tests"
	@echo "  make lint         - Run linting"
	@echo "  make clean        - Clean build artifacts"
	@echo "  make docker-build - Build Docker image"
	@echo "  make docker-push  - Build and push Docker image"
	@echo ""
	@echo "Environment variables:"
	@echo "  ENV              - Build environment (development, staging, production)"