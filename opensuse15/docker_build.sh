#!/bin/bash
docker build -t mimicria/afler:osuse154 -f Dockerfile .
docker push mimicria/afler:osuse154