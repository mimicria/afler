#!/bin/bash
docker build --no-cache=True -t mimicria/afler:osuse154 -f Dockerfile .
docker push mimicria/afler:osuse154