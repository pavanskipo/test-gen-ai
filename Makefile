APP_NAME = my-application
BUILD_DIR = build
BINARY = $(BUILD_DIR)/$(APP_NAME)
DOCKER_IMAGE = my-registry/$(APP_NAME):$(BUILD_NUMBER)

.PHONY: all build test clean docker-build

all: build

build:
	@echo "Building application for environment: $(ENV)"
	mkdir -p $(BUILD_DIR)
	echo "echo 'Hello, World!'" > $(BINARY)
	chmod +x $(BINARY)
	@echo "Build complete."

test:
	@echo "Running tests..."
	@echo "All tests passed!"

clean:
	@echo "Cleaning up..."
	rm -rf $(BUILD_DIR)

docker-build:
	@echo "Building Docker image..."
	docker build -t $(DOCKER_IMAGE) --build-arg ENV=$(ENV) .