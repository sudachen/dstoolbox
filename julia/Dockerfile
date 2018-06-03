FROM sudachen/jupyter:latest
LABEL maintainer="Alexey Sudachen <alexey@sudachen.name>"

ENV JULIA_PKGDIR=/opt/julia \
    JULIA_VERSION=0.6.3 \
    JULIA_PKGDIR_VER=/opt/julia/v0.6 \ 
    JULIA_CACHE=/opt/julia/.cache 

USER root

RUN mkdir /opt/julia-${JULIA_VERSION} \
    && cd /tmp \
    && wget -q https://julialang-s3.julialang.org/bin/linux/x64/`echo ${JULIA_VERSION} | cut -d. -f 1,2`/julia-${JULIA_VERSION}-linux-x86_64.tar.gz \
    && tar xzf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C /opt/julia-${JULIA_VERSION} --strip-components=1 \
    && rm /tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz \
    && ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia \
    && mkdir ${JULIA_PKGDIR} \
    && chown $NB_USER ${JULIA_PKGDIR} \
    && fix-permissions ${JULIA_PKGDIR}

USER $NB_UID

ENV JULIA_RC=${HOME}/.juliarc.jl \
    MOCHA_USE_NATIVE_EXT=true

USER root

ADD REQUIRE $JULIA_PKGDIR_VER/REQUIRE
ADD precompile $JULIA_PKGDIR_VER/precompile
RUN chown $NB_USER ${JULIA_PKGDIR_VER}/REQUIRE \
    && chmod a+x ${JULIA_PKGDIR_VER}/precompile \
    && chown $NB_USER ${JULIA_PKGDIR_VER}/precompile

USER $NB_UID

RUN echo "@everywhere push!(Libdl.DL_LOAD_PATH, \"${CONDA_DIR}/envs/python27/lib\")" >> ${JULIA_RC} \
    && echo "@everywhere ENV[\"PATH\"]=\"${CONDA_DIR}/envs/python27/bin:\$(ENV[\"PATH\"])\"" >> ${JULIA_RC} \
    && echo "@everywhere ENV[\"PYTHON\"]=\"${CONDA_DIR}/envs/python27/bin/python2\"" >> ${JULIA_RC} \
    && echo "@everywhere ENV[\"CONDA_DEFAULT_ENV\"]=\"python27\"" >> ${JULIA_RC} 

RUN julia -e 'Pkg.init(); Pkg.update(); Pkg.resolve()' \
RUN ${JULIA_PKGDIR}/v0.6/precompile
RUN mv ${HOME}/.local/share/jupyter/kernels/julia* ${CONDA_DIR}/share/jupyter/kernels/ \
    && chmod -R go+rx ${CONDA_DIR}/share/jupyter 

RUN conda install -y -n python27 \
       'scikit-learn=0.19*=*openblas*' \
    && conda clean -tipsy \
    && julia -e 'Pkg.clone("https://github.com/cstjean/ScikitLearn.jl","ScikitLearn")' \
    && julia -e 'Pkg.build("ScikitLearn"); using ScikitLearn' \
    && julia -e 'Pkg.add("Pandas"); Pkg.add("PyPlot"); using Pandas; using PyPlot' \
    && ${JULIA_PKGDIR_VER}/clean 

RUN touch /tmp/1 \
    && touch -r /tmp/1 ${JULIA_PKGDIR}/lib/v0.6/*.ji \
    && /tmp/1

ENV JUPYTER_HAS_JULIA=${JULIA_VERSION}
