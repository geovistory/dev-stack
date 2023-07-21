#!/bin/bash

touch ./tmp/init

# Wait for PostgreSQL to start
wait_postgresql() {
    while ! pg_isready -q; do
        echo "Waiting for PostgreSQL to start..."
        sleep 1
    done
}
wait_postgresql

echo Create database
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE DATABASE $GEOVISTORY_DB;
EOSQL

echo Create postgis extension
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$GEOVISTORY_DB" <<-EOSQL
    CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;
EOSQL

echo Seed database
{ # try
    time pg_restore -j 4 --no-owner -d $GEOVISTORY_DB ./seed.data --verbose && echo ready! && touch ./tmp/ready
} || { # catch
    # pg_restore will throw error: schema "public" already exists
    # we can ignore and mark container ready.
    echo restored with error! && touch ./tmp/ready
}
