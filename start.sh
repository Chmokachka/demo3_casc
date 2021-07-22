#!/bin/bash/

docker build -t jenkins:lts .

. ./credentials

docker run --name jenkins \
--rm -p 8080:8080 \
jenkins:lts
