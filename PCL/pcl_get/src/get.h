#define MEASURE_FUNCTION_TIME
#include <pcl/common/time.h> //fps calculations
#include <pcl/common/angles.h>
#include <pcl/io/openni2_grabber.h>
#include <pcl/visualization/pcl_visualizer.h>
#include <pcl/visualization/boost.h>
#include <pcl/visualization/image_viewer.h>
#include <pcl/console/print.h>
#include <pcl/console/parse.h>
#include <pcl/console/time.h>
#include <boost/chrono.hpp>
#include "pcl/io/openni2/openni.h"

#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"

typedef boost::chrono::high_resolution_clock HRClock;

#define SHOW_FPS 1
#if SHOW_FPS
#define FPS_CALC(_WHAT_) \
  do \
{ \
  static unsigned count = 0;\
  static double last = pcl::getTime ();\
  double now = pcl::getTime (); \
  ++count; \
  if (now - last >= 1.0) \
{ \
  std::cout << "Average framerate ("<< _WHAT_ << "): " << double (count)/double (now - last) << " Hz" <<  std::endl; \
  count = 0; \
  last = now; \
} \
}while (false)
#else
#define FPS_CALC (_WHAT_) \
  do \
{ \
}while (false)
#endif



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
template <typename PointType>
class OpenNI2Viewer
{
public:
  typedef pcl::PointCloud<PointType> Cloud;
  typedef typename Cloud::ConstPtr CloudConstPtr;

  OpenNI2Viewer (pcl::io::OpenNI2Grabber& grabber)
    : cloud_viewer_ (new pcl::visualization::PCLVisualizer ("PCL OpenNI2 cloud"))
    //, image_viewer_ ()
    , grabber_ (grabber)
    , rgb_data_ (0), rgb_data_size_ (0)
  {
  }

  void imageProcess();
  void cloudProcess();
  cv::Mat outImage;
  void
  cloud_callback (const CloudConstPtr& cloud)
  {
    FPS_CALC ("cloud callback");
    boost::mutex::scoped_lock lock (cloud_mutex_);
    cloud_ = cloud;
  }

  void
  image_callback (const boost::shared_ptr<pcl::io::openni2::Image>& image)
  {
    FPS_CALC ("image callback");
    boost::mutex::scoped_lock lock (image_mutex_);
    image_ = image;

    if (image->getEncoding () != pcl::io::openni2::Image::RGB)
    {
      if (rgb_data_size_ < image->getWidth () * image->getHeight ())
      {
        if (rgb_data_)
          delete [] rgb_data_;
        rgb_data_size_ = image->getWidth () * image->getHeight ();
        rgb_data_ = new unsigned char [rgb_data_size_ * 3];
      }
      image_->fillRGB (image_->getWidth (), image_->getHeight (), rgb_data_);
    }
  }

  void
  keyboard_callback (const pcl::visualization::KeyboardEvent& event, void*)
  {
    if (event.getKeyCode ())
      cout << "the key \'" << event.getKeyCode () << "\' (" << event.getKeyCode () << ") was";
    else
      cout << "the special key \'" << event.getKeySym () << "\' was";
    if (event.keyDown ())
      cout << " pressed" << endl;
    else
      cout << " released" << endl;
  }

  void
  mouse_callback (const pcl::visualization::MouseEvent& mouse_event, void*)
  {
    if (mouse_event.getType () == pcl::visualization::MouseEvent::MouseButtonPress && mouse_event.getButton () == pcl::visualization::MouseEvent::LeftButton)
    {
      cout << "left button pressed @ " << mouse_event.getX () << " , " << mouse_event.getY () << endl;
    }
    if (mouse_event.getType () == pcl::visualization::MouseEvent::MouseButtonPress && mouse_event.getButton () == pcl::visualization::MouseEvent::RightButton)
    {
      cout << "right button pressed @ " << mouse_event.getX () << " , " << mouse_event.getY () << endl;
    }
  }

  /**
  * @brief starts the main loop
  */
  void
  run ()
  {
    cloud_viewer_->registerMouseCallback (&OpenNI2Viewer::mouse_callback, *this);
    cloud_viewer_->registerKeyboardCallback (&OpenNI2Viewer::keyboard_callback, *this);
    cloud_viewer_->setCameraFieldOfView (1.02259994f);  
    boost::function<void (const CloudConstPtr&) > cloud_cb = boost::bind (&OpenNI2Viewer::cloud_callback, this, _1);
    boost::signals2::connection cloud_connection = grabber_.registerCallback (cloud_cb);

    boost::signals2::connection image_connection;
    if (grabber_.providesCallback<void (const boost::shared_ptr<pcl::io::openni2::Image>&)>())
    {
      // image_viewer_.reset (new pcl::visualization::ImageViewer ("PCL OpenNI image"));
      // image_viewer_->registerMouseCallback (&OpenNI2Viewer::mouse_callback, *this);
      // image_viewer_->registerKeyboardCallback (&OpenNI2Viewer::keyboard_callback, *this);
      boost::function<void (const boost::shared_ptr<pcl::io::openni2::Image>&) > image_cb = boost::bind (&OpenNI2Viewer::image_callback, this, _1);
      image_connection = grabber_.registerCallback (image_cb);
    }

    bool image_init = false, cloud_init = false;

    grabber_.start ();

  //  while (!cloud_viewer_->wasStopped () && (image_viewer_ && !image_viewer_->wasStopped ()))
      while (!cloud_viewer_->wasStopped () )
      {
        boost::shared_ptr<pcl::io::openni2::Image> image;
        CloudConstPtr cloud;
        cloud_viewer_->spinOnce ();
        // See if we can get a cloud
        if (cloud_mutex_.try_lock ())
        {
          cloud_.swap (cloud);
          cloud_mutex_.unlock ();
        }
        if (cloud )
        {
          FPS_CALC("drawing cloud");

          if (!cloud_init)
          {
            cloud_viewer_->setPosition (0, 0);
            cloud_viewer_->setSize (cloud->width, cloud->height);
            cloud_init = !cloud_init;
          }

          if (!cloud_viewer_->updatePointCloud (cloud, "OpenNICloud"))
          {
            cloud_viewer_->addPointCloud (cloud, "OpenNICloud");
            cloud_viewer_->resetCameraViewpoint ("OpenNICloud");
            cloud_viewer_->setCameraPosition (
              0,0,0,      // Position
              0,0,1,      // Viewpoint
              0,-1,0);    // Up
          }            
        }
        cloudProcess();
        /*
        add PointCloud process 

        */
        // See if we can get an image
        if (image_mutex_.try_lock ())
        {
          image_.swap (image);
          image_mutex_.unlock ();
        }
        if (image)
        {
          // if (!image_init && cloud && cloud->width != 0)
          // {
          //   image_viewer_->setPosition (cloud->width, 0);
          //   image_viewer_->setSize (cloud->width, cloud->height);
          //   image_init = !image_init;
          // }

          // if (image->getEncoding () == pcl::io::openni2::Image::RGB)
          //   image_viewer_->addRGBImage ( (const unsigned char*)image->getData (), image->getWidth (), image->getHeight ());
          // else
          //   image_viewer_->addRGBImage (rgb_data_, image->getWidth (), image->getHeight ());
          outImage.create(image->getHeight (), image->getWidth(),CV_8UC3);
          image->fillRGB(outImage.cols,outImage.rows,outImage.data,outImage.step);
          cv::cvtColor(outImage, outImage, CV_RGB2BGR);
          //image_viewer_->spinOnce ();
          imageProcess();
          /*
          add OpenCV Process;
          */

        }
      } //while cloud_viewe is true     


    grabber_.stop ();

    cloud_connection.disconnect ();
    image_connection.disconnect ();
    if (rgb_data_)
      delete[] rgb_data_;
  }

  boost::shared_ptr<pcl::visualization::PCLVisualizer> cloud_viewer_;
  //boost::shared_ptr<pcl::visualization::ImageViewer> image_viewer_;

  pcl::io::OpenNI2Grabber& grabber_;
  boost::mutex cloud_mutex_;
  boost::mutex image_mutex_;

  CloudConstPtr cloud_;
  boost::shared_ptr<pcl::io::openni2::Image> image_;
  unsigned char* rgb_data_;
  unsigned rgb_data_size_;
};

/*// Create the PCLVisualizer object
boost::shared_ptr<pcl::visualization::PCLVisualizer> cld;
boost::shared_ptr<pcl::visualization::ImageViewer> img;*/

