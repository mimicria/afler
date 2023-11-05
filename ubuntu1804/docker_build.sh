#!/bin/bash
docker build --no-cache=True -t mimicria/afler:ub1804 -f Dockerfile .
docker push mimicria/afler:ub1804