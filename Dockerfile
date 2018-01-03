FROM ubuntu:14.04.5

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# TODO: use local mirror to speed things up
# RUN sed -i 's|archive.ubuntu.com/ubuntu/|ftp.tudelft.nl/archive.ubuntu.com/|g' /etc/apt/sources.list

# add bootstrap utils/progs
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      python-pip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# add bootstrap ros utils
RUN pip install -U rosdep wstool rosinstall rospkg catkin_pkg

# setup workspace and import packages
WORKDIR /ros_ws
ADD pkgs.rosinstall /ros_ws/
RUN wstool init -j8 /ros_ws/src /ros_ws/pkgs.rosinstall

# install system deps
RUN apt-get update \
 && rosdep init \
 && rosdep update \
 && rosdep install --from-paths src -i --rosdistro=indigo -y --skip-keys="python-rosdep python-catkin-pkg python-rospkg" \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# build workspace
RUN /ros_ws/src/catkin/bin/catkin_make_isolated \
      --install \
      --install-space /opt/ros/indigo \
      -DCMAKE_BUILD_TYPE=Release

# remove temporaries
RUN rm -rf /ros_ws/build_isolated /ros_ws/devel_isolated

# setup container entrypoints
COPY ./ros_entrypoint.sh /
ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
