#!/bin/bash
#docker build --no-cache=True -t mimicria/afler:cent8 -f Dockerfile . |& tee ./build.log
docker build -t mimicria/afler:cent8 -f Dockerfile . |& tee ./build.log
docker push mimicria/afler:cent8
