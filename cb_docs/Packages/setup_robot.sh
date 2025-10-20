#!/bin/bash
#install all packages without interruption
sudo apt update && sudo apt upgrade -y && sudo apt install -y --no-install-recommends \
  docker.io \
  python3-pip \
  net-tools \
  aptitude \
  ack \
  vim \
  xorg \
  openbox \
  make \
  gcc \
  can-utils \
  curl \
  tmux \
  docker \
  docker-compose \
  ros-noetic-desktop-full \
  python3-catkin-tools \
  python3-vcstool \
  ros-noetic-moveit \
  ros-noetic-move-base \
  ros-noetic-move-base-flex \
  ros-noetic-ros-canopen \
  ros-noetic-ira-laser-tools \
  ros-noetic-flexbe-behavior-engine \
  libmodbus-dev \
  ros-noetic-robot-upstart \
  ros-noetic-rosbridge-server \
  ros-noetic-sick-safetyscanners \
  ros-noetic-gmapping \
  ros-noetic-carrot-planner \
  ros-noetic-teb-local-planner \
  ros-noetic-ros-controllers \
  ros-noetic-grid-map-ros \
  gitk \
  python3-pip \
  ros-noetic-robot-localization \
  ros-noetic-imu-filter-madgwick \
  ros-noetic-rtabmap \
  ros-noetic-rtabmap-slam \
  ros-noetic-rtabmap-odom \
  ntpdate \
  ros-noetic-realsense2-camera \
  apt-transport-https \
  ros-noetic-grid-map-msgs \
  ros-noetic-pointcloud-to-laserscan \
  build-essential \
  python3-rosdep \
  python3-rosinstall \
  python3-vcstools \
  gcc-multilib \
  libmlpack-dev \
  mlpack-bin \
  libarmadillo-dev
  
  
# for pc version (gui) you also need npm and flexbe_app  
  
pip install --upgrade pip && pip install pydbus pygame==2.5.0

source innodisk.sh
