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
	libxrender1 \
	fonts-dejavu \
	fonts-liberation \
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
ADD https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone \
    && useradd -m -s ${SHELL} -N -u ${NB_UID} ${NB_USER} \
    && mkdir -p ${CONDA_DIR} \
    && chown ${NB_USER}:${NB_GID} ${CONDA_DIR} \
    && chmod g+w /etc/passwd /etc/group \
    && fix-permissions ${HOME} \
    && fix-permissions ${CONDA_DIR}

USER $NB_UID

RUN mkdir ${HOME}/work \
    && wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ${HOME}/miniconda.sh \
    && ${SHELL} ${HOME}/miniconda.sh -f -b -p ${CONDA_DIR} \
    && rm ${HOME}/miniconda.sh \
    && conda config --system --prepend channels conda-forge \
    && conda config --system --set auto_update_conda false \
    && conda config --system --set show_channel_urls true \
    && conda update --all -q -y \
    && conda install -q -y 'pip=10.*' \
    && conda clean -tipsy \
    && rm -rf ${HOME}/.cache/yarn \
    && echo ". ${CONDA_DIR}/etc/profile.d/conda.sh" >> ${HOME}/.bashrc \
    && echo "conda activate base" >> ${HOME}/.bashrc \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

RUN conda install -q -y \
       'blas=1.0=mkl' \
       'numpy=1.13.*' \
       'notebook=5.5.*' \
       'jupyterlab=0.32.*' \
    && conda install -q -y \
       'ipywidgets=7.2*' \
       'cython=0.28*' \
       'pandas=0.23*' \
       'matplotlib=2.2*' \
    && conda install -q -y \
       'scipy=1.1*' \
       'scikit-learn=0.19*' \
       'seaborn=0.8*' \
       'sympy=1.1*' \
       'bokeh=0.12*' \
       'statsmodels=0.8*' \
       'sqlalchemy=1.2*' \
       'ipython-sql=0.3.*' \
	nodejs \
    && conda remove -q -y --force qt pyqt \
    && conda clean -tipsy \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

RUN jupyter nbextension enable --py widgetsnbextension --sys-prefix \
    && jupyter labextension install @jupyter-widgets/jupyterlab-manager@^0.35 \
    && jupyter labextension install jupyterlab_bokeh@^0.5.0 \
    && jupyter labextension install @jupyterlab/github \
    && pip install --no-cache-dir jupyterlab_github \
    && rm -rf ${CONDA_DIR}/share/jupyter/lab/staging \
    && rm -rf ${HOME}/.cache/yarn \
    && rm -rf ${HOME}/.node-gyp \
    && cd /tmp \
    && git clone https://github.com/PAIR-code/facets.git \
    && cd facets \
    && jupyter nbextension install facets-dist/ --sys-prefix \
    && cd \
    && rm -rf /tmp/facets \
    && conda clean -tipsy \
    && npm cache clean --force \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

# Import matplotlib the first time to build the font cache.
ENV XDG_CACHE_HOME {HOME}/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot" \
    && fix-permissions ${HOME}

RUN conda install -q -y \
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
       xlrd \
    && conda clean -tipsy \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

RUN pip install --no-cache-dir jupyter_http_over_ws \
    && jupyter serverextension enable --py jupyter_http_over_ws \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

USER root

COPY jupyter_notebook_config.py /etc/jupyter/
COPY load_ext.py $HOME/.ipython/profile_default/startup/load_ext.py
RUN echo "jupyter ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook \
    && fix-permissions /etc/jupyter/ \
    && fix-permissions ${HOME} 

EXPOSE 8888
WORKDIR $HOME
ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "jupyter", "lab" ]

USER $NB_UID

# postgresql+psycopg2://test:test@localhost/test
ENV DATABASE_URL=sqlite:// \
    GITHUB_ACCESS_TOKEN=NONE
