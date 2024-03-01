#!/bin/bash
docker build -t mimicria/afler:osuse155 -f Dockerfile .
docker push mimicria/afler:osuse155
