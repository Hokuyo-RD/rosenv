# ROS Noetic enviroment

ARG BASE_IMAGE=takahashi13/ros1_noetic:bridge
FROM $BASE_IMAGE

ENV ROS_DISTRO=noetic
ENV DEBIAN_FRONTEND=noninteractive

### ROS1 Install ###
RUN touch /etc/apt/apt.conf.d/99fixbadproxy && \
    echo "Acquire::http::Pipeline-Depth 0; Acquire::http::No-Cache true; Acquire::BrokenProxy true;" >> /etc/apt/apt.conf.d/99fixbadproxy && \
    apt update && \
    apt install -y git tmux vim liburdfdom-tools lsb-release curl wget gnupg2 bash-completion nautilus software-properties-common gnome-terminal dbus terminator&& \
    echo "source /etc/bash_completion" >> /root/.bashrc

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' && \
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654


RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    python3-rosdep \
    python3-rosinstall \
    python3-vcstools \
    ros-$ROS_DISTRO-desktop-full \
    ros-$ROS_DISTRO-rosserial ros-$ROS_DISTRO-rosserial-arduino \
    python3-rosinstall-generator python3-wstool build-essential python3-catkin-tools \
    && rm -rf /var/lib/apt/lists/*

RUN rosdep init && \
    rosdep update --rosdistro $ROS_DISTRO

RUN mkdir -p /home/catkin_ws/src && \
    cd /home/catkin_ws && \
    ls src && \
    /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash; catkin build" && \
    echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /root/.bashrc && \
    echo "source /home/catkin_ws/devel/setup.bash" >> /root/.bashrc && \
    echo "export __NV_PRIME_RENDER_OFFLOAD=1" >> /root/.bashrc && \
    echo "export __GLX_VENDOR_LIBRARY_NAME=nvidia" >> /root/.bashrc && \
    echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc && \
    echo "source /home/catkin_ws/devel/setup.bash" >> /root/.bashrc && \
    echo "export ROS_WORKSPACE=/home/catkin_ws" >> /root/.bashrc && \
    apt update && \
    apt install -y python3-vcstool && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    echo "succesfully"

RUN cat >> /root/.bashrc <<EOF
# ROS1 env
function rs1(){
#  PYTHONPATH=/opt/ros/noetic/lib/python3/dist-packages
    export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
    export ROS_DOMAIN_ID=0
    source /opt/ros/noetic/setup.bash
    source /home/catkin_ws/devel/setup.bash
}

# ROS2 env
function rs2(){
#  export PYTHONPATH=/opt/ros/foxy/lib/python3.8/site-packages
    export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
    export ROS_DOMAIN_ID=0
    source /opt/ros/foxy/setup.bash
    source /home/colcon_ws/install/local_setup.bash
}

function brg(){
    export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
    export ROS_DOMAIN_ID=0
    source /opt/ros/noetic/setup.bash
    source /opt/ros/foxy/setup.bash
    source /home/ros1_bridge_ws/install/local_setup.bash
}
EOF
    
WORKDIR /home/catkin_ws