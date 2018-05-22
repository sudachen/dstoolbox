FROM sudachen/jupyter:latest
LABEL maintainer="Alexey Sudachen <alexey@sudachen.name>"

USER root

ENV JULIA_PKGDIR=/opt/julia \
    JULIA_VERSION=0.6.2

RUN mkdir /opt/julia-${JULIA_VERSION} \
    && cd /tmp \
    && wget -q https://julialang-s3.julialang.org/bin/linux/x64/`echo ${JULIA_VERSION} | cut -d. -f 1,2`/julia-${JULIA_VERSION}-linux-x86_64.tar.gz \
    && tar xzf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C /opt/julia-${JULIA_VERSION} --strip-components=1 \
    && rm /tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz \
    && ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia \
    && mkdir /etc/julia \
    && echo "push!(Libdl.DL_LOAD_PATH, \"${CONDA_DIR}/lib\")" >> /etc/julia/juliarc.jl \
    && mkdir ${JULIA_PKGDIR} \
    && chown $NB_USER ${JULIA_PKGDIR} \
    && fix-permissions ${JULIA_PKGDIR}

USER $NB_UID

RUN sudo apt-get update --fix-missing \
    && sudo apt-get install -qy --no-install-recommends \
	build-essential \
	gfortran \
	gcc \
        g++ \
	libpq5 \
        libpq-dev \
        hdf5-tools \
        libhdf5-dev \
	sqlite3 \
	libsqlite3-dev \
    && sudo rm -rf /var/lib/apt/lists/* 


RUN julia -e 'Pkg.init()' \
    && julia -e 'Pkg.update()'

USER root
ADD REQUIRE $JULIA_PKGDIR/v0.6/REQUIRE
RUN chown $NB_USER ${JULIA_PKGDIR}/v0.6/REQUIRE

USER $NB_UID

RUN julia -e 'Pkg.resolve()' \
    && julia -e 'using IJulia' \
    && mv ${HOME}/.local/share/jupyter/kernels/julia* ${CONDA_DIR}/share/jupyter/kernels/ \
    && chmod -R go+rx ${CONDA_DIR}/share/jupyter \
    && rm -rf ${HOME}/.local \
    && fix-permissions ${JULIA_PKGDIR} \ 
    && fix-permissions ${CONDA_DIR}/share/jupyter 


