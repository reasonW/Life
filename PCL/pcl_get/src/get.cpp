#include "get.h"

template <typename PointType>
void OpenNI2Viewer<PointType>::imageProcess()
{
	cv::Mat tmp=outImage;
	cv::imshow("tmp", tmp);
	cv::waitKey(1);
}
template <typename PointType>
void OpenNI2Viewer<PointType>::cloudProcess()
{

}

int
main (int argc, char** argv)
{
  std::string device_id ("");
  pcl::io::OpenNI2Grabber::Mode depth_mode = pcl::io::OpenNI2Grabber::OpenNI_Default_Mode;
  pcl::io::OpenNI2Grabber::Mode image_mode = pcl::io::OpenNI2Grabber::OpenNI_Default_Mode;
  boost::shared_ptr<pcl::io::openni2::OpenNI2DeviceManager> deviceManager = pcl::io::openni2::OpenNI2DeviceManager::getInstance ();
  if (deviceManager->getNumOfConnectedDevices () > 0)
  {
    boost::shared_ptr<pcl::io::openni2::OpenNI2Device> device = deviceManager->getAnyDevice ();
    cout << "Device ID not set, using default device: " << device->getStringID () << endl;
  }

  pcl::io::OpenNI2Grabber grabber (device_id, depth_mode, image_mode);

  OpenNI2Viewer<pcl::PointXYZRGBA> openni_viewer (grabber);
  openni_viewer.run ();

  return (0);
}
/* ]--- */
