FROM sudachen/julia:latest

# any additional content here

# postgresql+psycopg2://test:test@localhost/test
ENV DATABASE_URL=sqlite:// \
    GITHUB_ACCESS_TOKEN=NONE

RUN pip install -U --no-cache-dir git+git://github.com/sudachen/ipython-sql@master \
    && fix-permissions ${CONDA_DIR}

ADD jupyter_notebook_config.py /etc/jupyter/
ADD setup_kernel.py $HOME/.ipython/profile_default/startup/setup_kernel.py

USER root
RUN fix-permissions /etc/jupyter/ \
    && fix-permissions ${HOME} 
USER $NB_UID




