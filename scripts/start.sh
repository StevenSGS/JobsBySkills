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
        docker-compose down -v --remove-orphans
    else
        clear
        echo -e "\033[31mOpcion invalida\033[0m"
        sleep 1
        exec "$0"
    fi
else
    echo "Limpiando sesion..."
    docker-compose down -v --remove-orphans > /dev/null 2>&1

    select_db_script() {
        clear
        echo "Seleccione el script de inicializacion de la base de datos:"
        
        local options=()
        local file_paths=()
        
        while IFS= read -r -d $'\000'; do
            options+=("$(basename "$REPLY") (Default)")
            file_paths+=("$REPLY")
        done < <(find ../database/default -name "*.sql" -print0)

        while IFS= read -r -d $'\000'; do
            options+=("$(basename "$REPLY") (Custom)")
            file_paths+=("$REPLY")
        done < <(find ../database -maxdepth 1 -name "*.sql" -print0)

        if [ ${#options[@]} -eq 0 ]; then
            echo "No se encontraron scripts SQL."
            exit 1
        fi

        PS3="Seleccione la base de datos: "
        select opt in "${options[@]}"; do
            if [[ -z "$opt" ]]; then
                clear
                echo -e "\033[31mOpcion invalida.\033[0m"
                sleep 1
                exec "$0"
            fi

            for i in "${!options[@]}"; do
                if [[ "${options[$i]}" = "$opt" ]]; then
                    full_path="${file_paths[$i]}"
                    break
                fi
            done

            if [[ "$opt" == *"(Default)"* ]]; then
                script_name=$(basename "$full_path")
                export DB_INIT_SCRIPT="/usr/src/app/database/default/$script_name"
            else
                script_name=$(basename "$full_path")
                export DB_INIT_SCRIPT="/usr/src/app/database/$script_name"
            fi
            
            echo "Usando el script: $DB_INIT_SCRIPT"
            return 0
        done
    }

    select_db_script

    echo "Iniciando servicios..."
    docker-compose up --build
fi

echo ""
echo "Proceso finalizado."
