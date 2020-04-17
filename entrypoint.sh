#!/bin/sh

DOCKER_TOKEN=$1
DOCKER_IMAGE_NAME=$2
DOCKER_IMAGE_TAG=$3
EXTRACT_TAG_FROM_GIT_REF=$4
USE_BRANCH_NAME_AS_TAG=$5

if [ $EXTRACT_TAG_FROM_GIT_REF == "true" ]; then
  DOCKER_IMAGE_TAG=$(echo ${GITHUB_REF} | sed -e "s/refs\/tags\///g")
fi

if [ USE_BRANCH_NAME_AS_TAG == "true" ]; then
  DOCKER_IMAGE_TAG=$(echo ${GITHUB_REF} | sed -e "s/refs\/heads\///g")
fi

DOCKER_IMAGE_FULL_PATH=$(echo docker.pkg.github.com/${GITHUB_REPOSITORY}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} | tr '[:upper:]' '[:lower:]')

docker login -u publisher -p ${DOCKER_TOKEN} docker.pkg.github.com
docker build -t $DOCKER_IMAGE_FULL_PATH .
docker push $DOCKER_IMAGE_FULL_PATH
