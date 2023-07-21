# dev-stack
Developer repo for the local setup of the geovistory stack.


## Build and start stack
If you start the first time or you want to apply changes to the docker setup, call this command:

```bash
bash scripts/build
```

This should start all layers of the stack. 

It takes 2-3 min to initialize the database. Observe the progres: 

```bash
docker logs geov_dev-postgres-1 --follow
```
See the status of the running containers in Docker Desktop (only on Mac/Win) or with `docker ps`.

## Stop stack
Stop the stack without removing the containers:

```bash
bash scripts/down
```

## Start stack

Start the stopped containers:
```bash
bash scripts/up
```

## Cleanup volumes

`bash scripts/down` does not remove the volumes (storing the database etc.). 

To clean up all data, list the volumes:

```bash
docker volume ls | grep geov_dev
```

The following command deletes the postgres data:

```bash
docker volume rm geov_dev_postgis-data
```

