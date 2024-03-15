#!/bin/bash
docker build --no-cache=True -t mimicria/afler:osuse155 -f Dockerfile .
docker push mimicria/afler:osuse155
