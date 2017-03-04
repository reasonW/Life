#ifndef FILTER
#define FILTER
#include <iostream>
#include <vector>
#include <pcl/point_types.h>
#include <pcl/io/pcd_io.h>
#include <pcl/search/search.h>
#include <pcl/search/kdtree.h>
#include <pcl/visualization/cloud_viewer.h>
#include <pcl/filters/voxel_grid.h>
#include <pcl/filters/passthrough.h>
#include <pcl/filters/extract_indices.h>
#include <pcl/features/normal_3d.h>
#include <pcl/filters/approximate_voxel_grid.h>
#include <pcl/features/integral_image_normal.h>
#include <pcl/segmentation/organized_multi_plane_segmentation.h>
#include <pcl/segmentation/planar_polygon_fusion.h>
#include <pcl/common/transforms.h>
#include <pcl/segmentation/plane_coefficient_comparator.h>
#include <pcl/segmentation/euclidean_plane_coefficient_comparator.h>
#include <pcl/segmentation/rgb_plane_coefficient_comparator.h>
#include <pcl/segmentation/edge_aware_plane_comparator.h>
#include <pcl/segmentation/euclidean_cluster_comparator.h>
#include <pcl/segmentation/organized_connected_component_segmentation.h>
#include <pcl/common/angles.h>
#include <opencv2/photo/photo.hpp>  
#include <opencv2/highgui/highgui.hpp>
typedef pcl::PointXYZRGBA PointT;

class Filter_Save 
{
public:
Filter_Save ();
~Filter_Save ();
    struct Box2DPoint
    {
    float x_left_down;
    float y_left_down;
    float x_right_up;
    float y_right_up;
    };
    pcl::PointCloud<PointT>::Ptr  RemovePlane (const pcl::PointCloud<PointT>::Ptr input_cloud);
    cv::Rect vertex4(const pcl::PointCloud<PointT>::Ptr cloud_cluster);
};

#endif // FILTER_H_INCLUDED
