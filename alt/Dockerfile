FROM alt:latest
LABEL maintainer="mimicria@mail.ru"
LABEL description="Докер контейнер с инструментами для фаззинга с применением AFL++"

# TimeZone settings
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Main packages 
RUN apt-get update && \
    apt-get -y install python3 pip python3-dev gcc gcc-plugin-devel gcc-c++ \
        git make gdb strace ltrace zip wget curl flex bison automake autoconf lcov gnuplot psmisc bzip2 pkg-config \
        llvm14.0 llvm14.0-devel clang14.0 clang14.0-libs lld14.0

ENV ALTWRAP_LLVM_VERSION=14.0
RUN llvm-alt-tool-wrapper;clang --version

# AFL++
RUN git clone https://github.com/AFLplusplus/AFLplusplus /AFLplusplus && \
    cd /AFLplusplus/src && \
    wget -q https://raw.githubusercontent.com/mimicria/fuzz_scripts/main/afl_patch_scr.py && \
    python3 afl_patch_scr.py && \
    cd /AFLplusplus && \
    # UBSAN error messages enable
    sed -i 's|cc_params\[cc_par_cnt++\] = "-fsanitize-undefined-trap-on-error";||g' ./src/afl-cc.c && \
    # simple interface
    sed -i 's|#define FANCY_BOXES|// #define FANCY_BOXES|g' ./include/config.h && \
    make source-only NO_NYX=1 && make install && \
    rm -rf /AFLplusplus

# afl-collect with exploitable
RUN pip install setuptools && \
    git clone https://github.com/mimicria/afl-utils.git && \
    cd afl-utils && python3 setup.py install && \
    rm -rf /afl-utils

# afl-cov
RUN git clone https://github.com/mimicria/afl-cov.git && \
    ln -s /afl-cov/afl-cov /bin/afl-cov

# fuzzman
RUN git clone https://github.com/mimicria/fuzzaide.git && \
    cd /fuzzaide && pip install . && \
    rm -rf /fuzzaide

# casr
ENV PATH="${PATH}:/root/.cargo/bin"
RUN curl https://sh.rustup.rs | sh -s -- -y --default-toolchain=nightly --profile=minimal && \
    cargo install casr

# script for afl-plot
RUN wget -q https://raw.githubusercontent.com/mimicria/fuzz_scripts/main/aflplotter.py -P /bin && \
    chmod +x /bin/aflplotter.py

# script for casr-collect
RUN wget -q https://raw.githubusercontent.com/mimicria/fuzz_scripts/main/casr-collect.py -P /bin && \
    chmod +x /bin/casr-collect.py && python3 -m pip install termcolor
