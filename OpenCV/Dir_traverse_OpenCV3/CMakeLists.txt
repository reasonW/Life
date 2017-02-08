
cmake_minimum_required(VERSION 2.8)
project( dir_tra )
find_package( OpenCV REQUIRED )
include_directories( ${OpenCV_INCLUDE_DIRS} )
add_executable( dir_tra src/dir_tra.cpp )
target_link_libraries( dir_tra ${OpenCV_LIBS} )