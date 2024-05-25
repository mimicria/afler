FROM alpine:latest
LABEL maintainer="mimicria@mail.ru"
LABEL description="Докер контейнер с инструментами для фаззинга с применением AFL++"

# Add base packages
RUN apk update && \
    apk add build-base python3-dev automake cmake git flex bison lld llvm llvm-dev clang gmp-dev curl
# Add AFLplusplus latest
RUN git clone https://github.com/AFLplusplus/AFLplusplus.git /AFL && \
    cd /AFL/ && \
    sed -i 's|#include "config.h"|#include <linux/limits.h>\n#include "config.h"|g' ./src/afl-ld-lto.c && \
    sed -i 's|#define FANCY_BOXES|// #define FANCY_BOXES|g' ./include/config.h && \
    make source-only NO_NYX=1 && make install && \
    rm -rf /AFL
# Add python3 pip
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools
# Add afl-collect
RUN git clone https://github.com/mimicria/afl-utils.git && \
    cd afl-utils && python3 setup.py install && \
    rm -rf /afl-utils
# Add afl-cov
RUN git clone https://github.com/mimicria/afl-cov.git && \
    ln -s /afl-cov/afl-cov /bin/afl-cov
# Add fuzzman
RUN git clone https://github.com/mimicria/fuzzaide.git && \
    cd /fuzzaide && python -m pip install . && \
    rm -rf /fuzzaide
ENV PATH="${PATH}:/root/.cargo/bin"
RUN curl https://sh.rustup.rs | sh -s -- -y --default-toolchain=nightly --profile=minimal && \
    cargo install casr
# script for afl-plot
RUN wget https://raw.githubusercontent.com/mimicria/fuzz_scripts/main/aflplotter.py -P /bin && \
    chmod +x /bin/aflplotter.py
# script for casr-collect
RUN wget https://raw.githubusercontent.com/mimicria/fuzz_scripts/main/casr-collect.py -P /bin && \
    chmod +x /bin/casr-collect.py && python -m pip install termcolor