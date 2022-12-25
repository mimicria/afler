FROM ubuntu:22.04
LABEL maintainer="vova@cbi57.ru"
LABEL description="Докер контейнер с инструментами для фаззинга с применением AFL++"

# TimeZone settings
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Main packages 
RUN apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
        python3 python3-pip python3-dev gcc g++\
        git make gdb strace ltrace zip wget flex bison automake autoconf lcov gnuplot psmisc bzip2 pkg-config cargo \
        lld llvm llvm-dev clang
RUN apt-get -y install --no-install-suggests --no-install-recommends \
    gcc-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-plugin-dev libstdc++-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-dev && \
    rm -rf /var/lib/apt/lists/*
# AFL++
RUN git clone https://github.com/AFLplusplus/AFLplusplus /AFLplusplus && \
    cd /AFLplusplus && \
    # UBSAN error messages enable
    sed -i 's|cc_params\[cc_par_cnt++\] = "-fsanitize-undefined-trap-on-error";||g' ./src/afl-cc.c && \
    # simple interface
    sed -i 's|#define FANCY_BOXES|// #define FANCY_BOXES|g' ./include/config.h && \
    make source-only NO_NYX=1 && make install && \
    rm -rf /AFLplusplus
# afl-collect with exploitable
RUN git clone https://github.com/mimicria/afl-utils.git && \
    cd afl-utils && python3 -m pip install twitter && python3 setup.py install && \
    rm -rf /afl-utils
# afl-cov
RUN git clone https://github.com/mimicria/afl-cov.git && \
    ln -s /afl-cov/afl-cov /bin/afl-cov
# fuzzman
RUN git clone https://github.com/mimicria/fuzzaide.git && \
    cd /fuzzaide && pip install . && \
    rm -rf /fuzzaide
# casr
RUN cargo install casr
ENV PATH="${PATH}:/root/.cargo/bin"
# script for afl-plot
RUN wget https://raw.githubusercontent.com/mimicria/fuzz_scripts/main/aflplotter.py -P /bin && \
    chmod +x /bin/aflplotter.py
# script for casr-collect
RUN wget https://raw.githubusercontent.com/mimicria/fuzz_scripts/main/casr-collect.py -P /bin && \
    chmod +x /bin/casr-collect.py && python3 -m pip install termcolor
