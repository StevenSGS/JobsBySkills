#!/bin/bash

if ! command -v docker &> /dev/null
then
    echo "[ERROR] Docker no encontrado. Es necesario instalar Docker."
    exit 1
fi

if ! command -v docker-compose &> /dev/null
then
    echo "[ERROR] docker-compose no encontrado. Es necesario reinstalar Docker."
    exit 1
fi

if ! docker ps &> /dev/null
then
    echo "[ERROR] El motor de Docker no esta en ejecucion. Es necesario iniciar Docker."
    exit 1
fi

if docker-compose ps 2>/dev/null | grep -q "Up"; then
    echo "Servidor esta en ejecucion en: http://localhost:3000"
    echo
    echo "[1] Continuar Ejecutando..."
    echo "[2] Reiniciar Servidor."
    echo "[3] Terminar todos los procesos."
    echo
    read -p "Seleccione una opcion (1, 2 o 3): " option
    echo

    if [ "$option" = "1" ]; then
        docker-compose logs -f
    elif [ "$option" = "2" ]; then
        docker-compose restart jobsbyskills
        docker-compose logs -f
    elif [ "$option" = "3" ]; then
        docker-compose down --remove-orphans
    else
        clear
        echo -e "\033[31mOpcion invalida\033[0m"
        sleep 1
        exec "$0"
    fi
else
    echo "Iniciando servicios..."
    docker-compose up --build
fi

echo ""
echo "Proceso finalizado."