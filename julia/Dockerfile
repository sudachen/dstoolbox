FROM sudachen/jupy2r:latest
LABEL maintainer="Alexey Sudachen <alexey@sudachen.name>"

# Julia

ENV JULIA_PKGDIR=/opt/julia \
    JULIA_RC=${HOME}/.juliarc.jl \
    JULIA_VERSION=1.0.1 \
    JULIA_PKGDIR_VER=/opt/julia/v1.0 \ 
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

RUN echo "@everywhere push!(Libdl.DL_LOAD_PATH, \"${CONDA_DIR}/envs/python27/lib\")" >> ${JULIA_RC} \
 && echo "@everywhere ENV[\"PATH\"]=\"${CONDA_DIR}/envs/python27/bin:\$(ENV[\"PATH\"])\"" >> ${JULIA_RC} \
 && echo "@everywhere ENV[\"PYTHON\"]=\"${CONDA_DIR}/envs/python27/bin/python2\"" >> ${JULIA_RC} \
 && echo "@everywhere ENV[\"CONDA_DEFAULT_ENV\"]=\"python27\"" >> ${JULIA_RC} \
 && julia -e 'import Pkg; using Pkg; Pkg.update();' 

RUN julia -e 'using Pkg; Pkg.add("Plots")'
RUN julia -e 'using Pkg; Pkg.add("PyCall")'
RUN julia -e 'using Pkg; Pkg.add("IJulia")'
RUN julia -e 'using Pkg; Pkg.add("HDF5")'
RUN julia -e 'using Pkg; Pkg.add("LibPQ")'
RUN julia -e 'using Pkg; Pkg.add("MySQL")'
RUN julia -e 'using Pkg; Pkg.add("CSV")'
RUN julia -e 'using Pkg; Pkg.add("SQLite")'

RUN julia -e 'using IJulia'
RUN julia -e 'using PyCall'
RUN julia -e 'using HDF5'
RUN julia -e 'using Plots'
RUN julia -e 'using LibPQ, MySQL, CSV, SQLite'

RUN julia -e 'using Pkg; Pkg.clone("https://github.com/GiovineItalia/Gadfly.jl.git","Gadfly")' \
 && julia -e 'using Pkg; Pkg.build("Gadfly"); using Gadfly' 

RUN conda install -y -n python27 \
       'scikit-learn=0.19*=*openblas*' \
 && conda clean -tipsy \
 && julia -e 'using Pkg; Pkg.clone("https://github.com/cstjean/ScikitLearn.jl","ScikitLearn")' \
 && julia -e 'using Pkg; Pkg.build("ScikitLearn"); using ScikitLearn' \
 && julia -e 'using Pkg; Pkg.add("Pandas"); Pkg.add("PyPlot"); using Pandas; using PyPlot' \
 && julia -e 'using Pkg; Pkg.add("PyCallJLD"); using PyCallJLD' \
 && julia -e 'using Pkg; Pkg.add("RCall"); Pkg.add("RDatasets"); using RCall; using RDatasets'

RUN mv ${HOME}/.local/share/jupyter/kernels/julia* ${CONDA_DIR}/share/jupyter/kernels/ \
 && chmod -R go+rx ${CONDA_DIR}/share/jupyter 
