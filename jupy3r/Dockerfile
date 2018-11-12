FROM sudachen/jupyter:latest
LABEL maintainer="Alexey Sudachen <alexey@sudachen.name>"

USER root

RUN apt-get install -y --no-install-recommends \
        libzmq3-dev libssl-dev screen \
 && apt-get clean

USER $NB_USER

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
      -i user -I user:sh.almond:scala-kernel-api_$SCALA_VERSION:$ALMOND_VERSION \
      sh.almond:scala-kernel_$SCALA_VERSION:$ALMOND_VERSION \
      -o almond_2_12 \
 && chmod +x almond_2_12 \
 && ./almond_2_12 --id almond_scala_2_12 --display-name "Scala 2.12" --install \
 && rm ./almond_2_12

# Spark

ENV SPARK_HOME=/opt/spark \
    PYTHONPATH=/opt/spark/python:/opt/spark/python/lib/py4j-0.10.6-src.zip \
    SPARK_XMX=2048M

ENV SPARK_OPTS=\
        --driver-java-options=-Xms1024M \
        --driver-java-options=-Xmx$SPARK_XMX \
        --driver-java-options=-Dlog4j.logLevel=info

USER root

RUN mkdir ${SPARK_HOME} \
 && curl -L http://apache.claz.org/spark/spark-2.4.0/spark-2.4.0-bin-without-hadoop-scala-2.12.tgz -o /tmp/spark.tgz \
 && tar xzf /tmp/spark.tgz -C ${SPARK_HOME} --strip-components=1 \
 && rm /tmp/spark.tgz \
 && chown $NB_USER ${SPARK_HOME} \
 && fix-permissions ${SPARK_HOME}

USER $NB_USER  

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre 
RUN curl -L https://github.com/sudachen/dstoolbox/releases/download/1.23/hadoop-2.8-jars.7z -o /tmp/hadoop-2.8-jars.7z \
 && cd /opt/spark \
 && 7z x /tmp/hadoop-2.8-jars.7z \
 && rm /tmp/hadoop-2.8-jars.7z

RUN pip install -U --no-cache-dir git+git://github.com/sudachen/spark-sklearn#egg=spark_sklearn\&subdirectory=python 

ENV CLASSPATH=/opt/spark/jars:$CLASSPATH

# C++
#RUN conda create -n cling \
# && conda install -y -n cling -c QuantStack -c conda-forge xeus-cling \
# && conda clean -tipsy \
# && rm -rf ${CONDA_DIR}/pkgs/* 
#RUN cp -r $CONDA_DIR/env/cling/share/jupyter/kernels/xeus-cling-cpp17 $HOME/.local/share/jupyter/kernels

# Dask

RUN conda install -y dask \
 && jupyter labextension install \
	dask-labextension \
 && rm -rf ${CONDA_DIR}/share/jupyter/lab/staging \
 && rm -rf ${HOME}/.cache/yarn \
 && rm -rf ${HOME}/.node-gyp \
 && conda clean -tipsy \
 && npm cache clean --force \
 && rm -rf ${CONDA_DIR}/pkgs/*

