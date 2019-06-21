Apache Drill Docker
===================

A Docker image of [Apache Drill](https://drill.apache.org/).

This Docker image adds support to query S3 buckets using [AWS Signature Version 4](https://docs.aws.amazon.com/AmazonS3/latest/API/sig-v4-authenticating-requests.html) (in regions like `eu-west-2` etc.).

It supports clustered mode using Zookeeper, as long as the optional `ZOOKEEPER_HOST` environment variable is set.
If not set, Drill starts in embedded mode.
