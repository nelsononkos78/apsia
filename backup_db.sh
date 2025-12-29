#!/bin/bash

# Nombre del contenedor de la base de datos (según docker-compose.yml)
CONTAINER_NAME="e1cc2628fa89_apsia_db"
DB_NAME="appointment_central"
DB_USER="postgres"
OUTPUT_FILE="database_dump.sql"

echo "Generando backup de la base de datos $DB_NAME desde el contenedor $CONTAINER_NAME..."

# Ejecutar pg_dump dentro del contenedor y redirigir la salida a un archivo local
docker exec -t $CONTAINER_NAME pg_dump -U $DB_USER $DB_NAME > $OUTPUT_FILE

if [ $? -eq 0 ]; then
    echo "¡Backup completado con éxito! Archivo generado: $OUTPUT_FILE"
    echo "Ahora puedes subir este archivo al repositorio para usarlo en otra PC."
else
    echo "Error al generar el backup."
    exit 1
fi
