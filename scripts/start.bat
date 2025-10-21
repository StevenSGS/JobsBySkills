@echo off
setlocal enabledelayedexpansion

docker --version >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Docker no encontrado. Es necesario instalar Docker Desktop.
    exit /b 1
)

docker-compose --version >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] docker-compose no encontrado. Es necesario reinstalar Docker Desktop.
    exit /b 1
)

docker ps >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] El motor de Docker no esta en ejecucion. Es necesario iniciar Docker Desktop.
    exit /b 1
)

for /f "tokens=*" %%i in ('docker-compose ps ^| findstr "Up" 2^>nul') do (
    set "is_running=1"
    goto :run_serv
)

:continue
echo Iniciando servicios...
docker-compose up --build
goto :end

:run_serv
echo Servidor esta en ejecucion en: http://localhost:3000
echo.
echo [1] Continuar Ejecutando...
echo [2] Reiniciar Servidor.
echo [3] Terminar todos los procesos.
echo.
set /p option=Seleccione una opcion (1, 2 o 3): 

if "!option!"=="1" (
    docker-compose logs -f
) else if "!option!"=="2" (
    docker-compose restart jobsbyskills
    docker-compose logs -f
) else if "!option!"=="3" (
    docker-compose down --remove-orphans
) else (
    cls
    powershell write-host "Opcion invalida" -ForegroundColor Red
    goto :run_serv
)

:end
echo Proceso finalizado.