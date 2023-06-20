#!/bin/bash
docker build --no-cache=True -t mimicria/afler:alpine -f Dockerfile .
docker push mimicria/afler:alpine