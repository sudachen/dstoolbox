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
 && ln -s ${HOME}/.config/gcloud ${HOME}/content/.config 

ENV CLOUDSDK_ROOT_DIR=$GCLOUD_DIR \
    CLOUDSDK_PYTHON=$CONDA_DIR/envs/python27/bin/python2 \
    PATH=$PATH:$GCLOUD_DIR/bin \
    DATALAB_ROOT=$HOME 

# Spark

ENV APACHE_SPARK_VERSION=2.3.1 \
    HADOOP_VERSION=2.7 \
    SPARK_HOME=/opt/spark \
    PYTHONPATH=/opt/spark/python:/opt/spark/python/lib/py4j-0.10.6-src.zip \
    SPARK_XMX=2048M

USER root

RUN mkdir ${SPARK_HOME} \
 && apt-get install --no-install-recommends -qy \
        time \
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

# Additional modules 

RUN conda install -y \
        'py4j==0.10.7' \
 && conda clean -tipsy

RUN pip install -U --no-cache-dir pyspark \
 && pip install -U --no-cache-dir git+git://github.com/sudachen/spark-sklearn#egg=version_subpkg\&subdirectory=python \
 && pip install -U --no-cache-dir git+git://github.com/sudachen/ipython-sql \
 && pip install -U --no-cache-dir git+git://github.com/sudachen/PyDrive 

USER root
RUN ln -s ${HOME}/work /Files
USER $NB_USER  

ENV SPARK_OPTS=\
        --driver-java-options=-Xms1024M \
        --driver-java-options=-Xmx$SPARK_XMX \
        --driver-java-options=-Dlog4j.logLevel=info

USER $NB_UID

# GitHub

RUN jupyter labextension install @jupyterlab/github \
 && pip install --no-cache-dir jupyterlab_github \
 && jupyter serverextension enable --py jupyterlab_github 

RUN jupyter labextension install jupyterlab-drawio

#ENV JUPYTER_SCALA_HOME /opt/jupyter-scala
#user root
#RUN git clone https://github.com/jupyter-scala/jupyter-scala.git ${JUPYTER_SCALA_HOME} \
# && chown $NB_USER -R ${JUPYTER_SCALA_HOME} 
#user $NB_UID
#RUN cd ${JUPYTER_SCALA_HOME} \
# && bash ./jupyter-scala	

# Git

#RUN mkdir -p .build && cd .build \
# && git clone https://github.com/jupyterlab/jupyterlab-git.git \
# && cd jupyterlab-git \
# && npm install \
# && npm run build \
# && jupyter labextension link . \
# && pip install . \
# && jupyter serverextension enable --py jupyterlab_git 

# DrawIO
#RUN mkdir -p .build && cd .build \
# && git clone https://github.com/sudachen/jupyterlab-drawio.git \
# && cd jupyterlab-drawio \
# && npm install \
# && npm run build \
# && jupyter labextension link . \
# && npm cache clean --force
