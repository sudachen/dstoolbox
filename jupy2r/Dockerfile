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

# NVIDIA CUDA

USER root

# nvidia-docker 1.0
LABEL com.nvidia.volumes.needed="nvidia_driver"
LABEL com.nvidia.cuda.version="9.2"
LABEL com.nvidia.cudnn.version="7.2"
# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.2"

RUN conda install pytorch torchvision cuda92 -c pytorch && conda clean -tipsy

ENV BLAS /usr/lib/libopenblas.a 
ENV LAPACK /usr/lib/libopenblas.a 
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/conda/lib 

USER root

RUN  apt-get install -y --no-install-recommends \
		tcl \
		tk \
		gfortran \
		libfreetype6-dev \
		pkg-config \
		libopenblas-dev \
&&   apt-get clean

RUN set -ex \
&&  wget -O pypy.tar.bz2 https://bitbucket.org/squeaky/portable-pypy/downloads/pypy3.5-6.0.0-linux_x86_64-portable.tar.bz2 \
&&  mkdir /opt/pypy \
&&  tar -xjC /opt/pypy --strip-components=1 -f pypy.tar.bz2 \
&&  find /opt/pypy/lib-python -depth -type d -a \( -name test -o -name tests \) -exec rm -rf '{}' + \
&&  ln -s /opt/pypy/bin/pypy3 /usr/local/bin \
&&  rm pypy.tar.bz2 

RUN set -ex \
&&  wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \
&&  pypy3 get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
&&  ln -s /opt/pypy/bin/pip /usr/local/bin/pipy3 \
&&  rm get-pip.py

RUN chown -R $NB_USER /opt/pypy && fix-permissions /opt/pypy/
USER $NB_USER

RUN BLAS=/usr/lib/libopenblas.a LAPACK=/usr/lib/libopenblas.a \
    pipy3 install --no-cache-dir \
        requests selenium \
        pytest ipython jupyter \
        numpy matplotlib pandas Pillow \ 
        Cython scipy scikit-learn scikit-image \
        pydrive psycopg2 pymysql sqlalchemy \
        google-api-python-client oauth2client pexpect pyotp \
        scrapy ipywidgets sqlalchemy-redshift \
        pystan fbprophet \
        python-Levenshtein \
        git+git://github.com/sudachen/colabtools \
        git+https://github.com/sudachen/pygdrive-funcs.git#egg=gdrive \
        git+git://github.com/sudachen/ipython-sql

RUN pypy3 -m ipykernel install --user --name "PyPy6-3.5" --display-name "PyPy 3"

RUN pip install --no-cache-dir \
        python-Levenshtein \
        git+https://github.com/sudachen/pygdrive-funcs.git#egg=gdrive  

#RUN conda install tensorflow-gpu && conda clean -tipsy
#RUN jupyter labextension install jupyterlab-drawio

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
