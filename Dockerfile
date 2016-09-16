# Copyright (c) 2016, Nimbix, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# The views and conclusions contained in the software and documentation are
# those of the authors and should not be interpreted as representing official
# policies, either expressed or implied, of Nimbix, Inc.
#
# Author: Stephen Fox (stephen.fox@nimbix.net)
#

FROM jarvice/centos-slurm:6-gcc-4.9
MAINTAINER stephen.fox@nimbix.net

ENV TOOLCHAIN=/opt/rh/devtoolset-3/enable
ENV SLURM_VERSION=16.05.4
ENV MVAPICH2_VERSION=2.2
ENV BUILD_DIR=/usr/local/src
ENV INSTALL_ROOT=/opt

WORKDIR ${BUILD_DIR}
RUN yum install -y \
    curl \
    libibverbs-devel \
    libibverbs1 \
    librdmacm1 \
    librdmacm-devel \
    rdmacm-utils \
    libibmad-devel \
    libibmad5 \
    byacc \
    libibumad-devel \
    libibumad3 \
    flex

RUN rm -rf ${BUILD_DIR}/*
RUN curl -O "http://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-${MVAPICH2_VERSION}.tar.gz"
RUN md5sum "mvapich2-${MVAPICH2_VERSION}.tar.gz" > "mvapich2-${MVAPICH2_VERSION}.tar.gz.md5"
RUN tar xvf "mvapich2-${MVAPICH2_VERSION}.tar.gz"

WORKDIR "${BUILD_DIR}/mvapich2-${MVAPICH2_VERSION}"
RUN source ${TOOLCHAIN} && \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/slurm-${SLURM_VERSION}/lib && \
               ./configure \
                --prefix="${INSTALL_ROOT}/mvapich2-${MVAPICH2_VERSION}-slurm-${SLURM_VERSION}" \
                --with-pm=no \
                --with-pmi=slurm \
                --enable-romio=no \
                --with-slurm="${INSTALL_ROOT}/slurm-${SLURM_VERSION}" \
                --enable-fortran=yes \
                RSH_CMD=/usr/bin/ssh \
                SSH_CMD=/usr/bin/ssh && \
                make -j4 && \
                make install

RUN rm -rf "${BUILD_DIR}/mvapich2-${MVAPICH2_VERSION}"

WORKDIR "${BUILD_DIR}"
RUN tar xvf "mvapich2-${MVAPICH2_VERSION}.tar.gz"
WORKDIR "${BUILD_DIR}/mvapich2-${MVAPICH2_VERSION}"
RUN source ${TOOLCHAIN} && \
               ./configure \
                --prefix="/opt/mvapich2-${MVAPICH2_VERSION}" \
                --enable-fortran=yes \
                RSH_CMD=/usr/bin/ssh \
                SSH_CMD=/usr/bin/ssh && \
                make -j4 && \
                make install

RUN rm -rf ${BUILD_DIR}/*

ADD ./scripts/mvapich2 /opt/mvapich2-${MVAPICH2_VERSION}/enable
ADD ./scripts/mvapich2-slurm /opt/mvapich2-${MVAPICH2_VERSION}-slurm-${SLURM_VERSION}/enable
