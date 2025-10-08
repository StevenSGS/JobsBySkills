@echo off

docker --version >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Docker no encontrado. Es necesario instalar Docker Desktop.
    goto end
)

docker-compose --version >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] docker-compose no encontrado. Es necesario reinstalar Docker Desktop.
    goto end
)

docker ps >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] El motor de Docker no esta en ejecucion. Es necesario iniciar Docker Desktop.
    goto end
)

echo Iniciando servicios...
docker-compose up --build

echo Deteniendo servicios...
docker-compose down

:end

echo.
echo Deteniendo y limpiando...

docker-compose down

echo Proceso finalizado.
