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
RUN wget -q https://github.com/llvm/llvm-project/releases/download/llvmorg-14.0.6/llvm-project-14.0.6.src.tar.xz && \
    tar -xf llvm-project-14.0.6.src.tar.xz && \
    rm -f llvm-project-14.0.6.src.tar.xz && \
    cd llvm-project-14.0.6.src && mkdir build && cd build && \
    source scl_source enable devtoolset-10 && cmake -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_PROJECTS="clang;compiler-rt;lld;clang-tools-extra" -G "Unix Makefiles" ../llvm && \
    make && make install && rm -rf /llvm-project-14.0.6.src

# AFL++
RUN git clone https://github.com/AFLplusplus/AFLplusplus /AFLplusplus && \
    cd /AFLplusplus/src && \
    wget -q https://raw.githubusercontent.com/mimicria/fuzz_scripts/main/afl_patch_scr.py && \
    python3 afl_patch_scr.py && \
    cd /AFLplusplus && \
    # включить сообщения об ошибках санитайзера UBSAN
    sed -i 's|cc_params\[cc_par_cnt++\] = "-fsanitize-undefined-trap-on-error";||g' ./src/afl-cc.c && \
    # использовать простые рамки интерфейса AFL++
    sed -i 's|#define FANCY_BOXES|// #define FANCY_BOXES|g' ./include/config.h && \
    source scl_source enable devtoolset-10 && make source-only NO_NYX=1 && make install && rm -rf /AFLplusplus

RUN python3 -m pip install --upgrade pip
# afl-collect & exploitable
RUN git clone https://github.com/mimicria/afl-utils.git && \
    cd afl-utils && python3 setup.py install && \
    rm -rf /afl-utils
#  afl-cov
RUN git clone https://github.com/mimicria/afl-cov.git && \
    ln -s /afl-cov/afl-cov /bin/afl-cov
# fuzzman
RUN git clone https://github.com/mimicria/fuzzaide.git && \
    cd /fuzzaide && python3 -m pip install . && \
    rm -rf /fuzzaide
# casr
ENV PATH="${PATH}:/root/.cargo/bin"
RUN curl https://sh.rustup.rs | sh -s -- -y --default-toolchain=nightly --profile=minimal && \
    cargo install casr
# Scripts
RUN wget https://raw.githubusercontent.com/mimicria/fuzz_scripts/main/aflplotter.py -P /bin && \
    chmod +x /bin/aflplotter.py
RUN wget -q https://raw.githubusercontent.com/mimicria/fuzz_scripts/main/casr-collect.py -P /bin && \
    chmod +x /bin/casr-collect.py && python3 -m pip install termcolor
