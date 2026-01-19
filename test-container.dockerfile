FROM spack/ubuntu-jammy:0.21

ENV JULIA_ROOT=/opt/julia

RUN export DEBIAN_FRONTEND=noninteractive \
   && apt update -y \
   && apt upgrade -y \
   && apt install -y \
   wget  \
   graphviz \
   && apt clean

RUN mkdir -p ${JULIA_ROOT}  \
   && wget -q https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.2-linux-x86_64.tar.gz  \
   -O julia.tar.gz  \
   && tar zxvf julia.tar.gz -C ${JULIA_ROOT} --strip-component=1 \
   && rm -rf julia.tar.gz

ENV PATH=$PATH:${JULIA_ROOT}/bin

RUN mkdir -p /workdir
WORKDIR /workdir
