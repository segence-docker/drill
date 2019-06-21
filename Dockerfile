FROM drill/apache-drill:1.16.0

ENV DRILL_HOME=/opt/drill

WORKDIR ${DRILL_HOME}/jars/3rdparty/

RUN rm ${DRILL_HOME}/jars/3rdparty/aws-java-sdk-1.7.4.jar
RUN curl -O http://central.maven.org/maven2/com/amazonaws/aws-java-sdk-core/1.10.6/aws-java-sdk-core-1.10.6.jar
RUN curl -O http://central.maven.org/maven2/com/amazonaws/aws-java-sdk-kms/1.10.6/aws-java-sdk-kms-1.10.6.jar
RUN curl -O http://central.maven.org/maven2/com/amazonaws/aws-java-sdk-s3/1.10.6/aws-java-sdk-s3-1.10.6.jar
RUN rm ${DRILL_HOME}/jars/3rdparty/hadoop-annotations-2.7.4.jar
RUN curl -O http://central.maven.org/maven2/org/apache/hadoop/hadoop-annotations/2.8.0/hadoop-annotations-2.8.0.jar
RUN rm ${DRILL_HOME}/jars/3rdparty/hadoop-auth-2.7.4.jar
RUN curl -O http://central.maven.org/maven2/org/apache/hadoop/hadoop-auth/2.8.0/hadoop-auth-2.8.0.jar
RUN rm ${DRILL_HOME}/jars/3rdparty/hadoop-aws-2.7.4.jar
RUN curl -O http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.8.0/hadoop-aws-2.8.0.jar
RUN rm ${DRILL_HOME}/jars/3rdparty/hadoop-client-2.7.4.jar
RUN curl -O http://central.maven.org/maven2/org/apache/hadoop/hadoop-client/2.8.0/hadoop-client-2.8.0.jar
RUN rm ${DRILL_HOME}/jars/3rdparty/hadoop-common-2.7.4.jar
RUN curl -O http://central.maven.org/maven2/org/apache/hadoop/hadoop-common/2.8.0/hadoop-common-2.8.0.jar
RUN rm ${DRILL_HOME}/jars/3rdparty/hadoop-hdfs-2.7.4.jar
RUN curl -O http://central.maven.org/maven2/org/apache/hadoop/hadoop-hdfs/2.8.0/hadoop-hdfs-2.8.0.jar
RUN curl -O http://central.maven.org/maven2/org/apache/htrace/htrace-core4/4.0.1-incubating/htrace-core4-4.0.1-incubating.jar

WORKDIR /

COPY entrypoint.sh /

ENTRYPOINT /entrypoint.sh
