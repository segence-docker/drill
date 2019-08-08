Drill Helm chart
================

Apache Drill is an open-source software framework that supports data-intensive distributed applications for interactive analysis of large-scale datasets.

## Chart Configuration

| Parameter               | Description                                           | Default                     |
| :---------------------- |:------------------------------------------------------| :---------------------------|
| `replicaCount`          | pod replicas                                          | `1`                         |
| `logLevel`              | Log level                                             | `INFO`                      |
| `heapMemoryFraction`    | Heap memory fraction                                  | 2                           |
| `image.repository`      | container image                                       | `segence/drill`             |
| `image.tag`             |                                                       | `1.16.0-1`                  |
| `image.pullPolicy`      |                                                       | `IfNotPresent`              |
| `ingress.enabled`       | Enable ingress controller resource                    | `false`                     |
| `ingress.annotations`   | Ingress annotations                                   | `[]`                        |
| `ingress.hosts`         | Hostnames                                             |                             |
| `ingress.path`          | Path within the url structure                         | `/`                         |
| `ingress.tls`           | Utilize TLS backend in ingress                        | `[]`                        |
| `resources`             | Resource requests & limits                            | ``{}`                       |
| `service.type`          |                                                       | `ClusterIP`                 |
| `service.port`          |                                                       | `8047`                      |
| `storagePlugins`        | List of storge plugins with JSON config               |                             |

Storage plugin examples (hdfs):
```
storagePlugins:
  - hadoop: {
        "type": "file",
        "connection": "hdfs://{{ .Release.Name }}-hadoop-hdfs-nn:9000",
        "config": null,
        "workspaces": {
          "root": {
            "location": "/",
            "writable": false,
            "defaultInputFormat": null,
            "allowAccessOutsideWorkspace": false
          }
        },
        "formats": {
          "parquet": {
            "type": "parquet"
          }
        },
        "enabled": true
      }
```

## Configuration for S3

This is a sample `values.yaml` configuration that can be supplied to the `helm install` command.
It shows how to use the Chart with [IAM]() role-based access control.

```
replicaCount: 4
resources:
  limits:
   cpu: 1000m
   memory: 8Gi
  requests:
   cpu: 10m
   memory: 4Gi
annotations:
  iam.amazonaws.com/role: some-iam-role-name
zookeeper:
  replicaCount: 3
  persistence:
    enabled: false
storagePlugins:
   - bucket1: {
        "type": "file",
        "connection": "s3a://bucket1",
        "config": {
          "fs.s3a.aws.credentials.provider": "com.amazonaws.auth.InstanceProfileCredentialsProvider",
          "fs.s3a.threads.max": 100,
          "fs.s3a.connection.maximum": 100,
          "fs.s3a.experimental.fadvise": "normal"
        },
        "workspaces": {
          "root": {
            "location": "/",
            "writable": false,
            "defaultInputFormat": "parquet",
            "allowAccessOutsideWorkspace": false
          },
          "some.workspace": {
            "location": "/some/subdir",
            "writable": false,
            "defaultInputFormat": "parquet",
            "allowAccessOutsideWorkspace": true
          }
        },
        "formats": {
          "parquet": {
            "type": "parquet"
          }
        },
        "enabled": true
      }
   - bucket2: {
        "type": "file",
        "connection": "s3a://bucket2",
        "config": {
          "fs.s3a.aws.credentials.provider": "com.amazonaws.auth.InstanceProfileCredentialsProvider",
          "fs.s3a.threads.max": 100,
          "fs.s3a.connection.maximum": 100,
          "fs.s3a.experimental.fadvise": "normal"
        },
        "workspaces": {
          "root": {
            "location": "/",
            "writable": false,
            "defaultInputFormat": "parquet",
            "allowAccessOutsideWorkspace": false
          }
        },
        "formats": {
          "parquet": {
            "type": "parquet"
          }
        },
        "enabled": true
      }
```
