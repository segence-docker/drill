Drill Helm chart
================

Apache Drill is an open-source software framework that supports data-intensive distributed applications for interactive analysis of large-scale datasets.

## Pre Requisites:

* Kubernetes 1.5

* Requires at least `v2.0.0-beta.1` version of helm to support
  dependency management with requirements.yaml

## StatefulSet Details

* https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/

## StatefulSet Caveats

* https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#limitations

## Chart Details

This chart will do the following:

* Implement a dynamically scalable Drill cluster using Kubernetes StatefulSets

* Implement a dynamically scalable Zookeeper cluster as another Kubernetes StatefulSet required for the Drill cluster above

### Installing the Chart

To install the chart with the release name `my-drill` in the default
namespace:

```
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com
$ helm install --name my-drill ./drill
```

If using a dedicated namespace(recommended) then make sure the namespace
exists with:

```
$ helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com
$ kubectl create ns drill
$ helm install --name my-drill --namespace drill ./drill
```

## Chart Configuration

This chart includes a ZooKeeper chart as a dependency to the Drill
cluster in its `requirement.yaml` by default. The chart can be customized using the
following configurable parameters:

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
| `execOptions`           | Various execution options                             | `{}`                        |
| `storagePlugins`        | List of storge plugins with JSON config               | `{}`                        |

Execution options examples:
```
execOptions:
  "store.parquet.reader.columnreader.async": true
```

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
