#!/bin/bash
if [ "$#" -ne 1 ];
then
  echo "USAGE: $0 /path/to/ros/workspace"
  exit 1
fi

if [ ! -d "$1" ];
then
  echo "USAGE: $0 /path/to/ros/workspace"
  exit 1
fi

ROS_WS=$(readlink -f $1)

docker run -it --rm \
  -u $(id -u):$(id -g) \
  -v ${ROS_WS}:/ros_ws \
  ros:lunar-ros-core \
    bash -c '\
      cd /ros_ws && \
      source devel/setup.bash && \
      catkin_make run_tests_roslaunch && \
      catkin_test_results'
