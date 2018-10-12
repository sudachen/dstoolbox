FROM sudachen/jupy2r:latest

ENV PYTHON_PIP_VERSION 18.1

USER root

RUN  apt-get install -y --no-install-recommends \
		tcl \
		tk \
		gfortran \
		libfreetype6-dev \
		pkg-config \
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
		"pip==$PYTHON_PIP_VERSION" \
&&  ln -s /opt/pypy/bin/pip /usr/local/bin/pipy3 \
&&  rm get-pip.py

RUN pipy3 install --no-cache-dir requests selenium numpy matplotlib pytest ipython jupyter pandas Pillow 
RUN pipy3 install --no-cache-dir Cython

ENV BLAS /opt/conda/lib/libopenblas.a 
ENV LAPACK /opt/conda/lib/libopenblas.a 
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/opt/conda/lib 

#RUN git clone https://github.com/scipy/scipy \
#&& pypy3 setup.py build \
#&& pypy3 setup.py install

RUN pipy3 install --no-cache-dir scipy scikit-learn scikit-image

USER $NB_USER
