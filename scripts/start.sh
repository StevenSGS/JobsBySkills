#!/bin/bash

if ! command -v docker &> /dev/null
then
    echo "[ERROR] Docker no encontrado. Es necesario instalar Docker."
    read -p "Presione Enter para continuar..."
    exit 1
fi

if ! command -v docker compose &> /dev/null
then
    echo "[ERROR] docker compose no encontrado. Es necesario reinstalar Docker."
    read -p "Presione Enter para continuar..."
    exit 1
fi

if ! docker ps &> /dev/null
then
    echo "[ERROR] El motor de Docker no esta en ejecucion. Es necesario iniciar Docker."
    read -p "Presione Enter para continuar..."
    exit 1
fi

if docker compose ps 2>/dev/null | grep -q "Up"; then
    clear
    echo "Servidor esta en ejecucion en: http://localhost:3000"
    echo
    echo "[1] Continuar Ejecutando..."
    echo "[2] Reiniciar Servidor."
    echo "[3] Terminar todos los procesos."
    echo
    read -p "Seleccione una opcion (1, 2 o 3): " option
    echo

    if [ "$option" = "1" ]; then
        docker compose logs -f
    elif [ "$option" = "2" ]; then
        docker compose restart jobsbyskills
        docker compose logs -f
    elif [ "$option" = "3" ]; then
        docker compose down -v --remove-orphans
    else
        clear
        echo -e "\033[31mOpcion invalida\033[0m"
        sleep 1
        exec "$0"
    fi
else
    echo "Limpiando sesion..."

    if [ "$(ls -A ../database/data 2>/dev/null)" ]; then
        echo "[INFO] Data persistente detectada en database/data."
        echo "[INFO] Iniciando con la base de datos existente..."
        export DB_INIT_SCRIPT=""
    else
        select_db_script() {
            while true; do
                clear
                echo "Seleccione el script de inicializacion de la base de datos:"
                
                local default_scripts=()
                while IFS= read -r -d $'\0' file; do
                    default_scripts+=("$file")
                done < <(find ../database/default -name "*.sql" -print0)

                local custom_scripts=()
                while IFS= read -r -d $'\0' file; do
                    custom_scripts+=("$file")
                done < <(find ../database -maxdepth 1 -name "*.sql" -print0)

                local all_scripts=("${default_scripts[@]}" "${custom_scripts[@]}")

                if [ ${#all_scripts[@]} -eq 0 ]; then
                    echo "No se encontraron scripts SQL."
                    read -p "Presione Enter para continuar..."
                    exit 1
                fi

                local count=0
                echo "--- Scripts SQL por Defecto ---"
                for script in "${default_scripts[@]}"; do
                    count=$((count + 1))
                    echo "[$count] $(basename "$script") (Default)"
                done

                echo "--- Scripts SQL Personalizados ---"
                for script in "${custom_scripts[@]}"; do
                    count=$((count + 1))
                    echo "[$count] $(basename "$script") (Custom)"
                done

                read -p "Seleccione la base de datos (1-$count): " choice

                if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "$count" ]; then
                    echo -e "\033[31mOpcion invalida\033[0m"
                    sleep 1
                    continue
                fi

                local selected_index=$((choice - 1))
                local selected_script="${all_scripts[$selected_index]}"
                local script_name=$(basename "$selected_script")

                if [ "$choice" -le "${#default_scripts[@]}" ]; then
                    export DB_INIT_SCRIPT="/usr/src/app/database/default/$script_name"
                else
                    export DB_INIT_SCRIPT="/usr/src/app/database/$script_name"
                fi
                
                echo "Usando el script: $DB_INIT_SCRIPT"
                break
            done
        }

        select_db_script
    fi

    echo "Iniciando servicios..."
    docker compose up --build
fi

echo ""
echo "Proceso finalizado."
read -p "Presione Enter para continuar..."