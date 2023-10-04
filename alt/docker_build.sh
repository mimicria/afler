#!/bin/bash
docker build -t mimicria/afler:alt -f Dockerfile .
docker push mimicria/afler:alt