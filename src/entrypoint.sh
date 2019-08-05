#!/usr/bin/env sh

sed -i "s/export DRILLBIT_OPTS=\"-Xms.*/export DRILLBIT_OPTS=\"-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:DefaultMaxRAMFraction=${HEAP_MEMORY_FRACTION:-2}\"/g" ${DRILL_HOME}/bin/drill-config.sh

if [[ -z "${ZOOKEEPER_HOST}" ]]; then
    echo 'No Zookeeper configured, starting in embedded mode...'
    ${DRILL_HOME}/bin/drill-embedded
else
    echo "Zookeeper host configured at ${ZOOKEEPER_HOST}, starting in clustered mode..."
    sed -i "s/zk.*/zk.connect: \"${ZOOKEEPER_HOST}\"/g" ${DRILL_HOME}/conf/drill-override.conf
    ${DRILL_HOME}/bin/drillbit.sh run
fi
