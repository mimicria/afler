FROM opensuse/leap:15.4
LABEL maintainer="mimicria@mail.ru"
LABEL description="Докер контейнер с инструментами для фаззинга с применением AFL++"

RUN cd /etc/zypp/repos.d && \
    rm -rf repo-backports-debug-update.repo repo-backports-update.repo repo-debug-non-oss.repo repo-debug-update-non-oss.repo \
	repo-debug-update.repo repo-debug.repo repo-non-oss.repo repo-sle-debug-update.repo repo-sle-update.repo repo-source.repo \
	repo-update-non-oss.repo repo-update.repo && \
    zypper ref && \
    zypper -n install --no-recommends python3 python3-pip python3-devel gcc gcc-c++\
        git make gdb strace ltrace zip wget curl flex bison automake autoconf lcov gnuplot bzip2 pkg-config \
        lld llvm llvm-devel clang rpm-build screen && \
    zypper clean --all
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
# afl-cov
RUN git clone https://github.com/mimicria/afl-cov.git && \
    ln -s /afl-cov/afl-cov /bin/afl-cov
# afl-collect with exploitable
RUN git clone https://github.com/mimicria/afl-utils.git && \
    cd afl-utils && python3 setup.py install && \
    rm -rf /afl-utils
# casr
ENV PATH="${PATH}:/root/.cargo/bin"
RUN curl https://sh.rustup.rs | sh -s -- -y --default-toolchain=nightly --profile=minimal && \
    cargo install casr
# script for casr-collect
RUN wget https://raw.githubusercontent.com/mimicria/fuzz_scripts/main/casr-collect.py -P /bin && \
    chmod +x /bin/casr-collect.py && python3 -m pip install termcolor
# script for afl-plot
RUN wget -q https://raw.githubusercontent.com/mimicria/fuzz_scripts/main/aflplotter.py -P /bin && \
    chmod +x /bin/aflplotter.py
