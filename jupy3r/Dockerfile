FROM sudachen/jupyter:latest
LABEL maintainer="Alexey Sudachen <alexey@sudachen.name>"

# Julia

#ENV JULIA_BASE=/opt/julia \
#    JULIA_STARTUP=/opt/julia/etc/julia/startup.jl \
#    JULIA_VERSION=1.0.1 
#
#USER root
#
#RUN mkdir ${JULIA_BASE} \
# && ln -fs ${JULIA_BASE}/bin/julia /usr/local/bin/julia \ 
# && chown $NB_USER ${JULIA_BASE} \
# && fix-permissions ${JULIA_BASE}
#
#USER $NB_UID

#RUN cd /tmp \
# && wget -q https://julialang-s3.julialang.org/bin/linux/x64/`echo ${JULIA_VERSION} | cut -d. -f 1,2`/julia-${JULIA_VERSION}-linux-x86_64.tar.gz \
# && tar xzf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C ${JULIA_BASE} --strip-components=1 \
# && rm /tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz \
# && echo "using Libdl; push!(Libdl.DL_LOAD_PATH, \"${CONDA_DIR}/lib\")" >> ${JULIA_STARTUP} \
# && echo "ENV[\"PATH\"]=\"${CONDA_DIR}/bin:\$(ENV[\"PATH\"])\"" >> ${JULIA_STARTUP} \
# && echo "ENV[\"PYTHON\"]=\"${CONDA_DIR}/bin/python3\"" >> ${JULIA_STARTUP} \
# && echo "ENV[\"CONDA_DEFAULT_ENV\"]=\"base\"" >> ${JULIA_STARTUP} \
# && echo "ENV[\"TZ\"]=\"\"" >> ${JULIA_STARTUP} 

# RUN julia -e 'import Pkg; using Pkg; Pkg.update();' \
#  && julia -e 'using Pkg; Pkg.add("Plots"); using Plots' \
#  && julia -e 'using Pkg; Pkg.add("HDF5"); using HDF5' \
#  && julia -e 'using Pkg; Pkg.add("MySQL"); using MySQL' \
#  && julia -e 'using Pkg; Pkg.add("CSV"); using CSV' \
#  && julia -e 'using Pkg; Pkg.add("SQLite"); using SQLite' \
#  && julia -e 'using Pkg; Pkg.add(PackageSpec(name="Gadfly",rev="master")); using Gadfly' \ 
#  && julia -e 'using Pkg; Pkg.add(PackageSpec(name="PyCall",rev="master")); using PyCall' \
#  && julia -e 'using Pkg; Pkg.add(PackageSpec(name="PyPlot",rev="master")); using PyPlot' \
#  && julia -e 'using Pkg; Pkg.add(PackageSpec(name="Pandas",rev="master")); using Pandas' \
#  && julia -e 'using Pkg; Pkg.add(PackageSpec(name="ScikitLearn",rev="master")); using ScikitLearn' \ 
#  && julia -e 'using Pkg; Pkg.add(PackageSpec(name="LibPQ",rev="master")); using LibPQ' \
#  && julia -e 'using Pkg; Pkg.add(PackageSpec(name="IJulia",rev="master")); using IJulia' \
#  && rm -rf ~/.julia/clones 

#RUN wget -O /tmp/julia.7z https://github.com/sudachen/dstoolbox/releases/download/1.23/julia-101-pkgs.7z \
# &&  cd $HOME && 7z x /tmp/julia.7z \
# &&  rm /tmp/julia.7z 
#RUN julia -e 'using IJulia; IJulia.installkernel("Julia", "--depwarn=no")'

# Rust

USER root

RUN apt-get install -y --no-install-recommends \
        libzmq3-dev libssl-dev \
&&  apt-get clean

USER $NB_USER

RUN curl https://sh.rustup.rs -sSf | bash -s - --default-toolchain stable -y

ENV PATH "$PATH:$HOME/.cargo/bin"
RUN cargo install evcxr_jupyter \
&&  evcxr_jupyter --install

# C++

RUN conda config --append channels QuantStack \
&&  conda install -y 'pyzmq>=17.1.*' xeus-cling xtensor-python \
&&  conda clean -tipsy \
&&  rm -rf /opt/conda/share/jupyter/kernels/xeus-cling-cpp11 \
&&  rm -rf /opt/conda/share/jupyter/kernels/xeus-cling-cpp14 

