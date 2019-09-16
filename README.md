Apache Drill Docker
===================

A Docker image of [Apache Drill](https://drill.apache.org/).

This Docker image adds support to query S3 buckets using [AWS Signature Version 4](https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-authenticating-requests.html) (in regions like `eu-west-2` etc.).

It supports clustered mode using Zookeeper, as long as the optional `ZOOKEEPER_HOST` environment variable is set.
If not set, Drill starts in embedded mode.

## Configuration

### System configuration

Optional parameters (provided as environment variables):

| **Environment variable** | **Description**                                                                                                                       | **Default value** |
|:-------------------------|:--------------------------------------------------------------------------------------------------------------------------------------|:------------------|
| `HEAP_MEMORY_FRACTION`   | Sets the [`MaxRAMFraction` JVM parameter](##Heap-memory) that configures the default Java heap memory size.                           | `2`               |
| `LOG_LEVEL`              | The [log level to use](https://logback.qos.ch/manual/architecture.html#effectiveLevel).                                               | `INFO`            |
| `CLUSTERED_MODE`         | Boolean value, indicating whether Drill should run in clustered mode. More information on [clustered mode](## Clustered mode) below.  | `false`           |

### Configuration options

#### Configuration via environment variables

In this mode, environment variables can be defined to override the default configuration.

| **Environment variable** | **Description**                                                                         | **Default value** |
|:---------------------------|:--------------------------------------------------------------------------------------|:------------------|
| `ZOOKEEPER_HOST`           | Zookeeper host and port. Setting it will automatically start Drill in clustered mode. | *(None)*          |
| `DRILL_EXEC_*`             | Various execution options, described in details below.                                | *(None)*          |

All execution options can be set by using environment variables.
The option name has to be transformed into an environment variable with upper-case characters and underscrores instead of dots in its name. In addition, the prefix `DRILL_EXEC_` needs to be added. Example: the `store.parquet.reader.columnreader.async` will become `DRILL_EXEC_STORE_PARQUET_READER_COLUMNREADER_ASYNC`.

#### Configuration via mounted configuration file

The `drill-override.conf` file can be mounted under `/opt/drill/conf/drill-override.conf`. Using this method does not require to set environment variables.

## Clustered mode

Drill can be started in a clustered mode. Clustered mode requires Zookeeper running.
The `CLUSTERED_MODE` environment variable must be set to `true` to start Drill in clustered mode.
Clustered mode requires Zookeeper to be running therefore either the `ZOOKEEPER_HOST` environment variable must be set or a valid `zk.connect` parameter must be provided in a mounted `drill-override.conf` file.

## Heap memory

### Explanation

The heap memory used by the Java Virtual Machine (JVM) is configured either through
- the `Xms` and `Xmx` parameters
- if they are missing then it uses the default heap size

The default heap size is configured via the `MaxRAMFraction` JVM parameter. It represents a fraction of the total available memory on the machine.
This value is the denominator value under 1, i. e. `1/MaxRAMFraction`.
For example, setting this value to 4 will result in the JVM to use 25% of the available memory as heap (1/4 of the available memory).

### Default heap space

According to the documentation, [Configuring Drill Memory](https://drill.apache.org/docs/configuring-drill-memory/), *the default memory for a Drillbit is 8G*. Given that the default heap memory is [set to 4GB](https://github.com/apache/drill/blob/e9c7f51e8a6b4c4be95fc3aef05b89596414e98d/distribution/src/resources/drill-config.sh#L299), it is assumed that the intention is to use half of the available memory as heap space.
