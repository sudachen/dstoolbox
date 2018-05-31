FROM sudachen/jupyter:latest
LABEL maintainer="Alexey Sudachen <alexey@sudachen.name>"

USER root

RUN apt-get update --fix-missing \
    && apt-get install -qy --no-install-recommends \
	libpq5 \
        libpq-dev \
        hdf5-tools \
        libhdf5-dev \
	sqlite3 \
	libsqlite3-dev \
	imagemagick \
        libxml2-dev \
    && rm -rf /var/lib/apt/lists/* 

USER $NB_UID

ENV JULIA_PKGDIR=/opt/julia \
    JULIA_VERSION=0.6.3 \
    JULIA_PKGDIR_VER=/opt/julia/v0.6 \ 
    JULIA_CACHE=/opt/julia/v0.6/.cache \
    CONDA_JL_HOME=$CONDA_DIR/envs/python27

USER root

RUN mkdir /opt/julia-${JULIA_VERSION} \
    && cd /tmp \
    && wget -q https://julialang-s3.julialang.org/bin/linux/x64/`echo ${JULIA_VERSION} | cut -d. -f 1,2`/julia-${JULIA_VERSION}-linux-x86_64.tar.gz \
    && tar xzf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C /opt/julia-${JULIA_VERSION} --strip-components=1 \
    && rm /tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz \
    && ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia \
    && mkdir /etc/julia \
    && echo "push!(Libdl.DL_LOAD_PATH, \"${CONDA_JL_HOME}/lib\")" >> /etc/julia/juliarc.jl \
    && mkdir ${JULIA_PKGDIR} \
    && chown $NB_USER ${JULIA_PKGDIR} \
    && fix-permissions ${JULIA_PKGDIR}

USER $NB_UID

RUN julia -e 'Pkg.init()' \
    && julia -e 'Pkg.update()'

USER root

ADD REQUIRE $JULIA_PKGDIR_VER/REQUIRE
ADD precompile $JULIA_PKGDIR_VER/precompile
RUN chown $NB_USER ${JULIA_PKGDIR_VER}/REQUIRE \
    && chmod a+x ${JULIA_PKGDIR_VER}/precompile \
    && chown $NB_USER ${JULIA_PKGDIR_VER}/precompile \
    && echo "#!/bin/sh" > ${JULIA_PKGDIR_VER}/clean \
    && echo "fix-permissions ${JULIA_PKGDIR}" >> ${JULIA_PKGDIR_VER}/clean \
    && chmod a+x ${JULIA_PKGDIR_VER}/clean \
    && chown $NB_USER ${JULIA_PKGDIR_VER}/clean   

USER $NB_UID

RUN julia -e 'Pkg.resolve()' \
    && ${JULIA_PKGDIR}/v0.6/precompile \	
    && ${JULIA_PKGDIR_VER}/clean 

RUN julia -e 'Pkg.add("FFTW")' \
    && julia -e 'Pkg.add("ImageMagick")' \
    && julia -e 'using ImageMagick' \
    && ${JULIA_PKGDIR_VER}/clean 

RUN julia -e 'Pkg.add("StatsBase")' \
    && julia -e 'using StatsBase' \
    && julia -e 'Pkg.add("StatsModels")' \
    && julia -e 'using StatsModels' \
    && julia -e 'Pkg.add("StatsFuns")' \
    && julia -e 'using StatsFuns' \
    && julia -e 'Pkg.add("TimeSeries")' \
    && julia -e 'using TimeSeries' \
    && julia -e 'Pkg.add("Clustering")' \
    && julia -e 'using Clustering' \
    && ${JULIA_PKGDIR_VER}/clean 

#    && julia -e 'Pkg.add("GraphPlot")' \
#    && julia -e 'using GraphPlot' \
#    && julia -e 'Pkg.add("Wavelets")' \
#    && julia -e 'using Wavelets' \

RUN julia -e 'Pkg.add("BayesNets")' \
    && julia -e 'using BayesNets' \
    && julia -e 'Pkg.add("ApproxFun")' \
    && julia -e 'using ApproxFun' \
    && julia -e 'Pkg.add("DynamicalSystems")' \
    && julia -e 'using DynamicalSystems' \
    && ${JULIA_PKGDIR_VER}/clean 

RUN julia -e 'Pkg.add("MLBase")' \
    && julia -e 'using MLBase' \
    && julia -e 'Pkg.add("Mocha")' \
    && julia -e 'using Mocha' \
    && julia -e 'Pkg.add("Boltzmann")' \
    && julia -e 'using Boltzmann' \
    && julia -e 'Pkg.add("TextAnalysis")' \
    && julia -e 'using TextAnalysis' \
    && julia -e 'Pkg.add("LossFunctions")' \
    && julia -e 'using LossFunctions' \
    && julia -e 'Pkg.add("GeneticAlgorithms")' \
    && julia -e 'using GeneticAlgorithms' \
    && ${JULIA_PKGDIR_VER}/clean 

RUN julia -e 'Pkg.add("GitHub")' \
    && julia -e 'using GitHub' \
    && ${JULIA_PKGDIR_VER}/clean 

RUN julia -e 'Pkg.add("RCall")' \
    && julia -e 'using RCall' \
    && julia -e 'Pkg.add("RDatasets")' \
    && julia -e 'using RDatasets' \
    && ${JULIA_PKGDIR_VER}/clean 

RUN julia -e 'Pkg.add("IJulia")' \
    && julia -e 'using IJulia' \
    && julia -e 'Pkg.add("PyCall")' \
    && julia -e 'using PyCall' \
    && mv ${HOME}/.local/share/jupyter/kernels/julia* ${CONDA_DIR}/share/jupyter/kernels/ \
    && chmod -R go+rx ${CONDA_DIR}/share/jupyter \
    && ${JULIA_PKGDIR_VER}/clean 

RUN sudo ln -fs ${CONDA_DIR}/share/jupyter /usr/local/share/jupyter \
    && julia -e 'Pkg.add("Interact")' \
    && julia -e 'using Interact' \
    && sudo rm /usr/local/share/jupyter \
    && ${JULIA_PKGDIR_VER}/clean \
    && fix-permissions ${CONDA_DIR}/share/jupyter 

ENV JUPYTER_HAS_JULIA=${JULIA_VERSION}

RUN pip install --no-cache-dir \
	Wand \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

