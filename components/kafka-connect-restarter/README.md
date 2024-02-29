# Connect restarter

This docker image addresses the following issue:

If a Kafka Connector Task fails, it has to be restarted manually. There is no auto restart functionality in Kafka Connect.

The missing feature is described here:
- https://issues.apache.org/jira/browse/KAFKA-15408

Solutions are described here:
- A solutions have been implemented by strimzi: https://github.com/strimzi/proposals/blob/main/007-restarting-kafka-connect-connectors-and-tasks.md, but since we are not using strizi, we need an other solution.
- A cronjob to restart failed tasks: https://rmoff.net/2019/06/06/automatically-restarting-failed-kafka-connect-tasks

The code in this container relies on the cronjob solution.

## Environmen Variables

KAFKA_CONNECT_URL: The url of the Kafka Connect API.

## Local Usage

Build docker image

```bash
docker build -t myimage .
```

Run docker container

```bash
docker run -e KAFKA_CONNECT_URL="host.docker.internal:8083" myimage 
```

This command assumes that you are running docker on Mac or Windows and the container connects to Kafka Connect running on the host machine on port 8083.

## Publish image

In order to use the image in a K8s cluster, we have to build it for linux/amd64 publish it.

### build

Build docker image with the correct tag

```bash
docker build --platform="linux/amd64" -t ghcr.io/geovistory/kafka-connect-restarter:1.0.1 .
```

(make sure you increase the version compared to the latest pushed: https://github.com/geovistory/ontoexplorer/pkgs/container/kafka-connect-restarter)

### login

If not logged in, log in with a github user that has push permission to the organization you use in the tag (above: geovistory).

```bash
docker login ghcr.io
```

### push

```bash
docker push ghcr.io/geovistory/kafka-connect-restarter:1.0.0
```

