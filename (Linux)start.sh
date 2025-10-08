#!/bin/bash

if ! command -v docker &> /dev/null
then
    echo "[ERROR] Docker no encontrado. Es necesario instalar Docker."
    exit
fi

if ! command -v docker-compose &> /dev/null
then
    echo "[ERROR] docker-compose no encontrado. Es necesario reinstalar Docker."
    exit
fi

if ! docker ps &> /dev/null
then
    echo "[ERROR] El motor de Docker no esta en ejecucion. Es necesario iniciar Docker."
    exit
fi

echo "Iniciando servicios en segundo plano..."
docker-compose up --build -d

echo "Mostrando logs... Presiona Ctrl+C para detener y limpiar todo."
docker-compose logs -f

echo ""
echo "Deteniendo y limpiando..."
docker-compose down --remove-orphans -v

echo "Proceso finalizado."