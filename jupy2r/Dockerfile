FROM sudachen/julia:latest
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

RUN jupyter labextension install @jupyterlab/github \
    && pip install --no-cache-dir jupyterlab_github \
    && rm -rf ${CONDA_DIR}/share/jupyter/lab/staging \
    && rm -rf ${HOME}/.cache/yarn \
    && rm -rf ${HOME}/.node-gyp \
    && conda clean -tipsy \
    && npm cache clean --force \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

# DrawIO

RUN jupyter labextension install jupyterlab-drawio \
    && rm -rf ${CONDA_DIR}/share/jupyter/lab/staging \
    && rm -rf ${HOME}/.cache/yarn \
    && rm -rf ${HOME}/.node-gyp \
    && conda clean -tipsy \
    && npm cache clean --force \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

# Hacked

RUN pip install -U --no-cache-dir \
	singleton_decorator \
	git+git://github.com/sudachen/ipython-sql@master \
	git+git://github.com/sudachen/PyDrive \
    !pip install git+git://github.com/sudachen/gspread.git \
    && conda clean -tipsy \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

