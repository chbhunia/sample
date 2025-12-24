# syntax=docker/dockerfile:1

# --- Base for runtime
FROM python:3.11-slim AS runtime
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

# --- Test stage (runs tests)
FROM runtime AS test
# Running tests during build is useful to fail early
# But we will also run tests via 'docker run' in the workflow
RUN pytest -q || (echo "Tests failed during image build" && exit 1)

# --- Final image (could be same as runtime)
FROM runtime AS final
CMD ["python", "app.py"]
