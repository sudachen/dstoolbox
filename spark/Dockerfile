FROM sudachen/jupyter:latest

# Spark

ENV APACHE_SPARK_VERSION=2.3.1 \
    HADOOP_VERSION=2.7 \
    SPARK_HOME=/opt/spark \
    PYTHONPATH=/opt/spark/python:/opt/spark/python/lib/py4j-0.10.6-src.zip \
    SPARK_XMX=2048M

ENV SPARK_OPTS=\
        --driver-java-options=-Xms1024M \
        --driver-java-options=-Xmx$SPARK_XMX \
        --driver-java-options=-Dlog4j.logLevel=info

USER root

RUN mkdir ${SPARK_HOME} \
 && apt-get install --no-install-recommends -qy \
        openjdk-8-jre-headless \
        ca-certificates-java \
 && apt-get clean 

RUN cd /tmp \
 && wget http://apache.claz.org/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
 && tar xzf spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C ${SPARK_HOME} --strip-components=1 \
 && rm spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
 && chown $NB_USER ${SPARK_HOME} \
 && fix-permissions ${SPARK_HOME}

USER $NB_USER  

RUN pip install -U --no-cache-dir 'py4j==0.10.7' pyspark \
 && pip install -U --no-cache-dir git+git://github.com/sudachen/spark-sklearn#egg=spark_sklearn\&subdirectory=python 
