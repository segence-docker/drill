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
  - conf: {
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
