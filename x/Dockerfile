FROM sudachen/jupyter:latest
LABEL maintainer="Alexey Sudachen <alexey@sudachen.name>"
ARG NO_SCALA

RUN conda config --add pinned_packages 'openjdk >8.0.121' \
    && conda install -q -y openjdk maven py4j pyzmq \
    && conda clean -tipsy \
    && fix-permissions ${CONDA_DIR} 

RUN conda install -q -y beakerx \
    && conda clean -tipsy \
    && rm -r ${CONDA_DIR}/share/jupyter/kernels/kotlin \
    && rm -r ${CONDA_DIR}/share/jupyter/kernels/clojure \
    && rm -r ${CONDA_DIR}/share/jupyter/kernels/groovy \
    && rm -r ${CONDA_DIR}/share/jupyter/kernels/java \
    && rm -r ${CONDA_DIR}/share/jupyter/kernels/sql \
    && fix-permissions ${CONDA_DIR} 

RUN [ -z $NO_SCALA ] || rm -r ${CONDA_DIR}/share/jupyter/kernels/scala

RUN jupyter labextension install beakerx-jupyterlab \
    && rm -rf ${CONDA_DIR}/share/jupyter/lab/staging \
    && rm -rf ${HOME}/.cache/yarn \
    && rm -rf ${HOME}/.node-gyp \
    && npm cache clean --force \
    && conda clean -tipsy \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}


