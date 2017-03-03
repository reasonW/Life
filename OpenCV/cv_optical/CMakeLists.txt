cmake_minimum_required(VERSION 2.8.3)
project(optical)
set(OpenCV_DIR  /usr/local/share/OpenCV)
set(EIGEN_INCLUDE_PATH /usr/include/eigen3)
FIND_PACKAGE( OpenCV REQUIRED )
include_directories(${Opencv_INCLUDE_DIRS})

find_package(OpenMP)
if (OPENMP_FOUND)
     set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}  ")
     set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}  -std=c++11 ${OpenMP_CXX_FLAGS} " )
endif()

include_directories(${EIGEN_INCLUDE_PATH})

add_executable(optical_o src/optical_o.cpp)
target_link_libraries(optical_o  ${OpenCV_LIBRARIES}   )