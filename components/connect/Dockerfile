FROM docker.redpanda.com/redpandadata/connectors:v1.0.2

# jdbc-postgres connector
ADD /connectors/jdbc-postgres.tar /opt/kafka/redpanda-plugins
# rdf-sink connector
ADD /connectors/rdf-kafka-sink-connector-1.0.2-SNAPSHOT.tar /opt/kafka/redpanda-plugins
# confluent avro converter
ADD /converters/avro.tar /opt/kafka/redpanda-plugins
# debezium-postgres connector 2.5.1
ADD /connectors/debezium-connector-postgres-2.5.1.Final-plugin.tar /opt/kafka/redpanda-plugins

COPY ./init.sh /

CMD ["sh", "/init.sh"]