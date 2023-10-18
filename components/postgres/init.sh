#!/bin/bash

touch ./tmp/init

echo setup debugger
echo shared_preload_libraries = 'plugin_debugger' >> /var/lib/postgresql/data/postgresql.conf 

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

echo Create debug extension
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$GEOVISTORY_DB" <<-EOSQL
    CREATE EXTENSION pldbgapi;
EOSQL

# touch ./var/lib/postgresql/data/ready

echo Seed database
chmod 0777 ./var/lib/postgresql/data/
{ # try
    time pg_restore -j 4 --no-owner -d $GEOVISTORY_DB ./seed.data --verbose && echo ready! && touch ./var/lib/postgresql/data/ready
} || { # catch
    # pg_restore will throw error: schema "public" already exists
    # we can ignore and mark container ready.
    echo restored with error! && touch ./var/lib/postgresql/data/ready

}