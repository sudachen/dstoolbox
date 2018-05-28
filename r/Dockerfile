FROM sudachen/jupyter:latest
LABEL maintainer="Alexey Sudachen <alexey@sudachen.name>"

RUN sudo apt-get update --fix-missing \
    && sudo apt-get install -qy --no-install-recommends \
	build-essential \
	gfortran \
    && sudo rm -rf /var/lib/apt/lists/* 

RUN conda install -q -y \
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
