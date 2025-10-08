#!/bin/bash
echo "Deteniendo y limpiando Docker Compose..."
echo ""
docker-compose down --remove-orphans
echo ""
echo "Todos los contenedores detenidos y eliminados."