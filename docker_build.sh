#!/bin/bash
docker build --no-cache=True -t mimicria/afler:latest -f Dockerfile .
docker push mimicria/afler:latest