#!/bin/bash
docker build -t mimicria/afler:ub2204 -f Dockerfile .
docker push mimicria/afler:ub2204