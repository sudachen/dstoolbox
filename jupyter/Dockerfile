FROM debian:9-slim
LABEL maintainer="Alexey Sudachen <alexey@sudachen.name>"

ENV FULLREBUILD 20181012
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

USER $NB_UID

RUN mkdir ${HOME}/work \
 && wget https://repo.continuum.io/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ${HOME}/miniconda.sh \
 && ${SHELL} ${HOME}/miniconda.sh -f -b -p ${CONDA_DIR} \
 && rm ${HOME}/miniconda.sh \
 && conda config --system --append channels conda-forge \
 #&& conda config --system --prepend channels intel \
 && conda config --system --set show_channel_urls true \
 && conda install 'python=3.6.6' \
 && conda update --all -y \
 && conda clean -tipsy \
 && rm -rf ${HOME}/.cache/yarn \
 && echo ". ${CONDA_DIR}/etc/profile.d/conda.sh" >> ${HOME}/.bashrc 
 #&& echo "conda activate base" >> ${HOME}/.bashrc 

RUN conda install -y \
       'numpy=1.14.6' \
       'xarray<=0.10.7' \
       altair \
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
  && conda clean -tipsy 

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
       'sqlalchemy>=1.2.8' \
       'ipython-sql>=0.3' \
 && conda clean -tipsy 

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
 && conda clean -tipsy 

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
 && conda clean -tipsy 

# PyDOT

RUN conda install -y \
        graphviz \
        python-graphviz \
        pydot \
        'networkx=2.*' \
        geopy \ 
 && conda clean -tipsy 

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
 && conda clean -tipsy 

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

ADD tini-${TINI_VERSION} /usr/bin/tini
ADD jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py
RUN chmod +x /usr/bin/tini \
 && echo "jupyter ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook \
 && fix-permissions /etc/jupyter/

USER $NB_UID

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
 && npm cache clean --force 

EXPOSE 8888
WORKDIR $HOME
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "jupyter", "lab" ]

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

# NVIDIA/PyTorch

LABEL com.nvidia.volumes.needed="nvidia_driver"
LABEL com.nvidia.cuda.version="9.2"
LABEL com.nvidia.cudnn.version="7.2"
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.2"

RUN conda install pytorch torchvision cuda92 -c pytorch && conda clean -tipsy

# Other 

USER root

RUN apt-get install -y --no-install-recommends \
        swig \
 && apt-get clean

USER $NB_USER    

RUN pip install -U --no-cache-dir \
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

