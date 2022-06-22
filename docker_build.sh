#!/bin/bash
docker build -t mimicria/afler:latest -f Dockerfile .
docker push mimicria/afler:latest