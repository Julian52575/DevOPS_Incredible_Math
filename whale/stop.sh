#!/bin/bash

sudo docker container stop my-jenkins

sudo docker container rm my-jenkins

sudo docker container prune -f
