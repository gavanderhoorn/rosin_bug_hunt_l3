#!/bin/bash

if [ "$#" -ne 2 ];
then
  echo "USAGE: $0 /path/to/ros/workspace /path/to/rosinstall.file"
  exit 1
fi

if [ ! -d "$1" ];
then
  echo "USAGE: $0 /path/to/ros/workspace /path/to/rosinstall.file"
  exit 1
fi

if [ ! -f "$2" ];
then
  echo "USAGE: $0 /path/to/ros/workspace /path/to/rosinstall.file"
  exit 1
fi

ROS_WS=$1
ROSINSTALL_FILE=$2

mkdir -p ${ROS_WS}/src

# setup and populate workspace
docker run -it --rm \
  -u $(id -u):$(id -g) \
  -v ${ROS_WS}:/ros_ws \
  -v ${ROSINSTALL_FILE}:/ros_ws/pkgs.rosinstall \
  ros:lunar-ros-core \
    bash -c 'wstool init /ros_ws/src /ros_ws/pkgs.rosinstall'

# build workspace
docker run -it --rm \
  -u $(id -u):$(id -g) \
  -v ${ROS_WS}:/ros_ws \
  ros:lunar-ros-core \
    bash -c '\
      cd /ros_ws && \
      catkin_make'
