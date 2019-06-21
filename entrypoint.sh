#!/usr/bin/env sh

if [[ -z "${ZOOKEEPER_HOST}" ]]; then
    echo 'No Zookeeper configured, starting in embedded mode...'
    ${DRILL_HOME}/bin/drill-embedded
else
    echo "Zookeeper host configured at ${ZOOKEEPER_HOST}, starting in clustered mode..."
    sed -i "s/zk.*/zk.connect: \"${ZOOKEEPER_HOST}\"/g" ${DRILL_HOME}/conf/drill-override.conf
    ${DRILL_HOME}/bin/drillbit.sh start
    sleep infinity
fi
