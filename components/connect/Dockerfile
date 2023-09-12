FROM docker.redpanda.com/redpandadata/connectors:v1.0.2

# debezium-postgres connector
ADD /connectors/debezium-postgres.tar /opt/kafka/redpanda-plugins
# jdbc-postgres connector
ADD /connectors/jdbc-postgres.tar /opt/kafka/redpanda-plugins
# rdf-sink connector
ADD /connectors/rdf-kafka-sink-connector-0.9.2-SNAPSHOT.tar /opt/kafka/redpanda-plugins
# confluent avro converter
ADD /converters/avro.tar /opt/kafka/redpanda-plugins

COPY ./init.sh /

CMD ["sh", "/init.sh"]