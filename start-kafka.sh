#!/bin/bash
set -eo pipefail

export ETCD=${ETCD_PORT_10000_TCP_ADDR}:${ETCD_PORT_10000_TCP_PORT}

until confd -onetime -node $ETCD -config-file /etc/confd/conf.d/kafka.toml; do
  echo "[kafka] waiting for confd to refresh server.properties"
  sleep 5
done

$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
