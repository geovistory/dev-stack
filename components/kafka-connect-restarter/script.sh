#!/usr/bin/env bash
# @rmoff / June 6, 2019

# Set the path so cron can find jq, necessary for cron depending on your default PATH
export PATH=$PATH:/usr/local/bin/

# List current connectors and status
echo $KAFKA_CONNECT_URL CONNECTORS STATUS:
curl -s "$KAFKA_CONNECT_URL/connectors?expand=info&expand=status" |
  jq '. | to_entries[] | [ .value.info.type, .key, .value.status.connector.state,.value.status.tasks[].state,.value.info.config."connector.class"]|join(":|:")' |
  column -s : -t | sed 's/\"//g' | sort

# Restart any connector tasks that are FAILED
# Works for Apache Kafka >= 2.3.0
# Thanks to @jocelyndrean for this enhanced code snippet that also supports
#  multiple tasks in a connector
curl -s "$KAFKA_CONNECT_URL/connectors?expand=status" |
  jq -c -M 'map({name: .status.name } +  {tasks: .status.tasks}) | .[] | {task: ((.tasks[]) + {name: .name})}  | select(.task.state=="FAILED") | {name: .task.name, task_id: .task.id|tostring} | ("/connectors/"+ .name + "/tasks/" + .task_id + "/restart")' |
  xargs -I{connector_and_task} curl -v -X POST "$KAFKA_CONNECT_URL"\{connector_and_task\}
