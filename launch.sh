#!/bin/bash

# Check if the current user is in the Docker group
if [[ $(id -nG) =~ "docker" ]] ; then
    echo "$USER in Docker Group"
else
  # Add the current user to the Docker group
  echo "Adding $USER to the Docker group"
  sudo usermod -aG docker $USER
  echo "User added to the Docker group and restarting Docker"
  sudo systemctl restart docker
fi
# Check if the "ros_car" image exists
if docker images -q ros_car >/dev/null 2>&1 ; then
    echo "The 'ros_car' image exists, launching with lidar at /dev/ttyUSB0 and camera at /dev/video0"
else
    echo "The 'ros_car' image does not exist, creating it"
    $(pwd)/ros/build.sh
fi

docker run -it --rm --device=/dev/ttyUSB0:/dev/ttyUSB0 --device=/dev/video0:/dev/video0 -p 8888:8888 -p 5000:5000 -v $(pwd)/notebooks:/root/notebooks ros_car