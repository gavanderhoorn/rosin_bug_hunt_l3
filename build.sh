#!/bin/bash

DOCKER_IMAGE='ros:lunar-ros-core'

if [ "$#" -ne 2 ];
then
  echo "USAGE: $0 /path/to/ros/workspace /path/to/rosinstall.file"
  exit 1
fi

if [ ! -d "$1" ];
then
  echo "USAGE: $0 /path/to/ros/workspace /path/to/rosinstall.file"
  echo "  $1 is not a directory."
  exit 1
fi

if [ ! -f "$2" ];
then
  echo "USAGE: $0 /path/to/ros/workspace /path/to/rosinstall.file"
  echo "  $2 is not a file."
  exit 1
fi

ROS_WS=$(readlink -f $1)
ROSINSTALL_FILE=$(readlink -f $2)

mkdir -p ${ROS_WS}/src

# setup and populate workspace
docker run -it --rm \
  -u $(id -u):$(id -g) \
  -v ${ROS_WS}:/ros_ws \
  -v ${ROSINSTALL_FILE}:/tmp/pkgs.rosinstall \
  ${DOCKER_IMAGE} \
    bash -c '\
      wstool init /ros_ws/src /tmp/pkgs.rosinstall && \
      cd /ros_ws && \
      catkin_make'
