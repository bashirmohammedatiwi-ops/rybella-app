@echo off
echo === Rybella Deployment ===

if not exist .env (
    copy .env.docker.example .env
    echo Edit .env with your passwords!
    pause
    exit /b 1
)

if not exist backend\vendor (
    echo Installing Composer dependencies...
    docker run --rm -v "%cd%\backend:/app" -w /app composer:2 install --no-dev --optimize-autoloader --no-interaction
)

echo Starting Docker...
docker compose up -d --build

timeout /t 20 /nobreak >nul

echo Setting up Laravel...
docker compose exec -T app php artisan key:generate --force 2>nul
docker compose exec -T app php artisan storage:link 2>nul
docker compose exec -T app php artisan migrate --force

echo.
echo Done! API: http://localhost:8080
pause
