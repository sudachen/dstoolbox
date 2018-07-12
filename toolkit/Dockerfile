FROM sudachen/jupy2r:latest

USER root
RUN base=https://github.com/docker/machine/releases/download/v0.14.0 \
    && curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine \
    && install /tmp/docker-machine /usr/local/bin/docker-machine \
    && rm /tmp/docker-machine \
    && apt-get update --fix-missing \
    && apt-get install -y --no-install-recommends \
        mysql-client \
        mysql-utilities \
        postgresql-client \
        gnupg2 \
        ssh \
        apt-transport-https \
	    openvpn \
        net-tools \
        iputils-ping \
        dnsutils \
	    joe \
	    zbar-tools \
        curl \
        file \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
    && echo "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable" >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        docker-ce \
    && apt-get clean \
    && curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose \
    && chmod a+x /usr/local/bin/docker-compose

USER $NB_USER
RUN pip install -U --no-cache-dir \
        pyotp \
    \
    && conda clean -tipsy 
