FROM sudachen/jupyter:latest
LABEL maintainer="Alexey Sudachen <alexey@sudachen.name>"

#PyPy3

USER root

RUN  apt-get install -y --no-install-recommends \
		tcl \
		tk \
		gfortran \
		libfreetype6-dev \
		pkg-config \
		libopenblas-dev \
&&   apt-get clean

RUN  mkdir /opt/pypy \
&&  ln -s /opt/pypy/bin/pypy3 /usr/local/bin \
&&  ln -s /opt/pypy/bin/pip /usr/local/bin/pipy3 \
&& chown -R $NB_USER /opt/pypy \
&& fix-permissions /opt/pypy/

USER $NB_USER

RUN wget -O pypy.tar.bz2 https://bitbucket.org/squeaky/portable-pypy/downloads/pypy3.5-6.0.0-linux_x86_64-portable.tar.bz2 \
&&  tar -xjC /opt/pypy --strip-components=1 -f pypy.tar.bz2 \
&&  find /opt/pypy/lib-python -depth -type d -a \( -name test -o -name tests \) -exec rm -rf '{}' + \
&&  rm pypy.tar.bz2 

RUN wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \
&&  pypy3 get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
&&  rm get-pip.py

ENV PYPY_GC_MAX: 1.99GB
ENV PYPY_GC_MAJOR_COLLECT: 1.2

RUN BLAS=/usr/lib/libopenblas.a LAPACK=/usr/lib/libopenblas.a \
    pipy3 install --no-cache-dir \
        requests selenium \
        pytest ipython jupyter \
        numpy matplotlib pandas Pillow \ 
        Cython scipy scikit-learn scikit-image \
        pydrive psycopg2 pymysql sqlalchemy \
        google-api-python-client oauth2client pexpect pyotp \
        scrapy ipywidgets sqlalchemy-redshift \
        pystan fbprophet 

RUN pypy3 -m ipykernel install --user --name "PyPy6-3.5" --display-name "PyPy 3"

RUN pipy3 install -U --no-cache-dir \
        python-Levenshtein \
        git+git://github.com/sudachen/colabtools \
        git+https://github.com/sudachen/pygdrive-funcs.git#egg=gdrive \ 
        git+git://github.com/sudachen/ipython-sql \
        git+git://github.com/sudachen/PyDrive 

# Julia

ENV JULIA_BASE=/opt/julia \
    JULIA_STARTUP=/opt/julia/etc/julia/startup.jl \
    JULIA_VERSION=1.0.1 

USER root

RUN mkdir ${JULIA_BASE} \
 && ln -fs ${JULIA_BASE}/bin/julia /usr/local/bin/julia \ 
 && chown $NB_USER ${JULIA_BASE} \
 && fix-permissions ${JULIA_BASE}

USER $NB_UID

RUN cd /tmp \
 && wget -q https://julialang-s3.julialang.org/bin/linux/x64/`echo ${JULIA_VERSION} | cut -d. -f 1,2`/julia-${JULIA_VERSION}-linux-x86_64.tar.gz \
 && tar xzf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C ${JULIA_BASE} --strip-components=1 \
 && rm /tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz \
 && echo "using Libdl; push!(Libdl.DL_LOAD_PATH, \"${CONDA_DIR}/lib\")" >> ${JULIA_STARTUP} \
 && echo "ENV[\"PATH\"]=\"${CONDA_DIR}/bin:\$(ENV[\"PATH\"])\"" >> ${JULIA_STARTUP} \
 && echo "ENV[\"PYTHON\"]=\"${CONDA_DIR}/bin/python3\"" >> ${JULIA_STARTUP} \
 && echo "ENV[\"CONDA_DEFAULT_ENV\"]=\"base\"" >> ${JULIA_STARTUP} \
 && echo "ENV[\"TZ\"]=\"\"" >> ${JULIA_STARTUP} 

RUN julia -e 'import Pkg; using Pkg; Pkg.update();' \
 && julia -e 'using Pkg; Pkg.add("Plots"); using Plots' \
 && julia -e 'using Pkg; Pkg.add("HDF5"); using HDF5' \
 && julia -e 'using Pkg; Pkg.add("MySQL"); using MySQL' \
 && julia -e 'using Pkg; Pkg.add("CSV"); using CSV' \
 && julia -e 'using Pkg; Pkg.add("SQLite"); using SQLite' \
 && julia -e 'using Pkg; Pkg.add(PackageSpec(name="Gadfly",rev="master")); using Gadfly' \ 
 && julia -e 'using Pkg; Pkg.add(PackageSpec(name="PyCall",rev="master")); using PyCall' \
 && julia -e 'using Pkg; Pkg.add(PackageSpec(name="PyPlot",rev="master")); using PyPlot' \
 && julia -e 'using Pkg; Pkg.add(PackageSpec(name="Pandas",rev="master")); using Pandas' \
 && julia -e 'using Pkg; Pkg.add(PackageSpec(name="ScikitLearn",rev="master")); using ScikitLearn' \ 
 && julia -e 'using Pkg; Pkg.add(PackageSpec(name="LibPQ",rev="master")); using LibPQ' \
 && julia -e 'using Pkg; Pkg.add(PackageSpec(name="IJulia",rev="master")); using IJulia' 

USER root

RUN apt-get install -y --no-install-recommends \
        libzmq3-dev libssl-dev \
&&  apt-get clean

USER $NB_USER

RUN curl -L https://static.rust-lang.org/rustup.sh -o rustup.sh \
&&  sh rustup.sh -y --channel=beta \
&&  rm rustup.sh 

ENV PATH "$PATH:$HOME/.cargo/bin"
RUN cargo install evcxr_jupyter \
&&  evcxr_jupyter --install

COPY logo-32x32.png logo-64x64.png $HOME/.local/share/jupyter/kernels/pypy6-3.5/

#USER root
#
#RUN apt install -y  --no-install-recommends \
# && apt-get clean 

USER $NB_USER

