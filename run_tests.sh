#!/bin/bash

DOCKER_IMAGE='ros:lunar-ros-core'

if [ "$#" -ne 1 ];
then
  echo "USAGE: $0 /path/to/ros/workspace"
  exit 1
fi

if [ ! -d "$1" ];
then
  echo "USAGE: $0 /path/to/ros/workspace"
  echo "  $1 is not a directory."
  exit 1
fi

ROS_WS=$(readlink -f $1)

docker run -it --rm \
  -u $(id -u):$(id -g) \
  -v ${ROS_WS}:/ros_ws \
  ${DOCKER_IMAGE} \
    bash -c '\
      cd /ros_ws && \
      source devel/setup.bash && \
      catkin_make run_tests_roslaunch && \
      catkin_test_results'
