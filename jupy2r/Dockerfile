FROM sudachen/julia:latest
LABEL maintainer="Alexey Sudachen <alexey@sudachen.name>"

RUN sudo apt-get update --fix-missing \
    && sudo apt-get install -qy --no-install-recommends \
	build-essential \
	gfortran \
    && sudo rm -rf /var/lib/apt/lists/* 

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

RUN julia -e 'Pkg.add("RCall")' \
    && julia -e 'using RCall' \
    && rm -rf ${JULIA_PKGDIR}/v0.6/.cache \
    && fix-permissions ${JULIA_PKGDIR} 

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
    && rm -rf ${HOME}/.local \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

ENV JUPYTER_HAS_PYTHON2=2.7

# google drive integration

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

