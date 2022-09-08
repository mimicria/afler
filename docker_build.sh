#!/bin/bash
docker build --no-cache=True -t mimicria/afler:ub2204 -f Dockerfile .
#docker build -t mimicria/afler:latest -f Dockerfile .
docker push mimicria/afler:ub2204