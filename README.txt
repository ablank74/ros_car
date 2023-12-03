This is an attempt to create a ROS Noetic based robot car.  The harware is as follows
Chassis: Traxxas TRX4
Radio: IKON 3 channel
Compute: Nvidia Jetson Nano
Servo Control: I2C pca9685 12 channel servo driver module https://www.amazon.com/gp/product/B07BRS249H/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1
Multiplexer: 4-Channel Multiplexor https://www.amazon.com/gp/product/B00V3XMLEG/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1
Power: LM2596 adjustable buck converter https://www.amazon.com/gp/product/B00LSEBYHU/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1
LiDAR: Slamtec PRLiDAR A1M8 https://www.amazon.com/gp/product/B07TJW5SXF/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1
Webcam: IFROO FHD 1080P Webcam https://www.amazon.com/gp/product/B08FDM4DHF/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1

Software Setup

buid.sh creates the ros_car Docker container
launch.sh will run build if needed, adds current user to Docker group, restarts Docker and launches the image with assumed location for the LiDAR and webcam.
entrypoint.sh starts roscore, as well starts the LiDAR topic and launches Jupyter Lab.  There is no password for Jupyter.
