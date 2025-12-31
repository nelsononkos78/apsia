#!/bin/bash

# Configuración
DB_NAME="appointment_central"
DB_USER="postgres"
DB_PASS="password"
DB_HOST="localhost"
DB_PORT="5434"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_FILE="database_dump_${TIMESTAMP}.sql"
LATEST_FILE="database_dump.sql"

echo "Generando backup de la base de datos $DB_NAME desde $DB_HOST:$DB_PORT..."

# Ejecutar pg_dump usando la contraseña proporcionada
PGPASSWORD=$DB_PASS pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER $DB_NAME > $OUTPUT_FILE

if [ $? -eq 0 ]; then
    cp $OUTPUT_FILE $LATEST_FILE
    echo "¡Backup completado con éxito!"
    echo "Archivo con timestamp: $OUTPUT_FILE"
    echo "Archivo actualizado: $LATEST_FILE"
else
    echo "Error al generar el backup. Intentando vía Docker..."
    CONTAINER_NAME="apsia_db"
    docker exec -t $CONTAINER_NAME pg_dump -U $DB_USER $DB_NAME > $OUTPUT_FILE
    if [ $? -eq 0 ]; then
        cp $OUTPUT_FILE $LATEST_FILE
        echo "¡Backup completado con éxito (vía Docker)!"
    else
        echo "Error: No se pudo generar el backup ni localmente ni vía Docker."
        exit 1
    fi
fi
