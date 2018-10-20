FROM postgres:10

USER root

RUN usermod -u 1000 postgres
RUN groupmod -g 1000 postgres

 