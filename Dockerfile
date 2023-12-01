# Use an official Ubuntu base image
FROM ubuntu:20.04

# Set the timezone
ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set the maintainer label
LABEL maintainer="adam@12thfloor.com"

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    lsb-release \
    gnupg2 \
    curl \
    git

# Add the ROS repository
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

# Add the ROS key
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

# Install ROS Noetic
RUN apt-get update && apt-get install -y ros-noetic-ros-base
RUN apt-get install -y ros-noetic-rviz

# Install rosdep
RUN apt-get install -y python3-rosdep

# Initialize rosdep
RUN rosdep init && rosdep update

# Clean up
RUN rm -rf /var/lib/apt/lists/*

# Source the ROS setup script
RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc

# Install Python 3 and JupyterLab (Python 3 is default in Ubuntu 20.04)
RUN apt-get update && apt-get install -y python3-pip
RUN pip3 install jupyterlab
RUN pip3 install matplotlib
RUN pip3 install adafruit-circuitpython-pca9685

# Set the workspace directory
WORKDIR /root/catkin_ws

# Copy your ROS project into the Docker container
COPY ./ros_car /root/catkin_ws/src/ros_car

RUN cd /root/catkin_ws/src && \
    git clone https://github.com/robopeak/rplidar_ros.git

# Build the catkin workspace
RUN /bin/bash -c '. /opt/ros/noetic/setup.bash; catkin_make'

# Source the catkin workspace
RUN echo "source /root/catkin_ws/devel/setup.bash" >> ~/.bashrc

COPY jupyter_notebook_config.py /root/.jupyter/

# Expose Jupyter port
EXPOSE 8888
EXPOSE 5000


# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]