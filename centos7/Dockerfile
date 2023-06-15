FROM centos:7 AS base
LABEL maintainer="mimicria@cbi57.ru"
LABEL description="Докер контейнер с инструментами для фаззинга с применением AFL++"

# TimeZone settings
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Additional packages
RUN yum group install -y "Development Tools"
RUN yum install -y yum-utils rpmdevtools scl-utils wget rsync git flex bison automake python3 python3-pip python3-devel centos-release-scl-rh openssl-devel libcap-devel
RUN yum --enablerepo=centos-sclo-rh-testing install -y devtoolset-10 devtoolset-10-gcc-plugin-devel devtoolset-10-gcc-c++

# Cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.24.0/cmake-3.24.0.tar.gz && \
    tar -xvzf cmake-3.24.0.tar.gz && rm -rf cmake-3.24.0.tar.gz && \
    cd cmake-3.24.0 && source scl_source enable devtoolset-10 && ./bootstrap && make && make install && rm -rf /cmake-3.24.0

# LLVM
RUN wget https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-12.0.1.tar.gz && \
    tar -xf llvmorg-12.0.1.tar.gz && \
    cd llvm-project-llvmorg-12.0.1 && mkdir build && cd build && \
    source scl_source enable devtoolset-10 && cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;lld;clang-tools-extra" -G "Unix Makefiles" ../llvm && \
    make && make install && rm -rf /llvm-project-llvmorg-12.0.1

# AFL++
RUN git clone https://github.com/AFLplusplus/AFLplusplus /AFLplusplus
RUN cd /AFLplusplus && \
    # включить сообщения об ошибках санитайзера UBSAN
    sed -i 's|cc_params\[cc_par_cnt++\] = "-fsanitize-undefined-trap-on-error";||g' ./src/afl-cc.c && \
    # использовать простые рамки интерфейса AFL++
    sed -i 's|#define FANCY_BOXES|// #define FANCY_BOXES|g' ./include/config.h && \
    source scl_source enable devtoolset-10 && make source-only && make install && rm -rf /AFLplusplus

# afl-collect & exploitable
RUN git clone https://github.com/mimicria/afl-utils.git && \
    cd afl-utils && python3 setup.py install && \
    rm -rf /afl-utils
#  afl-cov
RUN git clone https://github.com/mimicria/afl-cov.git && \
    ln -s /afl-cov/afl-cov /bin/afl-cov
# fuzzman
RUN python3 -m pip install --upgrade pip
RUN git clone https://github.com/mimicria/fuzzaide.git && \
    cd /fuzzaide && python3 -m pip install . && \
    rm -rf /fuzzaide
# Scripts
RUN wget https://raw.githubusercontent.com/mimicria/fuzz_scripts/main/aflplotter.py -P /bin && \
    chmod +x /bin/aflplotter.py
