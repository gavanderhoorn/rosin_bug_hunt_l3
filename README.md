# Overview

This is a test 'time machine' that builds `tf2_ros` (and all dependencies) at approximately the versions as they were when https://github.com/ros/geometry2/pull/167 was merged.

This used `rosdistro@b573cfa` (around 2016-04-02) for `tf2_ros` and all its dependencies.


## Build

To build the image:

```shell
$ ./build.sh
```

If successful, ROS pkgs will have been installed under `/opt/ros/indigo` (in the image).


## TODO

 - what should be the `CMAKE_BUILD_TYPE`?
 - should we keep `devel_isolated` and `build_isolated`? Speeds up rebuilds if needed.
 - should we use `--install` and where should it be installed?
 - use OSRF repo or pip for bootstrap deps (current version uses `pip`)?
