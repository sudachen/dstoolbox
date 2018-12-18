FROM sudachen/jupyter:latest
LABEL maintainer="Alexey Sudachen <alexey@sudachen.name>"

# NVIDIA/Keras/Theano/PyTorch/OpenCL

LABEL com.nvidia.volumes.needed="nvidia_driver"
LABEL com.nvidia.cuda.version="9.2"
LABEL com.nvidia.cudnn.version="7.4"
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=9.2"

USER $NB_USER

#RUN conda install -y pytorch torchvision -c pytorch \
# && conda clean -tipsy \
# && rm -rf ${CONDA_DIR}/pkgs/*

RUN conda install -y tensorflow-gpu keras Theano \
 && conda clean -tipsy \
 && rm -rf ${CONDA_DIR}/pkgs/*

USER root

RUN mkdir /tmp/ncl && cd /tmp/ncl \
 && apt-get download  nvidia-opencl-common nvidia-opencl-icd \
 && dpkg -i --ignore-depends=libnvidia-ptxjitcompiler1,libcuda1,libnvidia-compiler,libnvidia-fatbinaryloader,nvidia-legacy-check,nvidia-support,nvidia-alternative *.deb \
 && rm *.deb \
 && apt-get --fix-broken install -y \
 && apt-get install -y --no-install-recommends \
        libzmq3-dev libssl-dev screen \
 && apt-get clean

USER $NB_USER

RUN pip install -U --no-cache-dir \
        pyopencl \
        pyclblas \
        torch \
        torchvision
        
# Julia

ENV JULIA_BASE=/opt/julia \
    JULIA_STARTUP=/opt/julia/etc/julia/startup.jl \
    JULIA_VERSION=1.0.2 

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

#RUN julia -e 'using Pkg; Pkg.update()' \
# && julia -e 'using Pkg; Pkg.add("Plots")' \
# && julia -e 'using Pkg; Pkg.add("HDF5")' \
# && julia -e 'using Pkg; Pkg.add("MySQL")' \
# && julia -e 'using Pkg; Pkg.add("CSV")' \
# && julia -e 'using Pkg; Pkg.add("SQLite")' \
# && julia -e 'using Pkg; Pkg.add(PackageSpec(name="Gadfly",rev="master"))' \ 
# && julia -e 'using Pkg; Pkg.add(PackageSpec(name="PyCall",rev="master"))' \
# && julia -e 'using Pkg; Pkg.add(PackageSpec(name="PyPlot",rev="master"))' \
# && julia -e 'using Pkg; Pkg.add(PackageSpec(name="Pandas",rev="master"))' \
# && julia -e 'using Pkg; Pkg.add(PackageSpec(name="ScikitLearn",rev="master"))' \ 
# && julia -e 'using Pkg; Pkg.add(PackageSpec(name="LibPQ",rev="master"))' \
# && julia -e 'using Pkg; Pkg.add(PackageSpec(name="IJulia",rev="master"))' \
# && julia -e 'using Pkg; Pkg.add("JuliaDB")' \
# && screen -S julia -d -m -s julia \
# && screen -S julia -p 0 -X stuff '^M]^Mprecompile^M^M^M' \
# && sp='/-\|' \
# && printf 'Precompiling Julia Packages...  ' \
# && sleep 1 \
# && while [ "`screen -S julia -p 0 -X hardcopy /tmp/screen && tac /tmp/screen | grep '.' -a -m 1`" != "(v1.0) pkg>" ]; do \
#       printf '\b%.1s' "$sp"; \
#       sp=${sp#?}${sp%???}; \
#       sleep 0.5; \
#    done \
# && echo done \
# && julia -e 'using Pkg; Pkg.gc()'

RUN curl -L -o /tmp/julia.7z https://github.com/sudachen/dstoolbox/releases/download/1.23/julia-101-pkgs.7z \
 && cd $HOME && 7z x /tmp/julia.7z \
 && rm /tmp/julia.7z \
 && julia -e 'using Pkg; Pkg.update(); Pkg.gc()' \
 && julia -e 'using Pkg; Pkg.add("JuliaDB")' \
 && screen -S julia -d -m -s julia \
 && screen -S julia -p 0 -X stuff '^M]^Mprecompile^M^M^M' \
 && sp='/-\|' \
 && printf 'Precompiling Julia Packages...  ' \
 && sleep 1 \
 && while [ "`screen -S julia -p 0 -X hardcopy /tmp/screen && tac /tmp/screen | grep '.' -a -m 1`" != "(v1.0) pkg>" ]; do \
       printf '\b%.1s' "$sp"; \
       sp=${sp#?}${sp%???}; \
       sleep 0.5; \
    done \
 && echo done \
 && julia -e 'using Pkg; Pkg.gc()'
   
RUN julia -e 'using IJulia; IJulia.installkernel("Julia", "--depwarn=no")'

# Rust

USER $NB_UID

RUN curl https://sh.rustup.rs -sSf | bash -s - --default-toolchain stable -y

ENV PATH "$HOME/.cargo/bin:$PATH"
RUN cargo install evcxr_jupyter \
 && evcxr_jupyter --install 

RUN sed ~/.local/share/jupyter/kernels/rust/kernel.json -i -e "s/_name\": \"Rust\"/_name\": \"Rust `rustc --version | cut -f 2 -d ' '`\"/g"    

# Scala

USER root

ENV ALMOND_VERSION=0.1.9 \
    SBT_VERSION=1.2.3 \
    SCALA_VERSION=2.12.7 \
    PATH=$PATH:/opt/sbt/bin

RUN mkdir /opt/sbt \
 && curl -sL --retry 5 "https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz" | tar zx -C /opt/sbt --strip-components=1 \
 && chmod +x /opt/sbt/bin/sbt \
 && curl -L -o /usr/bin/coursier https://git.io/coursier \
 && chmod +x /usr/bin/coursier 

USER $NB_USER

RUN coursier bootstrap \
      -i user \
      -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION \
      sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION \
      -o almond_2_12 \
 && chmod +x almond_2_12 \
 && ./almond_2_12 --id almond_scala_2_12 --display-name "Scala $SCALA_VERSION" --install \
 && rm ./almond_2_12

# C++
#RUN conda create -n cling \
# && conda install -y -n cling -c QuantStack -c conda-forge xeus-cling \
# && conda clean -tipsy \
# && rm -rf ${CONDA_DIR}/pkgs/* 
#RUN cp -r $CONDA_DIR/env/cling/share/jupyter/kernels/xeus-cling-cpp17 $HOME/.local/share/jupyter/kernels

#PyPy6 3.5

USER root

RUN mkdir /opt/pypy \
 && ln -s /opt/pypy/bin/pypy3 /usr/local/bin \
 && ln -s /opt/pypy/bin/pip /usr/local/bin/pipy3 \
 && chown -R $NB_USER /opt/pypy \
 && fix-permissions /opt/pypy/

USER $NB_USER

ENV PYPY_GC_MAX: 1.99GB
ENV PYPY_GC_MAJOR_COLLECT: 1.2

# RUN wget -O pypy.tar.bz2 https://bitbucket.org/squeaky/portable-pypy/downloads/pypy3.5-6.0.0-linux_x86_64-portable.tar.bz2 \
# &&  tar -xjC /opt/pypy --strip-components=1 -f pypy.tar.bz2 \
# &&  find /opt/pypy/lib-python -depth -type d -a \( -name test -o -name tests \) -exec rm -rf '{}' + \
# &&  rm pypy.tar.bz2 

# RUN wget -O get-pip.py 'https://bootstrap.pypa.io/get-pip.py' \
# &&  pypy3 get-pip.py \
# 		--disable-pip-version-check \
# 		--no-cache-dir \
# &&  rm get-pip.py

#RUN BLAS=/usr/lib/libopenblas.a LAPACK=/usr/lib/libopenblas.a \
#    pipy3 install --no-cache-dir \
#        requests selenium \
#        pytest ipython jupyter \
#         numpy matplotlib pandas Pillow \ 
#         Cython scipy scikit-learn scikit-image \
#         pydrive psycopg2 pymysql sqlalchemy \
#         google-api-python-client oauth2client pexpect pyotp \
#         scrapy ipywidgets sqlalchemy-redshift \
#         pystan fbprophet 

# RUN pypy3 -m ipykernel install --user --name "PyPy6-3.5" --display-name "PyPy 3"

# RUN pipy3 install -U --no-cache-dir \
#         python-Levenshtein \
#         git+git://github.com/sudachen/colabtools \
#         git+https://github.com/sudachen/pygdrive-funcs.git#egg=gdrive \ 
#         git+git://github.com/sudachen/ipython-sql \
#         git+git://github.com/sudachen/PyDrive 

RUN curl -o /tmp/pypy.7z -L https://github.com/sudachen/dstoolbox/releases/download/1.23/pypy-3.5.7z \
 &&  cd / && 7z x /tmp/pypy.7z \
 &&  rm /tmp/pypy.7z 

RUN pypy3 -m ipykernel install --user --name "PyPy6-3.5" --display-name "PyPy 3"
COPY logo-32x32.png logo-64x64.png $HOME/.local/share/jupyter/kernels/pypy6-3.5/

# -#-

USER $NB_USER
