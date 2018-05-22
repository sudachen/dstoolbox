FROM sudachen/julia

# any additional content here

RUN pip install -U --no-cache-dir git+git://github.com/sudachen/ipython-sql@master \
    && fix-permissions ${CONDA_DIR}

ADD jupyter_notebook_config.py /etc/jupyter/
ADD load_ext.py $HOME/.ipython/profile_default/startup/load_ext.py

USER root
RUN fix-permissions /etc/jupyter/ \
    && fix-permissions ${HOME} 
USER $NB_UID




