    # This CmakeLists include both OpenNI and OpenCV Libraries  
    cmake_minimum_required(VERSION 2.8)  
    project( view )  
    set( QT_DIR /usr/include/qt4)
   include_directories(./build)
      
    # OpenCV  
    find_package( OpenCV REQUIRED )  
    include_directories( ${OpenCV_INCLUDE_DIRS} )  
    MESSAGE(STATUS "The Opencv's include directory is:" ${OpenCV_INCLUDE_DIRS})  
      
    #OpenNI  
    FIND_PATH(OpenNI2_INCLUDE_DIRS OpenNI.h HINTS  $ENV{OPENNI2_INCLUDE} PATH_SUFFIXES openni2)  
    FIND_LIBRARY(OpenNI2_LIBRARY NAMES OpenNI2 HINTS  $ENV{OPENNI2_LIB} $ENV{OPENNI2_REDIST})  
    include_directories( ${OpenNI2_INCLUDE_DIRS} )  
      
      
    IF (OpenNI2_INCLUDE_DIRS AND OpenNI2_LIBRARY)  
       SET(OpenNI2_FOUND TRUE)  
    ENDIF (OpenNI2_INCLUDE_DIRS AND OpenNI2_LIBRARY)  
      
    IF (OpenNI2_FOUND)  
       # show which OpenNI2 was found only if not quiet  
       SET(OpenNI2_LIBRARIES ${OpenNI2_LIBRARY})  
       MESSAGE(STATUS "Found OpenNI2: ${OpenNI2_LIBRARIES}")  
    ELSE (OpenNI2_FOUND)  
       # fatal error if OpenNI2 is required but not found  
       IF (OpenNI2_FIND_REQUIRED)  
          MESSAGE(FATAL_ERROR "Could not find OpenNI2. Environment variables OPENNI2_INCLUDE (directory containing OpenNI.h) and OPENNI2_LIB (directory containing OpenNI2 library) could bet set.")  
       ENDIF (OpenNI2_FIND_REQUIRED)  
    ENDIF (OpenNI2_FOUND)  
      
    #set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")  
    #set (OPENNI_H /usr/include/openni2/OpenNI.h)  
    # ---------------------------------------------------------  
 
    #PCL  
    find_package(PCL 1.8 REQUIRED)  
    include_directories(${PCL_INCLUDE_DIRS})  
    link_directories(${PCL_LIBRARY_DIRS})  
    add_definitions(${PCL_DEFINITIONS})  
  
	find_package(OpenGL REQUIRED)
	find_package(GLUT REQUIRED)
	include_directories( ${OPENGL_INCLUDE_DIRS}  ${GLUT_INCLUDE_DIRS} )
  
    # QT  
	if(WITH_QT)
	  set(PCL_QT_VERSION 5 CACHE STRING "Which QT version to use")
	  if("${PCL_QT_VERSION}" STREQUAL "4")
	    find_package(Qt4)
	    if (QT4_FOUND)
	      include("${QT_USE_FILE}")
	    endif (QT4_FOUND)
	  elseif("${PCL_QT_VERSION}" STREQUAL "5")
	    include(cmake/pcl_find_qt5.cmake)
	  else()
	    message(SEND_ERROR "PCL_QT_VERSION must be 4 or 5")
	  endif()
	endif(WITH_QT)

	# VTK
	if(WITH_VTK AND NOT ANDROID)
  find_package(VTK)
  if(VTK_FOUND)
    if(NOT DEFINED VTK_RENDERING_BACKEND)
      # On old VTK versions this variable does not exist. In this case it is
      # safe to assume OpenGL backend
      set(VTK_RENDERING_BACKEND "OpenGL")
    endif()
    message(STATUS "VTK_MAJOR_VERSION ${VTK_MAJOR_VERSION}, rendering backend: ${VTK_RENDERING_BACKEND}")
    if (PCL_SHARED_LIBS OR
        (NOT (PCL_SHARED_LIBS) AND NOT (VTK_BUILD_SHARED_LIBS)))
      set(VTK_FOUND TRUE)
      find_package (QVTK)
      if (${VTK_MAJOR_VERSION} VERSION_LESS "6.0")
         message(STATUS "VTK found (include: ${VTK_INCLUDE_DIRS}, lib: ${VTK_LIBRARY_DIRS})")
         link_directories(${VTK_LIBRARY_DIRS})
      else(${VTK_MAJOR_VERSION} VERSION_LESS "6.0")
         include (${VTK_USE_FILE})
         message(STATUS "VTK found (include: ${VTK_INCLUDE_DIRS}, lib: ${VTK_LIBRARIES}")
      endif (${VTK_MAJOR_VERSION} VERSION_LESS "6.0")
      if (APPLE)
          option (VTK_USE_COCOA "Use Cocoa for VTK render windows" ON)
          MARK_AS_ADVANCED (VTK_USE_COCOA)
      endif (APPLE)
      if(${VTK_RENDERING_BACKEND} STREQUAL "OpenGL")
        set(VTK_RENDERING_BACKEND_OPENGL_VERSION "1")
      elseif(${VTK_RENDERING_BACKEND} STREQUAL "OpenGL2")
        set(VTK_RENDERING_BACKEND_OPENGL_VERSION "2")
      endif()
      set(HAVE_VTK ON)
    else ()
      set(VTK_FOUND OFF)
      set(HAVE_VTK OFF)
      message ("Warning: You are to build PCL in STATIC but VTK is SHARED!")
      message ("Warning: VTK disabled!")
    endif ()
  endif(VTK_FOUND)
else(WITH_VTK AND NOT ANDROID)
  set(VTK_FOUND OFF)
  set(HAVE_VTK OFF)
endif(WITH_VTK AND NOT ANDROID)


    # QT4 && VTK
    # OpenNI Organized Connected Component application demo
    QT5_WRAP_UI(pcl_orgseg_qt_ui src/pcl_orgseg_qt.ui)
    QT5_WRAP_CPP(pcl_orgseg_moc src/pcl_orgseg.h OPTIONS -DBOOST_TT_HAS_OPERATOR_HPP_INCLUDED -DBOOST_NO_TEMPLATE_PARTIAL_SPECIALIZATION)


    add_executable(pcl_orgseg  ${pcl_orgseg_qt_ui} ${pcl_orgseg_moc} src/pcl_orgseg.cpp)
    target_link_libraries(pcl_orgseg  ${catkin_LIBRARIES} ${OpenNI2_LIBRARIES}  ${PCL_LIBRARIES} ${OpenCV_LIBS} ${PCL_COMMON_LIBRARIES} ${PCL_IO_LIBRARIES} ${VTK_LIBRARIES} ${QT_LIBRARIES}  ${OPENGL_LIBRARIES} ${GLUT_LIBRARY} )  

