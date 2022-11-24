FROM centos:7 AS base
LABEL maintainer="vova@cbi57.ru"
LABEL description="Докер контейнер с инструментами для фаззинга с применением AFL++"

# Настройка TimeZone
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Основные пакеты для сборки
RUN yum group install -y "Development Tools"
RUN yum install -y yum-utils rpmdevtools openssl-devel wget rsync git flex bison automake libcap-devel python3 python3-pip python3-devel 

# Ставим AFL++
RUN wget https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/2.68c.tar.gz && \
    tar xvzf 2.68c.tar.gz && ls -a
RUN cd /AFLplusplus-2.68c && \
    make && make install
# RUN sysctl -w kernel.core_pattern="core-%e" && \
#     echo -e "[+] Test run ok"
# Ставим afl-collect и exploitable
RUN git clone https://github.com/mimicria/afl-utils.git && \
    cd afl-utils && python3 -m pip install twitter && python3 setup.py install    
# Ставим afl-cov
RUN git clone https://github.com/mimicria/afl-cov.git && \
    ln -s /afl-cov/afl-cov /bin/afl-cov
# Ставим dupmanage/fuzzman
RUN python3 -m pip install --upgrade pip
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
