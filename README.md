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

`bash scripts/down` does not remove the volumes (data of database etc.).
It just stops the containers (and frees resources on your computer).
Sometimes it is useful to start with a clean installation of the entire stack or one component.
In this situation it is necessary to remove one ore more volumes.

To remove all volumes having "geov_dev" in the name, run:

```bash
bash scripts/remove-volumes
```

This command will not remove used volumes. To delete them, first stop the stack.

To remove an individual volume you can first list all volumes:

```bash
docker volume ls -f "name=geov_dev"
```

And then remove the volume by its name (here fuseki):

```bash
docker volume rm geov_dev_fuseki
```

