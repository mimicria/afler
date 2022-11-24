FROM ubuntu:18.04
LABEL maintainer="vova@cbi57.ru"
LABEL description="Докер контейнер с инструментами для фаззинга с применением AFL++"

# Настройка TimeZone
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Основные пакеты для сборки
RUN apt-get update && \
    apt-get -y install --no-install-suggests --no-install-recommends \
        python3 python3-pip python3-dev python3-setuptools gcc g++\
        git make gdb strace ltrace zip wget flex bison automake autoconf lcov ninja-build cargo \
        cron gnuplot screen psmisc nano bzip2 pkg-config \
        lld llvm llvm-dev clang
RUN apt-get -y install --no-install-suggests --no-install-recommends \
    gcc-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-plugin-dev libstdc++-$(gcc --version|head -n1|sed 's/\..*//'|sed 's/.* //')-dev
# Ставим AFL++
RUN git clone https://github.com/AFLplusplus/AFLplusplus /AFLplusplus
RUN cd /AFLplusplus && \
    # включить сообщения об ошибках санитайзера UBSAN
    sed -i 's|cc_params\[cc_par_cnt++\] = "-fsanitize-undefined-trap-on-error";||g' ./src/afl-cc.c && \
    # использовать простые рамки интерфейса AFL++
    sed -i 's|#define FANCY_BOXES|// #define FANCY_BOXES|g' ./include/config.h && \
    make source-only && make install
RUN sysctl -w kernel.core_pattern="core-%e" && \
    echo -e "[+] Test run ok"
# Ставим afl-collect и exploitable
#RUN git clone https://github.com/mimicria/exploitable.git && \
#    cd exploitable && python3 setup.py install
RUN git clone https://github.com/mimicria/afl-utils.git && \
    cd afl-utils && python3 -m pip install twitter && python3 setup.py install
# Ставим afl-cov
RUN git clone https://github.com/mimicria/afl-cov.git && \
    ln -s /afl-cov/afl-cov /bin/afl-cov
# Ставим fuzzman
RUN git clone https://github.com/mimicria/fuzzaide.git && \
    cd /fuzzaide && python3 -m pip install .
# Качаем скрипт для получения html-отчёта о ходе фаззинга
RUN wget https://raw.githubusercontent.com/mimicria/fuzz_scripts/main/aflplotter.py -P /bin && \
    chmod +x /bin/aflplotter.py
# Качаем скрипт для получения html-отчёта о покрытии
# RUN wget https://raw.githubusercontent.com/llvm/llvm-project/main/llvm/utils/prepare-code-coverage-artifact.py -P /bin
# Качаем скрипт для убивания процесса при сборе покрытия
#RUN wget https://raw.githubusercontent.com/mimicria/fuzz_scripts/main/kill_proc_after_min.py -P /bin && \
#    chmod +x /bin/kill_proc_after_min.py && \
#    pip3 install psutil
