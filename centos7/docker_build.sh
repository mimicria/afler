#!/bin/bash
docker build --no-cache=True -t mimicria/afler:cent7 -f Dockerfile .
docker push mimicria/afler:cent7