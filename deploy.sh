#!/bin/bash
# Rybella Deployment Script
set -e

echo "=== Rybella Deployment ==="

if [ ! -f .env ]; then
    echo "Creating .env from template..."
    cp .env.docker.example .env
    echo "Edit .env with your passwords before continuing!"
    exit 1
fi

if [ ! -d backend/vendor ]; then
    echo "Installing Composer dependencies..."
    docker run --rm -v "$(pwd)/backend:/app" -w /app composer:2 install --no-dev --optimize-autoloader --no-interaction
fi

echo "Starting Docker..."
docker compose up -d --build

echo "Waiting for database..."
sleep 15

echo "Setting up Laravel..."
docker compose exec -T app php artisan key:generate --force 2>/dev/null || true
docker compose exec -T app php artisan storage:link 2>/dev/null || true
docker compose exec -T app php artisan migrate --force

echo ""
echo "Deployment complete!"
echo "API: http://localhost:${APP_PORT:-8080}"
