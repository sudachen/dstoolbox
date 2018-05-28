FROM sudachen/jupyter:latest
LABEL maintainer="Alexey Sudachen <alexey@sudachen.name>"

ENV GO_VERSION=1.9.6 \
    GOROOT=/opt/go \
    GOPATH=/opt/go/user \
    LGOPATH=/opt/go/user/lgo \
    PATH=$PATH:/opt/go/bin:/opt/go/user/bin

USER root

RUN apt-get update --fix-missing \
    && apt-get install -qy --no-install-recommends \
        pkg-config \
	libzmq3-dev \
    && rm -rf /var/lib/apt/lists/* 

RUN wget https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz -O /tmp/go.tar.gz \
    && mkdir ${GOROOT} \
    && tar zxf /tmp/go.tar.gz -C ${GOROOT} --strip-components=1 \
    && rm /tmp/go.tar.gz \
    && mkdir ${GOPATH} \
    && chown $NB_USER ${GOPATH} \
    && fix-permissions ${GOPATH}

USER $NB_UID
	
RUN go get github.com/yunabe/lgo/cmd/lgo \
    && go get -d github.com/yunabe/lgo/cmd/lgo-internal \
    && lgo install \
    && python ${GOPATH}/src/github.com/yunabe/lgo/bin/install_kernel \
    && fix-permissions ${CONDA_DIR}/share/jupyter \
    && fix-permissions ${GOPATH}

RUN jupyter labextension install @yunabe/lgo_extension \
    && conda clean -tipsy \
    && npm cache clean --force \
    && fix-permissions ${CONDA_DIR} \
    && fix-permissions ${HOME}

ENV JUPYTER_HAS_GO=$GO_VERSION

