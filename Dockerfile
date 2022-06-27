FROM ubuntu:22.04 AS base
LABEL maintainer="vova@cbi57.ru"
LABEL description="Докер контейнер с инструментами для фаззинга с применением AFL++"

# Настройка TimeZone
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Основные пакеты для сборки
RUN apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
        python3 python3-pip python3-dev gcc \
        git make gdb strace ltrace zip wget flex bison automake autoconf lcov ninja-build \
        cron gnuplot screen psmisc \
        lld llvm llvm-dev clang
RUN apt-get -y install --no-install-suggests --no-install-recommends \
    gcc-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-plugin-dev libstdc++-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-dev
# Ставим AFL++
RUN git -c advice.detachedHead=false clone --depth 1 https://github.com/AFLplusplus/AFLplusplus /AFLplusplus
RUN cd /AFLplusplus && \
    # включить сообщения об ошибках санитайзера UBSAN
    sed -i 's|cc_params\[cc_par_cnt++\] = "-fsanitize-undefined-trap-on-error";||g' ./src/afl-cc.c && \
    # использовать простые рамки интерфейса AFL++
    sed -i 's|#define FANCY_BOXES|// #define FANCY_BOXES|g' ./include/config.h && \
    make STATIC=1 distrib && make install
RUN sysctl -w kernel.core_pattern="core-%e" && \
    echo -e "[+] Test run ok"
# Ставим afl-collect и exploitable
RUN git clone https://gitlab.com/rc0r/afl-utils && \
    cd afl-utils && python3 -m pip install twitter && python3 setup.py install    
# Ставим afl-cov
RUN git clone https://github.com/mimicria/afl-cov.git && \
    ln -s /afl-cov/afl-cov /bin/afl-cov
# Ставим dupmanage/fuzzman
RUN git -c advice.detachedHead=false clone --depth 1 -b refactor https://github.com/fuzzah/fuzzaide && \
    cd /fuzzaide && pip install .
# Качаем скрипт для получения html-отчёта о покрытии
RUN wget https://raw.githubusercontent.com/llvm/llvm-project/main/llvm/utils/prepare-code-coverage-artifact.py -P /bin
# Качаем скрипт для убивания процесса при сборе покрытия
RUN wget https://raw.githubusercontent.com/mimicria/fuzz_scripts/main/kill_proc_after_min.py -P /bin && \
    chmod +x /bin/kill_proc_after_min.py
