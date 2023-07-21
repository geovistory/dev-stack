FROM postgis/postgis:14-3.2-alpine
RUN mkdir /logs
RUN chmod -R 777 /logs
COPY seed.data /seed.data
COPY init.sh /docker-entrypoint-initdb.d
# COPY docker-db-init.sh /docker-entrypoint-initdb.d
