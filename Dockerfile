# Use the official Python image
FROM python:3.11-slim

# Set the working directory
WORKDIR /app

# Install system dependencies required for Poetry
RUN apt-get update && apt-get install -y curl git && \
    curl -sSL https://install.python-poetry.org | python3 - && \
    apt-get clean

# Ensure Poetry is in PATH
ENV PATH="/root/.local/bin:$PATH"

# Configure Poetry
RUN poetry config virtualenvs.create true
RUN poetry config virtualenvs.in-project true
RUN poetry self update  # Ensure Poetry is up-to-date

# Copy dependency files
COPY pyproject.toml poetry.lock ./

# Install dependencies using Poetry
RUN poetry install --no-root --no-interaction --no-ansi

# Copy the rest of the application code
COPY . .

# Ensure the container always uses the correct virtual environment
ENV PATH="/app/.venv/bin:$PATH"

# Set the entrypoint to always use Bash
CMD ["/bin/bash"]