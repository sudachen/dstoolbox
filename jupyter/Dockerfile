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
    && echo "conda activate base" >> ${HOME}/.bashrc \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

RUN conda install -y \
       'blas=*=openblas' \
       'numpy=1.13.*' \
       'notebook=5.5.*' \
       'jupyterlab=0.32.*' \
    && conda install -y \
       'ipywidgets=7.2*' \
       'cython=0.28*' \
       'pandas=0.22*' \
       'matplotlib=2.2*' \
    && conda install -y \
       'scipy=1.1*' \
       'scikit-learn=0.19*' \
       'seaborn=0.8*' \
       'sympy=1.1*' \
       'bokeh=0.12*' \
       'statsmodels=0.8*' \
       'sqlalchemy=1.2*' \
       'ipython-sql=0.3.*' \
    && conda install -y \
       'cloudpickle=0.5*' \
       'dill=0.2*' \
       'hdf5=1.10*' \
       'h5py=2.7*' \
       'vincent=0.4.*' \
       'beautifulsoup4=4.6.*' \
       'protobuf=3.*' \    
       'pydrive=1.3.*' \
       'psycopg2=2.7.*' \
       'pymysql=0.8.*' \
       'pyarrow=0.9.*' \
    && conda remove -y --force qt pyqt \
    && conda clean -tipsy \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

RUN conda install -y xlrd nodejs keras \
    && conda install -y numba -c numba \
    && conda clean -tipsy \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

RUN conda install -y ipyleaflet opencv \
    && conda remove -y --force qt pyqt \
    && conda clean -tipsy \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix \
    && jupyter labextension install @jupyter-widgets/jupyterlab-manager@^0.35 \
    && jupyter labextension install jupyterlab_bokeh \
    && rm -rf ${CONDA_DIR}/share/jupyter/lab/staging \
    && rm -rf ${HOME}/.cache/yarn \
    && rm -rf ${HOME}/.node-gyp \
    && conda clean -tipsy \
    && npm cache clean --force \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME ${HOME}/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" \
    && fix-permissions ${HOME}

RUN pip install --no-cache-dir jupyter_http_over_ws \
    && jupyter serverextension enable --py jupyter_http_over_ws \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

# R 3.4

USER root
RUN apt-get update --fix-missing \
    && apt-get install -qy --no-install-recommends \
	build-essential \
	gfortran \
	gcc \
        g++ \
    && rm -rf /var/lib/apt/lists/* 
USER $NB_USER

RUN conda install -y \
    'rpy2' \
    'r-base=3.4*' \
    'r-irkernel' \
    'r-plyr' \
    'r-devtools' \
    'r-tidyverse' \
    'r-shiny' \
    'r-rmarkdown' \
    'r-forecast' \
    'r-rsqlite' \
    'r-rpostgresql' \
    'r-rmysql' \
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
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

ENV JUPYTER_HAS_R=3.4

# Python 2.7

RUN conda create -n python27 python=2.7 ipykernel \
    && conda clean -tipsy \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

RUN conda install -n python27 -c conda-forge \
       'blas=*=openblas' \
       'numpy=1.13.*' \
       'pandas=0.22.*' \
       'ipywidgets=7.2.*' \
       'matplotlib=2.2.*' \
       'sqlalchemy=1.2.*' \
       'ipython-sql=0.3.*' \
       'libpq=9.6.*' \
       'psycopg2=2.7.*' \
       'pymysql=0.8.*' \
    && conda remove -n python27 -y --force qt pyqt \
    && conda clean -tipsy \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

RUN ${CONDA_DIR}/envs/python27/bin/ipython2 kernel install --user \
    && mv ${HOME}/.local/share/jupyter/kernels/python2 ${CONDA_DIR}/share/jupyter/kernels/ \
    && chmod -R go+rx ${CONDA_DIR}/share/jupyter \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

ENV JUPYTER_HAS_PYTHON2=2.7

USER root

#ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini /usr/bin/tini
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
