# Use an official Python base image
FROM python:3.11-slim

# Set working directory inside the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Install dependencies (if requirements.txt exists)
RUN pip install --no-cache-dir -r requirements.txt || true

# Run the Python application
CMD ["python", "app.py"]
