# **docker-impala-kudu**
___

### Description
___

This image runs [*Apache Impala*](https://impala.incubator.apache.org/) and [*Apache Kudu*](https://kudu.apache.org/). The image is based on the latest .

The *latest* tag of this image is build with the Cloudera Impala & Kudu distributions.

You can pull it with:

    docker pull mcapitanio/impala-kudu


You can also find other images based on different Apache HBase releases, using a different tag in the following form:

    docker pull mcapitanio/impala-kudu:[kudu-release]


For example, if you want Impala with Kudu release 1.0.0 you can pull the image with:

    docker pull mcapitanio/impala-kudu:1.0.0

Run with Docker Compose:

    docker-compose -p docker up

Setting the project name to *docker* (or something else) with the **-p** option is useful to run different containers belonging to the same network and having the relative hostnames shared.

IMPORTANT: To run this Docker you also need to pull the [*Hive*](https://hub.docker.com/r/mcapitanio/hive/) image and following the instruction: Impala searches for the Hive Metastore to start.

Once started you'll be able to access to the following UIs:

| **HBase Web UIs**           |**URL**                    |
|:----------------------------|:--------------------------|
| *Kudu Master*               | http://localhost:8051     |
| *Kudu Tablet Server*        | http://localhost:8050     |
| *Impala State Store Server* | http://localhost:25010    |
| *Impala Catalog Server*     | http://localhost:25020    |
| *Impala Server Daemon*      | http://localhost:25000    |

### Available tags:

- Impala 2.7.0 & Kudu 1.1.0 ([1.1.0](https://github.com/mcapitanio/docker-impala-kudu/blob/1.1.0/Dockerfile), [latest](https://github.com/mcapitanio/docker-impala-kudu/blob/latest/Dockerfile))
- Impala 2.7.0 & Kudu 1.0.0 ([1.0.0](https://github.com/mcapitanio/docker-impala-kudu/blob/1.0.0/Dockerfile))
