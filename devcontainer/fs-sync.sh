#!/bin/bash

CONTAINER_NAME="$1"
CONTAINER_USER_ID=$(docker exec $CONTAINER_NAME id -u)
CONTAINER_GROUP_ID=$(docker exec $CONTAINER_NAME id -g)
CONTAINER_DIR="/home/grim_reaper/shared-storage"
HOST_DIR="/home/grim_reaper/host_workspace"
echo $CONTAINER_USER_ID $CONTAINER_GROUP_ID
HOST_USER_ID=$(id -u)
HOST_GROUP_ID=$(id -g)
echo $HOST_USER_ID $HOST_GROUP_ID
sleep 5

sudo rsync -av --delete --chown=$CONTAINER_USER_ID:$CONTAINER_GROUP_ID "$HOST_DIR/" "$CONTAINER_DIR/"

inotifywait -m -r -e modify,create,delete,move "$CONTAINER_DIR" "$HOST_DIR" | 
while read -r directory events filename; do
  echo "Change detected: $events $directory$filename"

  # Sync from host to shared storage
  sudo rsync -av --delete --chown=$CONTAINER_USER_ID:$CONTAINER_GROUP_ID "$HOST_DIR/" "$CONTAINER_DIR/"

  # Sync from shared storage to host
  # sudo rsync -av --delete --chown=$HOST_USER_ID:$HOST_GROUP_ID "$CONTAINER_DIR/" "$HOST_DIR"

done
