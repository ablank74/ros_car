#!/bin/bash
set -e

# Source ROS environment
source /opt/ros/noetic/setup.bash
source /root/catkin_ws/devel/setup.bash


# Update rosdep
rosdep update

# Start roscore in the background
roscore &
# Wait for roscore to be ready
until rostopic list ; do sleep 1; done

# Start the rplidar node in the background
roslaunch rplidar_ros rplidar.launch &

# Start JupyterLab
exec jupyter lab --ip=0.0.0.0 --allow-root --no-browser --notebook-dir=/root/ --NotebookApp.token=''
