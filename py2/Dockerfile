FROM sudachen/r_julia:latest
LABEL maintainer="Alexey Sudachen <alexey@sudachen.name>"

RUN conda create -n python27 python=2.7 ipykernel \
    && conda clean -tipsy \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

RUN conda install -n python27 -c conda-forge \
       'numpy=1.14.*' \
       'pandas=0.23.*' \
       'pandas=0.23.*' \
       'ipywidgets=7.2.*' \
       'matplotlib=2.2.*' \
       'sqlalchemy=1.2.*' \
       'ipython-sql=0.3.*' \
       'libpq=9.6.*' \
       'psycopg2=2.7.*' \
       'pymysql=0.8.*' \
    && conda remove -n python27 -q -y --force qt pyqt \
    && conda clean -tipsy \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

RUN ${CONDA_DIR}/envs/python27/bin/ipython2 kernel install --user \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}
