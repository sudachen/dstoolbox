FROM debian:9-slim
LABEL maintainer="Alexey Sudachen <alexey@sudachen.name>"

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
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 en_US.UTF-8

ENV CONDA_VERSION=4.5.1 \
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
    && conda config --system --prepend channels conda-forge \
    && conda config --system --set auto_update_conda false \
    && conda config --system --set show_channel_urls true \
    && conda update --all -y \
    && conda install -y 'pip=10.*' \
    && conda clean -tipsy \
    && rm -rf ${HOME}/.cache/yarn \
    && echo ". ${CONDA_DIR}/etc/profile.d/conda.sh" >> ${HOME}/.bashrc \
    && echo "conda activate base" >> ${HOME}/.bashrc 

RUN conda install -y \
       'notebook=5.5.*' \
       'jupyterlab=0.32.*' \
    && conda install -y \
       'blas=1.1=*openblas*' \
       'numpy=1.14.*=*openblas*' \
       'bokeh=0.12*' \
    && conda install -y \
       'cython=0.28*' \
       'pandas=0.23*' \
       'scipy=1.1*=*openblas*' \
       'scikit-learn=0.19*=*openblas*' \
       'sympy=1.1*' \
       'statsmodels=0.9*' \
    && conda install -y \
       'icu=58.2*' \
       'ffmpeg=3.4.1' \
       'hdf5=1.10.1' \
       'libxml2=2.9*' \
       'h5py=2.7*' \
    && conda clean -tipsy 

RUN conda install -y -c https://conda.anaconda.org/menpo opencv3 \
    && conda install -y \
       'matplotlib=2.2*' \
       'ipywidgets=7.2*' \
       'seaborn=0.8*' \
        ipyleaflet  \
	    openpyxl \      
	    geopandas \
        folium \
        rtree \
    && conda remove -y --force qt pyqt \
    && conda clean -tipsy 

RUN conda install -y \
       'cloudpickle=0.5*' \
       'dill=0.2*' \
       'vincent=0.4.*' \
       'beautifulsoup4=4.6.*' \
       'protobuf=3.*' \    
       'pydrive=1.3.*' \
       'psycopg2=2.7.*' \
       'pymysql=0.8.*' \
       'pyarrow=0.9.*' \
       'sqlalchemy=1.2.8' \
       'ipython-sql=0.3.*' \
    && conda install -y \
        xlrd \
        nodejs \
        keras \
    && conda install -y \
        numba -c numba \
    && conda clean -tipsy 

RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix \
    && jupyter labextension install @jupyter-widgets/jupyterlab-manager@^0.35 \
                                    jupyterlab_bokeh \
    && rm -rf ${CONDA_DIR}/share/jupyter/lab/staging \
    && rm -rf ${HOME}/.cache/yarn \
    && rm -rf ${HOME}/.node-gyp \
    && conda clean -tipsy \
    && npm cache clean --force 

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME ${HOME}/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" 

RUN pip install --no-cache-dir jupyter_http_over_ws \
    && jupyter serverextension enable --py jupyter_http_over_ws 

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
    && conda clean -tipsy \
    && ${CONDA_DIR}/envs/python27/bin/ipython2 kernel install --user \
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
    && conda clean -tipsy \
    && mv ${CONDA_DIR}/envs/python27/share/jupyter/kernels/ir ${CONDA_DIR}/share/jupyter/kernels/ \
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

ENV JULIA_PKGDIR=/opt/julia \
    JULIA_RC=${HOME}/.juliarc.jl \
    JULIA_VERSION=0.6.3 \
    JULIA_PKGDIR_VER=/opt/julia/v0.6 \ 
    JULIA_CACHE=/opt/julia/.cache 

USER root
RUN mkdir /opt/julia-${JULIA_VERSION} \
    && cd /tmp \
    && wget -q https://julialang-s3.julialang.org/bin/linux/x64/`echo ${JULIA_VERSION} | cut -d. -f 1,2`/julia-${JULIA_VERSION}-linux-x86_64.tar.gz \
    && tar xzf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C /opt/julia-${JULIA_VERSION} --strip-components=1 \
    && rm /tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz \
    && ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia \
    && mkdir ${JULIA_PKGDIR} \
    && chown $NB_USER ${JULIA_PKGDIR} \
    && fix-permissions ${JULIA_PKGDIR}

ADD REQUIRE $JULIA_PKGDIR_VER/REQUIRE1
ADD precompile $JULIA_PKGDIR_VER/precompile
RUN chown -R $NB_USER ${JULIA_PKGDIR}
USER $NB_UID

RUN echo "@everywhere push!(Libdl.DL_LOAD_PATH, \"${CONDA_DIR}/envs/python27/lib\")" >> ${JULIA_RC} \
    && echo "@everywhere ENV[\"PATH\"]=\"${CONDA_DIR}/envs/python27/bin:\$(ENV[\"PATH\"])\"" >> ${JULIA_RC} \
    && echo "@everywhere ENV[\"PYTHON\"]=\"${CONDA_DIR}/envs/python27/bin/python2\"" >> ${JULIA_RC} \
    && echo "@everywhere ENV[\"CONDA_DEFAULT_ENV\"]=\"python27\"" >> ${JULIA_RC} \
    && julia -e 'Pkg.init(); Pkg.update();' \
    && rm ${JULIA_PKGDIR_VER}/REQUIRE \
    && mv ${JULIA_PKGDIR_VER}/REQUIRE1 ${JULIA_PKGDIR_VER}/REQUIRE \
    && julia -e 'Pkg.resolve()' 

RUN conda install -y -n python27 \
       'scikit-learn=0.19*=*openblas*' \
    && conda clean -tipsy \
    && julia -e 'Pkg.clone("https://github.com/cstjean/ScikitLearn.jl","ScikitLearn")' \
    && julia -e 'Pkg.build("ScikitLearn"); using ScikitLearn' \
    && julia -e 'Pkg.add("Pandas"); Pkg.add("PyPlot"); using Pandas; using PyPlot' \
    && julia -e 'Pkg.add("PyCallJLD"); using PyCallJLD' \
    && julia -e 'Pkg.add("RCall"); Pkg.add("RDatasets"); using RCall; using RDatasets'

RUN chmod a+x ${JULIA_PKGDIR_VER}/precompile \ 
    && ${JULIA_PKGDIR_VER}/precompile \
    && mv ${HOME}/.local/share/jupyter/kernels/julia* ${CONDA_DIR}/share/jupyter/kernels/ \
    && chmod -R go+rx ${CONDA_DIR}/share/jupyter 

USER root

ADD tini-${TINI_VERSION} /usr/bin/tini
ADD jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py
RUN chmod +x /usr/bin/tini \
    && echo "jupyter ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook \
    && fix-permissions /etc/jupyter/
RUN bash -c "for i in {1..9}; do mkdir -p /usr/share/man/man\$i; done"

EXPOSE 8888
WORKDIR $HOME
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "jupyter", "lab" ]

USER $NB_UID
