#include "Filter.h"

using namespace cv;  
using namespace pcl; 
#define FOCAL 525.0
int maxPointnum=25000;

Filter_Save ::Filter_Save ()
{

}
Filter_Save ::~Filter_Save ()
{

}
pcl::PointCloud<PointT>::Ptr Filter_Save ::RemovePlane (const pcl::PointCloud<PointT>::Ptr input_cloud)
{
  pcl::PointCloud <PointT>::Ptr cloud (new pcl::PointCloud <PointT>);
  copyPointCloud(*input_cloud,*cloud);

  std::cout<<"width "<<cloud->width<<" height "<<cloud->height<<std::endl;
  std::cout<<cloud->points.size()<<std::endl;
  pcl::PointIndices::Ptr inliers (new pcl::PointIndices);
  pcl::ModelCoefficients::Ptr coefficients (new pcl::ModelCoefficients);
  bool use_planar_refinement_ = true;
  bool use_clustering_ = true;
  // Estimate Normals
  pcl::search::KdTree<PointT>::Ptr tree (new pcl::search::KdTree<PointT>);
  pcl::PointCloud<pcl::Normal>::Ptr normal_cloud (new pcl::PointCloud<pcl::Normal>);
  pcl::IntegralImageNormalEstimation<PointT, pcl::Normal> ne; 
  ne.setNormalEstimationMethod (ne.COVARIANCE_MATRIX);
  ne.setMaxDepthChangeFactor (0.02f);
  ne.setNormalSmoothingSize (20.0f);
  ne.setInputCloud (cloud); 
  ne.setSearchMethod (tree); 
  ne.compute (*normal_cloud);

  // Segment Planes
  std::vector<pcl::PlanarRegion<PointT>, Eigen::aligned_allocator<pcl::PlanarRegion<PointT> > > regions;
  std::vector<pcl::ModelCoefficients> model_coefficients;
  std::vector<pcl::PointIndices> inlier_indices;  
  pcl::PointCloud<pcl::Label>::Ptr labels (new pcl::PointCloud<pcl::Label>);
  std::vector<pcl::PointIndices> label_indices;
  std::vector<pcl::PointIndices> boundary_indices;
  pcl::OrganizedMultiPlaneSegmentation<PointT, pcl::Normal, pcl::Label> mps;
  mps.setMinInliers (10000);
  mps.setAngularThreshold (pcl::deg2rad (3.0)); //3 degrees
  mps.setDistanceThreshold (0.02); //2cm
  mps.setInputNormals (normal_cloud);
  mps.setInputCloud (cloud);
      if (use_planar_refinement_)
  {
    mps.segmentAndRefine (regions, model_coefficients, inlier_indices, labels, label_indices, boundary_indices);
  }
  else
  {
    mps.segment (regions);//, model_coefficients, inlier_indices, labels, label_indices, boundary_indices);
  }
//cluster
  pcl::PointCloud<PointT>::Ptr clusters (new pcl::PointCloud <PointT>) ;
cout<<"regions.size ()"<<regions.size ()<<endl;
  if (use_clustering_ && regions.size () > 0)
  {
//label
    std::vector<bool> plane_labels;
    plane_labels.resize (label_indices.size (), false);
    for (size_t i = 0; i < label_indices.size (); i++)
    {
      if (label_indices[i].indices.size () > 10000)
      {
        plane_labels[i] = true;
      }
    }  
    pcl::EuclideanClusterComparator<PointT, pcl::Normal, pcl::Label>::Ptr euclidean_cluster_comparator_;
  euclidean_cluster_comparator_ = pcl::EuclideanClusterComparator<PointT, pcl::Normal, pcl::Label>::Ptr (new pcl::EuclideanClusterComparator<PointT, pcl::Normal, pcl::Label> ());

    euclidean_cluster_comparator_->setInputCloud (cloud);
    euclidean_cluster_comparator_->setLabels (labels);
    euclidean_cluster_comparator_->setExcludeLabels (plane_labels);
    euclidean_cluster_comparator_->setDistanceThreshold (0.01f, false);
//label
    pcl::PointCloud<pcl::Label> euclidean_labels;
    std::vector<pcl::PointIndices> euclidean_label_indices;
    pcl::OrganizedConnectedComponentSegmentation<PointT,pcl::Label> euclidean_segmentation (euclidean_cluster_comparator_);
    euclidean_segmentation.setInputCloud (cloud);
    euclidean_segmentation.segment (euclidean_labels, euclidean_label_indices);
cout<<"*************************************"<<endl;
    for (size_t i = 0; i < euclidean_label_indices.size (); i++)
    {
      if (euclidean_label_indices[i].indices.size () > 1000)
      {
  	pcl::PointCloud<PointT>::Ptr cluster (new pcl::PointCloud <PointT>) ;
        pcl::copyPointCloud (*cloud,euclidean_label_indices[i].indices,*cluster);
        *clusters=( *clusters)+(*cluster);
      }    
    }
cout<<"-----------------------------------"<<endl;
  }      
  else
  {


  }    
   return clusters;
}
cv::Rect  Filter_Save::vertex4(const pcl::PointCloud<PointT>::Ptr cloud_cluster)
{
	float x_min=1000000,y_min=1000000,z_min=1000000;
	float x_max=-1000000,y_max=-1000000,z_max=-1000000;//毫米
	float zm1,zm2,zm3,zm4;
	for(int i=0;i<cloud_cluster->size();i++)
		{
		    if(cloud_cluster->points[i].x<x_min)
		        {x_min=cloud_cluster->points[i].x;zm1=cloud_cluster->points[i].z;}
		    if(cloud_cluster->points[i].y<y_min)
		        {y_min=cloud_cluster->points[i].y;zm2=cloud_cluster->points[i].z;}
		    if(cloud_cluster->points[i].x>x_max)
		       { x_max=cloud_cluster->points[i].x;zm3=cloud_cluster->points[i].z;}
		    if(cloud_cluster->points[i].y>y_max)
		        {y_max=cloud_cluster->points[i].y;zm4=cloud_cluster->points[i].z;}
		}
	cv::Rect vertex;
	vertex.x= x_min*FOCAL/zm1+320;//这四行我还不知道是什么意思，到时候要问一下学姐
	vertex.y= y_min*FOCAL/zm2+240;
	vertex.width=(x_max/zm3-x_min/zm1)*FOCAL ;
	vertex.height=(y_max/zm4-y_min/zm2)*FOCAL;//最后会把聚类得到的对象全部给一个框
	return vertex;
}

