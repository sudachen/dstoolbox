#!/bin/sh

VERSION=1.5

CONFIG_DIR=${HOME}/.dstoolbox
DSTOOLBOX_YAML=${CONFIG_DIR}/docker-compose.yml
DSTOOLBOX_DOCKERFILE=${CONFIG_DIR}/Dockerfile
DSTOOLBOX_DOCKERUSER=${CONFIG_DIR}/Dockerfile.user
DSTOOLBOX_NBCONFIG=${CONFIG_DIR}/jupyter_notebook_config.py
DSTOOLBOX_KSETUP=${CONFIG_DIR}/setup_kernel.py
GITHUB_TOOLBOX=https://raw.githubusercontent.com/sudachen/dstoolbox/master/toolbox/

if [ -f ${CONFIG_DIR}/.version ]; then
  echo "${CONFIG_DIR} updating ..."
  curl -s ${GITHUB_TOOLBOX}/Dockerfile.in -o Dockerfile.in && \
  curl -s ${GITHUB_TOOLBOX}/jupyter_notebook_config.py -o jupyter_notebook_config.py && \
  curl -s ${GITHUB_TOOLBOX}/setup_kernel.py -o setup_kernel.py && \
  curl -s ${GITHUB_TOOLBOX}/dst_up -o up && \
  curl -s ${GITHUB_TOOLBOX}/dst_down -o down && \
  chmod u+x up down && \
  sh ./up && \
  echo "success" || echo "failed"
else
  mkdir -p ${CONFIG_DIR} && \
  cd ${CONFIG_DIR} && \
  curl -s ${GITHUB_TOOLBOX}/docker-compose.in.yml -o docker-compose.yml && \
  curl -s ${GITHUB_TOOLBOX}/Dockerfile.in -o Dockerfile.in && \
  curl -s ${GITHUB_TOOLBOX}/jupyter_notebook_config.py -o jupyter_notebook_config.py && \
  curl -s ${GITHUB_TOOLBOX}/setup_kernel.py -o setup_kernel.py && \
  curl -s ${GITHUB_TOOLBOX}/docker-compose.in.yml -o docker-compose.yml && \
  curl -s ${GITHUB_TOOLBOX}/dst_up -o up && \
  curl -s ${GITHUB_TOOLBOX}/dst_down -o down && \
  chmod u+x up down && \
  sh ./up && \
  echo "${VERSION}" > .version
fi
