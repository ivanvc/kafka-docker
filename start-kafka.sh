#!/bin/bash

zk_hosts=
[[ -v ZK_PORT_2181_TCP_ADDR ]] && zk_hosts=$ZK_PORT_2181_TCP_ADDR 

i=1
while [ -v ZK_${i}_PORT_2181_TCP_ADDR ] ; do
  zk_host=$(eval echo "\$ZK_${i}_PORT_2181_TCP_ADDR")
  if [ -z "$zk_hosts" ] ; then
    zk_hosts=$zk_host
  else
    zk_hosts=$zk_hosts,$zk_host
  fi
  i=$(expr $i + 1)
done

sed -r -i "s/(zookeeper.connect)=(.*)/\1=$zk_hosts/g" $KAFKA_HOME/config/server.properties
sed -r -i "s/(broker.id)=(.*)/\1=$BROKER_ID/g" $KAFKA_HOME/config/server.properties
sed -r -i "s/#(advertised.host.name)=(.*)/\1=$HOST_IP/g" $KAFKA_HOME/config/server.properties
sed -r -i "s/^(port)=(.*)/\1=$PORT/g" $KAFKA_HOME/config/server.properties

$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
