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

RUN julia -e 'Pkg.init()' \
    && julia -e 'Pkg.update()'

ENV JULIA_RC=${HOME}/.juliarc.jl \
    MOCHA_USE_NATIVE_EXT=true

USER root

ADD REQUIRE $JULIA_PKGDIR_VER/REQUIRE
ADD precompile $JULIA_PKGDIR_VER/precompile
RUN chown $NB_USER ${JULIA_PKGDIR_VER}/REQUIRE \
    && chmod a+x ${JULIA_PKGDIR_VER}/precompile \
    && chown $NB_USER ${JULIA_PKGDIR_VER}/precompile \
    && echo "#!/bin/sh" > ${JULIA_PKGDIR_VER}/clean \
#    && echo "rm -rf ${JULIA_CACHE}" >> ${JULIA_PKGDIR_VER}/clean \
    && chmod a+x ${JULIA_PKGDIR_VER}/clean \
    && chown $NB_USER ${JULIA_PKGDIR_VER}/clean   

USER $NB_UID

RUN echo "@everywhere push!(Libdl.DL_LOAD_PATH, \"${CONDA_DIR}/envs/python27/lib\")" >> ${JULIA_RC} \
    && echo "@everywhere ENV[\"PATH\"]=\"${CONDA_DIR}/envs/python27/bin:\$(ENV[\"PATH\"])\"" >> ${JULIA_RC} \
    && echo "@everywhere ENV[\"PYTHON\"]=\"${CONDA_DIR}/envs/python27/bin/python2\"" >> ${JULIA_RC} \
    && echo "@everywhere ENV[\"CONDA_DEFAULT_ENV\"]=\"python27\"" >> ${JULIA_RC} 

RUN julia -e 'Pkg.resolve()' \
    && ${JULIA_PKGDIR}/v0.6/precompile \	
    && ${JULIA_PKGDIR_VER}/clean 

RUN mv ${HOME}/.local/share/jupyter/kernels/julia* ${CONDA_DIR}/share/jupyter/kernels/ \
    && chmod -R go+rx ${CONDA_DIR}/share/jupyter 

RUN julia -e 'Pkg.add("RCall"); using RCall' \
    && ${JULIA_PKGDIR_VER}/clean 

RUN julia -e '\
Pkg.add("RDatasets"); \
Pkg.add("MLBase"); \
Pkg.add("DecisionTree"); \
Pkg.add("GLM"); \
Pkg.add("GLMNet"); \
' \
    && julia -e '\
using RDatasets; \
using MLBase; \
using DecisionTree; \
using GLM; \
using GLMNet; \
' \
    && ${JULIA_PKGDIR_VER}/clean 

RUN julia -e '\
Pkg.add("FFTW"); \
Pkg.add("ImageMagick"); \
Pkg.add("Mocha"); \
' \
    && julia -e '\
using FFTW; \
using ImageMagick; \
using Mocha; \
' \
    && ${JULIA_PKGDIR_VER}/clean 

RUN julia -e '\
Pkg.add("Boltzmann"); \
Pkg.add("TextAnalysis"); \
Pkg.add("LossFunctions"); \
' \
    && julia -e '\
using TextAnalysis; \
using LossFunctions; \
using Boltzmann; \
' \
    && ${JULIA_PKGDIR_VER}/clean 

RUN conda install -y -n python27 \
       'scikit-learn=0.19*=*openblas*' \
    && conda clean -tipsy 

RUN julia -e 'Pkg.clone("https://github.com/cstjean/ScikitLearn.jl","ScikitLearn")' \
    && julia -e 'Pkg.build("ScikitLearn")' \
    && julia -e 'using ScikitLearn' \
    && ${JULIA_PKGDIR_VER}/clean 
    
RUN julia -e 'Pkg.add("Pandas"); Pkg.add("PyPlot"); using Pandas; using PyPlot' \
    && ${JULIA_PKGDIR_VER}/clean 

RUN julia -e 'Pkg.add("GeoStats"); using GeoStats' \
    && ${JULIA_PKGDIR_VER}/clean 

RUN conda install -n python27 -c conda-forge \
      	jupyter \
      	'jupyterlab=0.32*' \
    && conda clean -tipsy

RUN mkdir ${HOME}/.interact \
    && sudo ln -fs ${HOME}/.interact /usr/local/share/jupyter \
    && julia -e 'Pkg.add("Interact"); using Interact' \
    && rm -r ${HOME}/.interact \
    && sudo rm /usr/local/share/jupyter \
    && ${JULIA_PKGDIR_VER}/clean \
    && fix-permissions ${CONDA_DIR}/share/jupyter 
 
RUN touch /tmp/1 \
    && touch -r /tmp/1 ${JULIA_PKGDIR}/lib/v0.6/*.ji \
    && rm ${HOME}/.jupyter/nbconfig/notebook.json

#RUN fix-permissions ${JULIA_PKGDIR}
ENV JUPYTER_HAS_JULIA=${JULIA_VERSION}
