#!/bin/bash

docker stop $(docker ps -q --filter ancestor=aflplusplus/aflplusplus)
