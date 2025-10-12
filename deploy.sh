#!/bin/bash

IMAGE_TAG=$1
PORT=$2
TMDB_API_KEY=$3
CONTAINER_NAME="nextflix"

echo "Deploying image: $IMAGE_TAG on port $PORT"

# 1. Pull the image
docker pull $IMAGE_TAG

# Check if the container is already running
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    echo "Stopping existing container: $CONTAINER_NAME"
    docker stop $CONTAINER_NAME
fi

# Check if the container exists (stopped or running)
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    echo "Removing existing container: $CONTAINER_NAME"
    docker rm $CONTAINER_NAME
fi


echo "Starting new container: $CONTAINER_NAME"
docker run -d \
    --name $CONTAINER_NAME \
    -p $PORT:$PORT \
    -e TMDB_API_KEY=$TMDB_API_KEY \
    $IMAGE_TAG

echo "Deployment complete. Container $CONTAINER_NAME is running."