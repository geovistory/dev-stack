# Launch Kafka Connect
./launch.sh &
#
# Wait for Kafka Connect listener
echo "Waiting for Kafka Connect to start listening on localhost ⏳"
while : ; do
  curl_status=$(curl -s -o /dev/null -w %{http_code} http://connect:8083/connectors)
  echo -e $(date) " Kafka Connect listener HTTP state: " $curl_status " (waiting for 200)"
  if [ $curl_status -eq 200 ] ; then
    break
  fi
  sleep 5 
done

echo -e "\n--\n+> Creating Data Generator source"
curl -s -X PUT -H  "Content-Type:application/json" http://connect:8083/connectors/source-datagen-01/config \
    -d '{
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "tasks.max": 1,
    "database.hostname": "postgres",
    "database.port": 5432,
    "database.user": "postgres",
    "database.password": "local_pw",
    "database.dbname": "toolbox_db",
    "database.server.name": "toolbox_db_server",
    "heartbeat.action.query": "UPDATE test_heartbeat_table SET updated_at = now();",
    "heartbeat.interval.ms": 3000,
    "table.include.list": "information.resource",
    "signal.data.collection": "system.debezium_signal",
    "plugin.name": "pgoutput",
    "slot.name": "kafka_source_connector",
    "topic.creation.enable": true,
    "topic.creation.default.replication.factor": -1 ,
    "topic.creation.default.partitions": 4,
    "topic.creation.default.cleanup.policy": "compact",
    "topic.creation.default.compression.type": "lz4",
    "topic.prefix": "local",
    "publication.autocreate.mode": "filtered",
    "decimal.handling.mode": "double",
    "key.converter": "io.confluent.connect.avro.AvroConverter",
    "key.converter.schema.registry.url": "http://redpanda:8081",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url": "http://redpanda:8081",
    "schema.name.adjustment.mode": "avro",
    "transforms": "unwrap",
    "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
    "transforms.unwrap.drop.tombstones": true,
    "transforms.unwrap.delete.handling.mode": "rewrite",
    "errors.retry.timeout": -1
}'
sleep infinity