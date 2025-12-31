#!/bin/bash

# Configuración
DB_NAME="appointment_central"
DB_USER="postgres"
DB_PASS="password"
DB_HOST="localhost"
DB_PORT="5434"
INPUT_FILE=${1:-"database_dump.sql"}

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: No se encuentra el archivo $INPUT_FILE"
    echo "Uso: ./restore_db.sh [archivo_backup.sql]"
    exit 1
fi

echo "Usando archivo: $INPUT_FILE"
echo "Limpiando la base de datos $DB_NAME en $DB_HOST:$DB_PORT..."

# Limpiar y restaurar usando herramientas locales
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;" && \
PGPASSWORD=$DB_PASS psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME < $INPUT_FILE

if [ $? -eq 0 ]; then
    echo "¡Restauración completada con éxito!"
else
    echo "Error en la restauración local. Intentando vía Docker..."
    CONTAINER_NAME="apsia_db"
    docker exec -i $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;" && \
    cat $INPUT_FILE | docker exec -i $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME
    
    if [ $? -eq 0 ]; then
        echo "¡Restauración completada con éxito (vía Docker)!"
    else
        echo "Error: No se pudo restaurar la base de datos ni localmente ni vía Docker."
        exit 1
    fi
fi
