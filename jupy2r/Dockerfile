FROM sudachen/jupyter:latest
LABEL maintainer="Alexey Sudachen <alexey@sudachen.name>"

# Google Drive

ENV GCLOUD_DIR /opt/google_cloud

USER root
RUN mkdir ${GCLOUD_DIR} \
    && chown ${NB_USER}:${NB_GID} ${GCLOUD_DIR} \
    && fix-permissions ${GCLOUD_DIR} 

USER $NB_USER    

RUN curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-202.0.0-linux-x86_64.tar.gz \
	| gzip -d \
        | tar x -C ${GCLOUD_DIR} --strip-components=1 \
    && pip install -U --no-cache-dir git+git://github.com/sudachen/colabtools \
    && pip install -U --no-cache-dir google-auth portpicker \
    && mkdir -p ${HOME}/content/datalab \
    && mkdir -p ${HOME}/.config/gcloud \
    && ln -s ${HOME}/.config/gcloud ${HOME}/content/datalab/.config \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${GCLOUD_DIR}    

ENV CLOUDSDK_ROOT_DIR=$GCLOUD_DIR \
    CLOUDSDK_PYTHON=$CONDA_DIR/envs/python27/bin/python2 \
    PATH=$PATH:$GCLOUD_DIR/bin \
    DATALAB_ROOT=$HOME 

# GitHub
# DrawIO

RUN jupyter labextension install \
        @jupyterlab/github \
        jupyterlab-drawio \
    && pip install --no-cache-dir jupyterlab_github \
    && rm -rf ${CONDA_DIR}/share/jupyter/lab/staging \
    && rm -rf ${HOME}/.cache/yarn \
    && rm -rf ${HOME}/.node-gyp \
    && conda clean -tipsy \
    && npm cache clean --force \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

# Spark

ENV APACHE_SPARK_VERSION=2.3.0 \
    HADOOP_VERSION=2.7 \
    SPARK_HOME=/opt/spark \
    PYTHONPATH=/opt/spark/python:/opt/spark/python/lib/py4j-0.10.6-src.zip \
    SPARK_XMX=2048M

USER root

RUN mkdir ${SPARK_HOME} \
    && apt-get update  --fix-missing \
    && apt-get install --no-install-recommends -qy \
        time \
        openjdk-8-jre-headless \
        ca-certificates-java \
    && rm -rf /var/lib/apt/lists/* \
    && cd /tmp \
    && wget -q http://apache.claz.org/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    && tar xzf spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C ${SPARK_HOME} --strip-components=1 \
    && rm spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    && chown $NB_USER ${SPARK_HOME} \
    && fix-permissions ${SPARK_HOME}

USER $NB_USER  

# Additional modules 

RUN conda install -y \
        fbprophet \
        geopy \
        line_profiler \
        pymc \
        pyTables \
        pyspark \
        sqlalchemy-redshift \
    && conda remove -y --force qt pyqt \
    \
    && pip install -U --no-cache-dir \
        spark_sklearn \
        singleton_decorator \
        git+git://github.com/sudachen/ipython-sql@master \
        git+git://github.com/sudachen/PyDrive \
    \
    && conda clean -tipsy \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

#ENV HADOOP_FULL_VERSION=2.7.2 \
#    HADOOP_HOME=/opt/hadoop \
#    HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop \
#    PATH=$PATH:/opt/hadoop/bin
#
#USER root
#RUN mkdir ${HADOOP_HOME} \
#    && curl -sL --retry 3 \
#    "http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_FULL_VERSION}/hadoop-${HADOOP_FULL_VERSION}.tar.gz" \
#    | gunzip \
#    | tar -x -C ${HADOOP_HOME} --strip-components=1 \
#    && rm -rf ${HADOOP_HOME}/share/doc \
#    && chown $NB_USER ${HADOOP_HOME} \
#    && fix-permissions ${HADOOP_HOME}
#
#USER $NB_USER  

USER root
RUN ln -s ${HOME}/work /Files
USER $NB_USER  

ENV SPARK_OPTS=\
        --driver-java-options=-Xms1024M \
        --driver-java-options=-Xmx$SPARK_XMX \
        --driver-java-options=-Dlog4j.logLevel=info

USER $NB_UID
