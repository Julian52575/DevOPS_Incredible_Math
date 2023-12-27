#!/bin/bash

sudo docker image build -t jenkins-image .

sudo docker container run \
    --name my-jenkins \
    --restart=on-failure \
    --network jenkins-network \
    --env DOCKER_HOST=tcp://docker:2376 \
    --env DOCKER_CERT_PATH=/certs/client \
    --env DOCKER_TLS_VERIFY=1 \
    --publish 8080:8080 \
    --publish 50000:50000 \
    --volume jenkins-data:/var/jenkins_home \
    --volume jenkins-docker-certs:/certs/client:ro \
    jenkins-image 
    #--detach 
    #--volume /var/run/docker.sock:/var/run/docker.sock

#the last volume has been added to allow DinD
