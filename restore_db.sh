#!/bin/bash

# Nombre del contenedor de la base de datos (según docker-compose.yml)
CONTAINER_NAME="apsia_db"
DB_NAME="appointment_central"
DB_USER="postgres"
INPUT_FILE="database_dump.sql"

if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: No se encuentra el archivo $INPUT_FILE"
    exit 1
fi

echo "Limpiando la base de datos $DB_NAME (drop & recreate schema public)..."
docker exec -i $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

echo "Restaurando la base de datos $DB_NAME en el contenedor $CONTAINER_NAME desde $INPUT_FILE..."

# Copiar el archivo al contenedor temporalmente (opcional, pero más seguro para psql)
# O simplemente usar cat y psql
cat $INPUT_FILE | docker exec -i $CONTAINER_NAME psql -U $DB_USER -d $DB_NAME

if [ $? -eq 0 ]; then
    echo "¡Restauración completada con éxito!"
else
    echo "Error al restaurar la base de datos."
    exit 1
fi
