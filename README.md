Apache Drill Docker
===================

A Docker image of [Apache Drill](https://drill.apache.org/).

This Docker image adds support to query S3 buckets using [AWS Signature Version 4](https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-authenticating-requests.html) (in regions like `eu-west-2` etc.).

It supports clustered mode using Zookeeper, as long as the optional `ZOOKEEPER_HOST` environment variable is set.
If not set, Drill starts in embedded mode.

## Configuration

Optional parameters (provided as environment variables):

| **Environment variable** | **Description**                                                                                                      | **Default value** |
|:---------------------------|:-------------------------------------------------------------------------------------------------------------------|:------------------|
| `HEAP_MEMORY_FRACTION`     | Sets the [`DefaultMaxRAMFraction` JVM parameter](##Heap-memory) that configures the default Java heap memory size. | `2`               |
| `LOG_LEVEL`                | The [log level to use](https://logback.qos.ch/manual/architecture.html#effectiveLevel).                            | `INFO`            |
| `ZOOKEEPER_HOST`           | Zookeeper host and port.                                                                                           | *(None)*          |

## Heap memory

### Explanation

The heap memory used by the Java Virtual Machine (JVM) is configured either through
- the `Xms` and `Xmx` parameters
- if they are missing then it uses the default heap size

The default heap size is configured via the `DefaultMaxRAMFraction` JVM parameter. It represents a fraction of the total available memory on the machine.
This value is the denominator value under 1, i. e. `1/DefaultMaxRAMFraction`.
For example, setting this value to 4 will result in the JVM to use 25% of the available memory as heap (1/4 of the available memory).

### Default heap space

According to the documentation, [Configuring Drill Memory](https://drill.apache.org/docs/configuring-drill-memory/), *the default memory for a Drillbit is 8G*. Given that the default heap memory is [set to 4GB](https://github.com/apache/drill/blob/e9c7f51e8a6b4c4be95fc3aef05b89596414e98d/distribution/src/resources/drill-config.sh#L299), it is assumed that the intention is to use half of the available memory as heap space.
