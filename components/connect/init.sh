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

echo -e "\n--\n+> Creating Postgres Source Connector"
curl -s -X PUT -H  "Content-Type:application/json" http://connect:8083/connectors/posrgres-source/config \
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
    "table.include.list": "information.resource, information.statement, information.language, information.appellation, information.lang_string, information.place, information.time_primitive, information.dimension, projects.dfh_profile_proj_rel, projects.project, projects.text_property, projects.info_proj_rel, projects.info_proj_rel, projects.entity_label_config, system.config, data_for_history.api_property, data_for_history.api_class, data.digital, tables.cell",
    "signal.data.collection": "system.debezium_signal",
    "plugin.name": "pgoutput",
    "slot.name": "kafka_source_connector",
    "topic.creation.enable": true,
    "topic.creation.default.replication.factor": -1 ,
    "topic.creation.default.partitions": 4,
    "topic.creation.default.cleanup.policy": "compact",
    "topic.creation.default.compression.type": "lz4",
    "topic.prefix": "dev",
    "publication.autocreate.mode": "filtered",
    "decimal.handling.mode": "double",
    "key.converter": "io.confluent.connect.avro.AvroConverter",
    "key.converter.schema.registry.url": "http://redpanda-1:8081",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url": "http://redpanda-1:8081",
    "schema.name.adjustment.mode": "avro",
    "transforms": "unwrap",
    "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
    "transforms.unwrap.drop.tombstones": true,
    "transforms.unwrap.delete.handling.mode": "rewrite",
    "errors.retry.timeout": -1
}'



echo -e "\n--\n+> Creating Postgres Sink Connector"
curl -s -X PUT -H  "Content-Type:application/json" http://connect:8083/connectors/posrgres-sink/config \
    -d '{
    "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
    "tasks.max": 1,
    "connection.url": "jdbc:postgresql://postgres:5432/toolbox_db",
    "connection.user": "postgres",
    "connection.password": "local_pw",
    "dialect.name": "PostgreSqlDatabaseDialect",
    "insert.mode": "upsert",
    "delete.enabled": true,
    "table.name.format": "war.${topic}",
    "pk.mode": "record_key",
    "pk.fields": "" ,
    "fields.whitelist": "",
    "db.timezone": "UTC",
    "topics": "ts_field_changes_project_field_change, ts_entity_preview_entity_preview, ts_analysis_statements_project_analysis_statement",
    "auto.create": false,
    "auto.evolve": false,
    "key.converter": "io.confluent.connect.avro.AvroConverter",
    "key.converter.schema.registry.url": "http://redpanda-1:8081",
    "key.converter.enhanced.avro.schema.support": true,
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url": "http://redpanda-1:8081",
    "value.converter.enhanced.avro.schema.support": true
}'
    

sleep infinity