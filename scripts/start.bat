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
    echo Limpiando sesion...
    docker-compose down -v --remove-orphans >nul 2>&1
    goto :select_db_script

:run_compose
    echo Iniciando servicios...
    docker-compose up --build
    goto :end

:select_db_script
    cls
    echo Seleccione el script de inicializacion de la base de datos:
    set /a count=0

    echo --- Scripts SQL por Defecto ---
    if exist "..\database\default\*.sql" (
        for /f "delims=" %%f in ('dir /b "..\database\default\*.sql"') do (
            set /a count+=1
            set "script_name[!count!]=%%f"
            set "script_type[!count!]=default"
            echo [!count!] %%f (Default)
        )
    )

    echo --- Scripts SQL Personalizados ---
    if exist "..\database\*.sql" (
        for /f "delims=" %%f in ('dir /b "..\database\*.sql"') do (
            set /a count+=1
            set "script_name[!count!]=%%f"
            set "script_type[!count!]=custom"
            echo [!count!] %%f (Custom)
        )
    )

    if %count% equ 0 (
        echo No se encontraron scripts SQL.
        exit /b 1
    )

    :get_options
    set /p options="Seleccione la base de datos (1-%count%): "

    if !options! gtr %count% ( goto :invalid_options )
    if !options! lss 1 ( goto :invalid_options )

    set "SELECTED_SCRIPT_NAME=!script_name[%options%]!"
    set "SELECTED_SCRIPT_TYPE=!script_type[%options%]!"

    if "!SELECTED_SCRIPT_TYPE!"=="default" (
        set "DB_INIT_SCRIPT=/usr/src/app/database/default/!SELECTED_SCRIPT_NAME!"
    ) else (
        set "DB_INIT_SCRIPT=/usr/src/app/database/!SELECTED_SCRIPT_NAME!"
    )
    
    echo Usando el script: !DB_INIT_SCRIPT!
    goto :run_compose

    :invalid_options
    cls
    powershell write-host "Opcion invalida" -ForegroundColor Red
    goto :select_db_script


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
    docker-compose down -v --remove-orphans
) else (
    cls
    powershell write-host "Opcion invalida" -ForegroundColor Red
    goto :run_serv
)

:end
echo Proceso finalizado.