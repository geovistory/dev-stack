FROM postgis/postgis:14-3.2

ENV PG_MAJOR 14 
ENV PG_FULL 14.3.2

# Install the postgresql debugger
RUN apt-get update && apt-get install -y --no-install-recommends postgresql-$PG_MAJOR-pldebugger 

RUN mkdir /logs
RUN chmod -R 777 /logs
COPY seed.data /seed.data
COPY init.sh /docker-entrypoint-initdb.d

