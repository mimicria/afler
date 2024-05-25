FROM centos:7 AS base
LABEL maintainer="mimicria@mail.ru"
LABEL description="Докер контейнер с инструментами для фаззинга с применением AFL++"

# TimeZone
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Additional packages
RUN yum group install -y "Development Tools"
RUN yum install -y yum-utils rpmdevtools openssl-devel wget rsync git flex bison automake libcap-devel python3 python3-pip python3-devel 

# AFL++
RUN wget https://github.com/AFLplusplus/AFLplusplus/archive/refs/tags/2.68c.tar.gz && \
    tar xvzf 2.68c.tar.gz && rm -rf 2.68c.tar.gz
RUN cd /AFLplusplus-2.68c && \
    make && make install && rm -rf /AFLplusplus-2.68c
# afl-collect & exploitable
RUN git clone https://github.com/mimicria/afl-utils.git && \
    cd afl-utils && python3 -m pip install twitter && python3 setup.py install && \
    rm -rf /afl-utils
# afl-cov
RUN git clone https://github.com/mimicria/afl-cov.git && \
    ln -s /afl-cov/afl-cov /bin/afl-cov
# fuzzman
RUN python3 -m pip install --upgrade pip
RUN git clone https://github.com/mimicria/fuzzaide.git && \
    cd /fuzzaide && python3 -m pip install . && \
    rm -rf /fuzzaide
# Script
RUN wget https://raw.githubusercontent.com/mimicria/fuzz_scripts/main/aflplotter.py -P /bin && \
    chmod +x /bin/aflplotter.py
