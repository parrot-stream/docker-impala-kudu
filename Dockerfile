FROM ubuntu:16.04

MAINTAINER Matteo Capitanio <matteo.capitanio@gmail.it>

ENV IMPALA_KUDU_VER 2.7.0+cdh5.9.0
ENV KUDU_VER 1.1.0+cdh5.4.0

ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64/

USER root

WORKDIR /opt/docker

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y wget apt-transport-https python-setuptools openjdk-8-jdk apt-utils sudo iputils-ping telnet
RUN easy_install supervisor
RUN wget http://archive.cloudera.com/cdh5/one-click-install/trusty/amd64/cdh5-repository_1.0_all.deb
RUN dpkg -i cdh5-repository_1.0_all.deb
RUN wget http://archive.cloudera.com/beta/impala-kudu/ubuntu/trusty/amd64/impala-kudu/cloudera.list -O /etc/apt/sources.list.d/impala-kudu.list
RUN wget http://archive.cloudera.com/beta/kudu/ubuntu/xenial/amd64/kudu/cloudera.list -O /etc/apt/sources.list.d/kudu.list
RUN apt-get update -y
RUN apt-get install -y --allow-unauthenticated kudu=$KUDU_VER* kudu-dbg=$KUDU_VER* kudu-master=$KUDU_VER* kudu-tserver=$KUDU_VER* libkuduclient0=$KUDU_VER*
RUN apt-get install -y --allow-unauthenticated impala-kudu=$IMPALA_KUDU_VER* impala-kudu-server=$IMPALA_KUDU_VER* impala-kudu-shell=$IMPALA_KUDU_VER* impala-kudu-catalog=$IMPALA_KUDU_VER* impala-kudu-state-store=$IMPALA_KUDU_VER* 

RUN mkdir -p /var/run/hdfs-sockets; \
    chown hdfs.hadoop /var/run/hdfs-sockets
RUN mkdir -p /data/dn/
RUN chown hdfs.hadoop /data/dn

ADD etc/supervisord.conf /etc/
ADD etc/kudu/conf/tserver.gflagfile /etc/kudu/conf/
ADD etc/default/impala /etc/default/
ADD etc/hadoop/conf/core-site.xml /etc/hadoop/conf/
ADD etc/hadoop/conf/hdfs-site.xml /etc/hadoop/conf/
ADD etc/hadoop/conf/mapred-site.xml /etc/hadoop/conf/
ADD etc/hive/conf/hive-site.xml /etc/hiveconf/

# Various helper scripts
ADD bin/start-kudu.sh ./
ADD bin/start-impala.sh ./
ADD bin/supervisord-bootstrap.sh ./
ADD bin/wait-for-it.sh ./
RUN chmod +x ./*.sh
RUN chown mapred:mapred /var/log/hadoop-mapreduce

# Impala Ports
EXPOSE 21000 21050 22000 23000 24000 25010 26000 28000

##########################
# Kudu Ports
##########################
EXPOSE 8050 7050 8051 7051

##########################
# Hadoop Ports
##########################
# hdfs-default.xml ports
EXPOSE 50010 50020 50070 50075 50090 50091 50100 50105 50475 50470 8020 8485 8480 8481
# mapred-default.xml ports
EXPOSE 50030 50060 13562 10020 19888
#Yarn ports
EXPOSE 8030 8031 8032 8040 8042 8046 8047 8088 8090 8188 8190 8788 10200

ENTRYPOINT ["supervisord", "-c", "/etc/supervisord.conf", "-n"]
