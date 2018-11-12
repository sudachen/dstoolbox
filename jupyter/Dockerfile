FROM debian:9-slim
LABEL maintainer="Alexey Sudachen <alexey@sudachen.name>"

ENV FULLREBUILD 20181110
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update --fix-missing \
 && apt-get install -qy --no-install-recommends \
    ca-certificates \
    wget \
    git \	
    bash \
    sudo \
    unzip \
    bzip2 \
    tzdata \
    locales \
    libsm6 \
    libxt6 \
    libxrender1 \
    fonts-dejavu \
    fonts-liberation \
    procps \
    \
    build-essential \
    gfortran \
    gcc \
    g++ \
    \
    libpq5 \
    libpq-dev \
    hdf5-tools \
    libhdf5-dev \
    sqlite3 \
    libsqlite3-dev \
    imagemagick \
    libreadline-dev \
    spatialite-bin \
    libgtk2.0-0 \
    libfreetype6-dev \
    curl \
    && rm -rf /var/lib/apt/lists/* \
 && localedef -i en_US -c -f UTF-8 en_US.UTF-8

ENV CONDA_VERSION=4.5.11 \
    TINI_VERSION=0.16.1 \
    CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER=jupyter \
    NB_UID=1000 \
    NB_GID=100 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    PATH=/opt/conda/bin:$PATH \
    HOME=/home/jupyter \
    TZ=America/Santiago

ADD fix-permissions /usr/local/bin/fix-permissions
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone \
 && chmod a+x /usr/local/bin/fix-permissions \
 && useradd -m -s ${SHELL} -N -u ${NB_UID} ${NB_USER} \
 && mkdir -p ${CONDA_DIR} \
 && chown ${NB_USER}:${NB_GID} ${CONDA_DIR} \
 && chmod g+w /etc/passwd /etc/group \
 && fix-permissions ${HOME} \
 && fix-permissions ${CONDA_DIR}

USER $NB_USER

RUN mkdir ${HOME}/work \
 && curl -L https://repo.continuum.io/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -o ${HOME}/miniconda.sh \
 && ${SHELL} ${HOME}/miniconda.sh -f -b -p ${CONDA_DIR} \
 && rm ${HOME}/miniconda.sh \
 && conda config --system --append channels conda-forge \
 #&& conda config --system --prepend channels intel \
 && conda config --system --set show_channel_urls true \
 && conda install 'python=3.6.6' \
 && conda update --all -y \
 && conda clean -tipsy \
 && rm -rf ${HOME}/.cache/yarn \
 && rm -rf ${CONDA_DIR}/pkgs/* \
 && echo ". ${CONDA_DIR}/etc/profile.d/conda.sh" >> ${HOME}/.bashrc 
 #&& echo "conda activate base" >> ${HOME}/.bashrc 

RUN conda install -y \
       'numpy=1.14.6' \
       'xarray<=0.10.7' \
       'pandas' \
       'scipy' \
       'scikit-learn' \
       'sympy' \
       'matplotlib' \
       'notebook>=5.5' \
       'bokeh>=0.12' \
       'cython>=0.28' \
       'statsmodels>=0.9' \
       'icu=58.2*' \
       'hdf5' \
       'libxml2>=2.9' \
       'h5py' \
        ipywidgets \
        seaborn \
        ipyleaflet  \
        openpyxl \
        geopandas \
        folium \
        rtree \
  && conda clean -tipsy \
  && rm -rf ${CONDA_DIR}/pkgs/*

RUN conda install -y \
       'cloudpickle=0.5*' \
       'dill=0.2*' \
       'vincent=0.4.*' \
       'beautifulsoup4>=4.6' \
       'protobuf>=3.0' \    
       'pydrive>=1.3' \
       psycopg2 \
       pymysql \
       'pyarrow>=0.9' \
       jemalloc \
       'sqlalchemy>=1.2.8' \
       'ipython-sql>=0.3' \
 && conda clean -tipsy \
 && rm -rf ${CONDA_DIR}/pkgs/* 

RUN conda install -y \
        pytables \
        xlrd \
        nodejs \
        numba \
        pexpect \
        scrapy \
        geopy \
        line_profiler \
        sqlalchemy-redshift \
 && conda clean -tipsy \
 && rm -rf ${CONDA_DIR}/pkgs/*

RUN pip install -U --no-cache-dir pip

RUN pip install -U --no-cache-dir \
        pyotp \
        'alembic>=0.9' \
        'flask>=0.12.2' \
        'flask-sqlalchemy>=2.3.2' \
        'flask-migrate>=2.0' \
        'flask-oauthlib>=0.9.4' \
        'flask-script>=2.0' \
        'flask-admin>=1.5.1' \
        'google-api-python-client>=1.6' \
        'oauth2client>=4.1' \
        'requests>=2.18' \
        singleton_decorator

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME ${HOME}/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" 

# OpenCV

RUN conda install -y -c https://conda.anaconda.org/menpo opencv3 \        
 && conda clean -tipsy \
 && rm -rf ${CONDA_DIR}/pkgs/* 

# PyDOT

RUN conda install -y \
        graphviz \
        python-graphviz \
        pydot \
        'networkx=2.*' \
        geopy \ 
 && conda clean -tipsy \
 && rm -rf ${CONDA_DIR}/pkgs/*

# Python 2.7

RUN conda create -n python27 python=2.7 \
 && conda install -n python27 -c conda-forge \
       'blas=*=*openblas*' \
       'numpy=1.14.*=*openblas*' \
       'pandas=0.23.*' \
       'sqlalchemy=1.2.*' \
       'libpq=9.6.*' \
       'psycopg2=2.7.*' \
       'pymysql=0.8.*' \
 && conda clean -tipsy \
 && rm -rf ${CONDA_DIR}/pkgs/*

# Utils

USER root

RUN bash -c "for i in {1..9}; do mkdir -p /usr/share/man/man\$i; done" \
 && apt-get update --fix-missing \
 && apt-get install -y --no-install-recommends \
        mysql-client \
        mysql-utilities \
        postgresql-client \
        gnupg2 \
        ssh \
        apt-transport-https \
        openvpn \
        net-tools \
        iputils-ping \
        dnsutils \
        joe \
        zbar-tools \
        curl \
        file \
        mesa-opencl-icd ocl-icd-opencl-dev opencl-headers \
        clinfo \
        libclblas-dev \
        time \
 && apt-get clean 

USER $NB_USER

# JupyterLab

RUN pip install -U --no-cache-dir 'jupyterlab>=0.35.*' \
 && jupyter nbextension enable --py widgetsnbextension --sys-prefix \
 && jupyter labextension install \
        @jupyter-widgets/jupyterlab-manager@^0.38 \
        jupyterlab_bokeh \
 && jupyter labextension install @jupyterlab/github \
 && pip install --no-cache-dir jupyterlab_github \
 && jupyter serverextension enable --py jupyterlab_github \
 && pip install --no-cache-dir git+https://github.com/googlecolab/jupyter_http_over_ws#egg=jupyter_http_over_ws \
 && jupyter serverextension enable --py jupyter_http_over_ws \
 && rm -rf ${CONDA_DIR}/share/jupyter/lab/staging \
 && rm -rf ${HOME}/.cache/yarn \
 && rm -rf ${HOME}/.node-gyp \
 && conda clean -tipsy \
 && npm cache clean --force \
 && rm -rf ${CONDA_DIR}/pkgs/* 

EXPOSE 8888
WORKDIR $HOME
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "jupyter", "lab" ]

# NVIDIA/PyTorch

LABEL com.nvidia.volumes.needed="nvidia_driver"
LABEL com.nvidia.cuda.version="9.2"
LABEL com.nvidia.cudnn.version="7.2"
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.2"

RUN conda install pytorch torchvision cuda92 -c pytorch \
 && conda clean -tipsy \
 && rm -rf ${CONDA_DIR}/pkgs/*

USER root

RUN  apt-get install -y --no-install-recommends \
        libatlas-base-dev \
        tcl \
        tk \
        gfortran \
        libfreetype6-dev \
        pkg-config \
        libopenblas-dev \
        swig \
        p7zip-full \
        openjdk-8-jre-headless \
        ca-certificates-java \
&&   apt-get clean

#PyPy6 3.5

USER root

RUN mkdir /opt/pypy \
 && ln -s /opt/pypy/bin/pypy3 /usr/local/bin \
 && ln -s /opt/pypy/bin/pip /usr/local/bin/pipy3 \
 && chown -R $NB_USER /opt/pypy \
 && fix-permissions /opt/pypy/

USER $NB_USER

ENV PYPY_GC_MAX: 1.99GB
ENV PYPY_GC_MAJOR_COLLECT: 1.2

# RUN wget -O pypy.tar.bz2 https://bitbucket.org/squeaky/portable-pypy/downloads/pypy3.5-6.0.0-linux_x86_64-portable.tar.bz2 \
# &&  tar -xjC /opt/pypy --strip-components=1 -f pypy.tar.bz2 \
# &&  find /opt/pypy/lib-python -depth -type d -a \( -name test -o -name tests \) -exec rm -rf '{}' + \
# &&  rm pypy.tar.bz2 

# RUN wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \
# &&  pypy3 get-pip.py \
# 		--disable-pip-version-check \
# 		--no-cache-dir \
# &&  rm get-pip.py

#RUN BLAS=/usr/lib/libopenblas.a LAPACK=/usr/lib/libopenblas.a \
#    pipy3 install --no-cache-dir \
#        requests selenium \
#        pytest ipython jupyter \
#         numpy matplotlib pandas Pillow \ 
#         Cython scipy scikit-learn scikit-image \
#         pydrive psycopg2 pymysql sqlalchemy \
#         google-api-python-client oauth2client pexpect pyotp \
#         scrapy ipywidgets sqlalchemy-redshift \
#         pystan fbprophet 

# RUN pypy3 -m ipykernel install --user --name "PyPy6-3.5" --display-name "PyPy 3"

# RUN pipy3 install -U --no-cache-dir \
#         python-Levenshtein \
#         git+git://github.com/sudachen/colabtools \
#         git+https://github.com/sudachen/pygdrive-funcs.git#egg=gdrive \ 
#         git+git://github.com/sudachen/ipython-sql \
#         git+git://github.com/sudachen/PyDrive 

RUN curl -o /tmp/pypy.7z -L https://github.com/sudachen/dstoolbox/releases/download/1.23/pypy-3.5.7z \
 &&  cd / && 7z x /tmp/pypy.7z \
 &&  rm /tmp/pypy.7z 

RUN pypy3 -m ipykernel install --user --name "PyPy6-3.5" --display-name "PyPy 3"
COPY logo-32x32.png logo-64x64.png $HOME/.local/share/jupyter/kernels/pypy6-3.5/

# Other 

USER $NB_USER    

RUN pip install -U --no-cache-dir \
        py4j \
        pythran \
        pybind11 \
        pyopencl \
        pyclblas \
        python-Levenshtein \
        pymc \
        pystan \
        fbprophet \
        vega_datasets \
        pydataset \
        Wand \
        git+https://github.com/sudachen/colabtools \
        git+https://github.com/sudachen/PyDrive \
        git+https://github.com/sudachen/pygdrive-funcs.git#egg=gdrive \ 
        git+https://github.com/sudachen/ipython-sql 

# COLAB

ENV GCLOUD_DIR /opt/google_cloud

USER root

RUN mkdir ${GCLOUD_DIR} \
 && chown ${NB_USER}:${NB_GID} ${GCLOUD_DIR} \
 && fix-permissions ${GCLOUD_DIR} 

USER $NB_USER    

RUN curl https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-202.0.0-linux-x86_64.tar.gz \
    | gzip -d \
    | tar x -C ${GCLOUD_DIR} --strip-components=1 \
 && pip install -U --no-cache-dir google-auth portpicker \
 && mkdir -p ${HOME}/content/datalab \
 && mkdir -p ${HOME}/.config/gcloud \
 && ln -s ${HOME}/.config/gcloud ${HOME}/content/datalab/.config \
 && ln -s ${HOME}/.config/gcloud ${HOME}/content/.config 

ENV CLOUDSDK_ROOT_DIR=$GCLOUD_DIR \
    CLOUDSDK_PYTHON=$CONDA_DIR/envs/python27/bin/python2 \
    PATH=$PATH:$GCLOUD_DIR/bin \
    DATALAB_ROOT=$HOME 

RUN pip install -U --no-cache-dir jupyterlab-git \
 && jupyter serverextension enable --py jupyterlab_git \
 && jupyter labextension install \
        @jupyterlab/mp4-extension \
        @jupyterlab/google-drive \
 && rm -rf ${CONDA_DIR}/share/jupyter/lab/staging \
 && rm -rf ${HOME}/.cache/yarn \
 && rm -rf ${HOME}/.node-gyp \
 && conda clean -tipsy \
 && npm cache clean --force 

RUN conda install -y \
        xtensor-python \
 && conda clean -tipsy \
 && rm -rf ${CONDA_DIR}/pkgs/*

RUN  jupyter labextension install \
       @jupyterlab/git \
 && conda clean -tipsy \
 && npm cache clean --force \
 && rm -rf ${CONDA_DIR}/pkgs/* 

# Spark

# ENV APACHE_SPARK_VERSION=2.3.1 \
#     HADOOP_VERSION=2.7 \
#     SPARK_HOME=/opt/spark \
#     PYTHONPATH=/opt/spark/python:/opt/spark/python/lib/py4j-0.10.6-src.zip \
#     SPARK_XMX=2048M

# ENV SPARK_OPTS=\
#         --driver-java-options=-Xms1024M \
#         --driver-java-options=-Xmx$SPARK_XMX \
#         --driver-java-options=-Dlog4j.logLevel=info

# USER root

# RUN cd /tmp \
#  && mkdir ${SPARK_HOME} \
#  && wget http://apache.claz.org/spark/spark-${APACHE_SPARK_VERSION}/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
#  && tar xzf spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C ${SPARK_HOME} --strip-components=1 \
#  && rm spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
#  && chown $NB_USER ${SPARK_HOME} \
#  && fix-permissions ${SPARK_HOME}

# USER $NB_USER  

# RUN pip install -U --no-cache-dir pyspark \
#  && pip install -U --no-cache-dir git+git://github.com/sudachen/spark-sklearn#egg=spark_sklearn\&subdirectory=python 

USER root

ADD tini-${TINI_VERSION} /usr/bin/tini
ADD jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py
RUN chmod +x /usr/bin/tini \
 && echo "jupyter ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook \
 && fix-permissions /etc/jupyter/

USER $NB_USER

