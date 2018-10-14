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
 && echo ". ${CONDA_DIR}/etc/profile.d/conda.sh" >> ${HOME}/.bashrc \
 && echo "conda activate base" >> ${HOME}/.bashrc 

RUN conda install -y \
       'numpy' \
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
        fbprophet \
        geopy \
        line_profiler \
        pymc \
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

RUN conda install -y 'jupyterlab>=0.35.*' \
 && conda clean -tipsy 

RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix \
 && jupyter labextension install \
        @jupyter-widgets/jupyterlab-manager@^0.38 \
        jupyterlab_bokeh \
 && rm -rf ${CONDA_DIR}/share/jupyter/lab/staging \
 && rm -rf ${HOME}/.cache/yarn \
 && rm -rf ${HOME}/.node-gyp \
 && conda clean -tipsy \
 && npm cache clean --force 

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME ${HOME}/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" 

RUN pip install --no-cache-dir git+https://github.com/googlecolab/jupyter_http_over_ws#egg=jupyter_http_over_ws \
 && jupyter serverextension enable --py jupyter_http_over_ws 


RUN conda install -y -c https://conda.anaconda.org/menpo opencv3 \        
 && conda clean -tipsy 

# Python 2.7

RUN conda create -n python27 python=2.7 ipykernel \
 && conda install -n python27 -c conda-forge \
       'blas=*=*openblas*' \
       'numpy=1.14.*=*openblas*' \
       'pandas=0.23.*' \
       'ipywidgets=7.2.*' \
       'matplotlib=2.2.*' \
       'sqlalchemy=1.2.*' \
       'ipython-sql=0.3.*' \
       'libpq=9.6.*' \
       'psycopg2=2.7.*' \
       'pymysql=0.8.*' \
 && conda clean -tipsy 

RUN ${CONDA_DIR}/envs/python27/bin/ipython2 kernel install --user \
 && mv ${HOME}/.local/share/jupyter/kernels/python2 ${CONDA_DIR}/share/jupyter/kernels/ \
 && chmod -R go+rx ${CONDA_DIR}/share/jupyter

# R 3.4

RUN conda install -n python27 -y \
    'rpy2' \
    'r-base' \
    'r-irkernel' \
    'r-plyr' \
    'r-devtools' \
    'r-tidyverse' \
    'r-shiny' \
    'r-rmarkdown' \
    'r-forecast' \
    'r-rsqlite' \
    'r-rpostgresql' \
    'r-reshape2' \
    'r-nycflights13' \
    'r-caret' \
    'r-rcurl' \
    'r-crayon' \
    'r-randomforest' \
    'r-htmltools' \
    'r-sparklyr' \
    'r-htmlwidgets' \
    'r-hexbin' \
 && conda clean -tipsy 

RUN mv ${CONDA_DIR}/envs/python27/share/jupyter/kernels/ir ${CONDA_DIR}/share/jupyter/kernels/ \
 && chmod -R go+rx ${CONDA_DIR}/share/jupyter

ENV R_HOME=$CONDA_DIR/envs/python27/lib/R \
    PATH=$PATH:$CONDA_DIR/envs/python27/lib/R/bin

RUN conda install -y \
        graphviz \
        python-graphviz \
        pydot \
        'networkx=2.*' \
        geopy \ 
 && conda clean -tipsy \
 && pip install --no-cache-dir \
        'rpy2==2.8.6' \
        Wand 

RUN fix-permissions ${CONDA_DIR} \
 && fix-permissions ${HOME}

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
 && apt-get clean 

ADD tini-${TINI_VERSION} /usr/bin/tini
ADD jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py
RUN chmod +x /usr/bin/tini \
 && echo "jupyter ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook \
 && fix-permissions /etc/jupyter/

EXPOSE 8888
WORKDIR $HOME
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "jupyter", "lab" ]

USER $NB_UID
