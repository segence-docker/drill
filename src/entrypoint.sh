#!/usr/bin/env sh

DRILL_OVERRIDE_CONF=${DRILL_HOME}/conf/drill-override.conf
DRILL_EXEC_OPTIONS_PREFIX=DRILL_EXEC_

function write_configuration {

    if printenv | grep "^${DRILL_EXEC_OPTIONS_PREFIX}.*$" | wc -l > 0; then

        echo 'drill.exec.options: {' >> ${DRILL_OVERRIDE_CONF}

        DRILL_CONFIGS=$(printenv | grep "^${DRILL_EXEC_OPTIONS_PREFIX}.*$" | awk -F= '{print $1}')
        for config_name in ${DRILL_CONFIGS}; do
            config_key=$(echo ${config_name:${#DRILL_EXEC_OPTIONS_PREFIX}} | sed 's/_/./g' | awk '{print tolower($0)}')
            config_value=$(printenv ${config_name})
            echo "    ${config_key}: ${config_value}" >> ${DRILL_OVERRIDE_CONF}
        done

        echo '}' >> ${DRILL_OVERRIDE_CONF}
    fi
}

sed -i "s/export DRILLBIT_OPTS=\"-Xms.*/export DRILLBIT_OPTS=\"-XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=${HEAP_MEMORY_FRACTION:-2}\"/g" ${DRILL_HOME}/bin/drill-config.sh

if [[ -z "${ZOOKEEPER_HOST}" ]]; then
    echo 'No Zookeeper configured, starting in embedded mode...'
    ${DRILL_HOME}/bin/drill-embedded
else
    echo "Zookeeper host configured at ${ZOOKEEPER_HOST}, starting in clustered mode..."
    sed -i "s/zk.*/zk.connect: \"${ZOOKEEPER_HOST}\"/g" ${DRILL_OVERRIDE_CONF}
    write_configuration
    ${DRILL_HOME}/bin/drillbit.sh run
fi
