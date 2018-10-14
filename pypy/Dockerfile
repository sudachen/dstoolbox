FROM sudachen/jupy2r:latest

ENV BLAS /usr/lib/libopenblas.a 
ENV LAPACK /usr/lib/libopenblas.a 
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/conda/lib 

USER root

RUN  apt-get install -y --no-install-recommends \
		tcl \
		tk \
		gfortran \
		libfreetype6-dev \
		pkg-config \
		libopenblas-dev \
&&   apt-get clean

RUN set -ex \
&&  wget -O pypy.tar.bz2 https://bitbucket.org/squeaky/portable-pypy/downloads/pypy3.5-6.0.0-linux_x86_64-portable.tar.bz2 \
&&  mkdir /opt/pypy \
&&  tar -xjC /opt/pypy --strip-components=1 -f pypy.tar.bz2 \
&&  find /opt/pypy/lib-python -depth -type d -a \( -name test -o -name tests \) -exec rm -rf '{}' + \
&&  ln -s /opt/pypy/bin/pypy3 /usr/local/bin \
&&  rm pypy.tar.bz2 

RUN set -ex \
&&  wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \
&&  pypy3 get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
&&  ln -s /opt/pypy/bin/pip /usr/local/bin/pipy3 \
&&  rm get-pip.py

RUN chown -R $NB_USER /opt/pypy && fix-permissions /opt/pypy/
USER $NB_USER

RUN pipy3 install --no-cache-dir requests selenium numpy matplotlib pytest ipython jupyter pandas Pillow 
RUN pipy3 install --no-cache-dir Cython
RUN pipy3 install --no-cache-dir scipy scikit-learn scikit-image
RUN pipy3 install --no-cache-dir pydrive psycopg2 pymysql sqlalchemy ipython-sql
RUN pipy3 install --no-cache-dir google-api-python-client oauth2client pexpect pyotp
RUN pipy3 install --no-cache-dir scrapy ipywidgets sqlalchemy-redshift
RUN pipy3 install --no-cache-dir pystan fbprophet

RUN pypy3 -m ipykernel install --user --name "PyPy6-3.5" --display-name "PyPy 3"
