#!/bin/bash
docker build --no-cache=True -t mimicria/afler:cent7 -f Dockerfile . |& tee ./build.log
docker push mimicria/afler:cent7