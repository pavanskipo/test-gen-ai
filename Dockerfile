# Base image
FROM alpine:latest

# Set working directory
WORKDIR /app

# Copy the application binary
COPY build/my-application /app/my-application

# Set execution permissions
RUN chmod +x /app/my-application

# Define the entrypoint
ENTRYPOINT ["/app/my-application"]
