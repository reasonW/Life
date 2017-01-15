#视觉报告—分割篇
图像中的显著属性变化通常反映了这个属性的重要性和影响<br>
常见的情况有：深度不连续，表面方向不连续，物质属性变化，场景照明变化<br>
优秀的分割算法可以大幅度减少数据量

## OpenCV 
经典分割方法<br>

###基于边缘分割
实际场景中图像边缘往往是各种类型的边缘及模糊化后的结果组合，且实际信号噪声较多。<br>
噪声和边缘都属于高频噪声，难用频带取舍。

- 边界分割法
 &emsp; &emsp;**点+线+边缘检测**<br>
可以加一些图像增强或腐蚀膨胀等形态学处理，强化或弱化目标边界，去噪
![分割示意图](/home/charle/Pictures/seg/opencv_3.png)

 |一阶算子 |介绍| | |
 |-|-|-|-|
|Roberts|2*2四邻域差分寻找边缘|无平滑，噪声较敏感| ![分割示意图](/home/charle/Pictures/seg/opencv_bound_robert.png)|
|Sobel/Prewitt| 3*3邻域卷积梯度微分，处理垂直和水平边缘|处理灰度渐变低噪声，定位校准| ![分割示意图](/home/charle/Pictures/seg/opencv_bound_sobel.png)|
 |Log|先平滑，拉氏变换后求二阶积分再卷积| 消除尺度小于σ的图像强度变化，计算量小，易丢失细节|  ![分割示意图](/home/charle/Pictures/seg/opencv_bound_log.png)|
|Canny| 准高斯函数做平滑，带方向一阶微分算子定位导数最大值|检测弱边缘效果很好，运算较慢| ![分割示意图](/home/charle/Pictures/seg/opencv_bound_canny.png)|


 &emsp; &emsp;**检测完提取**<br>
 物体边界一般是线，不是单独的点。边界表示使图像表示更简介，方便高层次理解<br>
难点在于边界分叉缺损，不是闭合连通边界图，梯度大的点也不一定真是边缘点<br>
可以加一些开闭运算，形态学梯度，顶帽黑帽,颗粒分析，流域变换，骨架提取，击中击不中变换等形态学处理，强化或弱化目标边界，强化物体结构<br>
> 数学形态学是一门建立在严格数学理论基础上的学科。象方差，弦长分布，周长测量，颗粒统计等 统称为击中击不中变换<br>
数学形态学理论基础是击中击不中变换，开闭运算，布尔模型和纹理分析器

 |方法|介绍|
|-|-|
|简单连接|相邻点边缘强度差和边缘方向小于阈值时，可以连接。无则停止，多则取差最小的点|
|启发式搜索|从多种可能路径中选优，评价函数打分|
|曲线拟合|若边缘点很稀疏，可以用分段性或高阶样条曲线来拟合这些点，形成边界。拟合方法多为均方误差最小准则|
其他还有hough变换，图搜索，动态规划等

##阈值分割<br>
![分割示意图](/home/charle/Pictures/seg/opencv_threshold.png)

**阈值分割算法实际上就是设定阈值的矩阵二值化，所以这个输入的灰度矩阵可以变成以0:255为范围的任何其他矩阵<br>**
**比如速度矩阵，深度矩阵，明度矩阵等等以及其他具有统计特性的矩阵**<br>
利用图像中要提取目标和背景在某一特性上的差异，选取合适阈值进行分割。
> - 单阈值分割方法（全局）
> - 多阈值分割方法（局部）
> -  基于像素值/区域性质/坐标位置的阈值分割方法
> - 根据分割方法所具有的特征或准则，可分为直方图峰谷法/最大类空间方差法/最大熵法/模糊集法/特征空间聚类法/基于过渡区的阈值选取法等 
>> - 直方图阈值的双峰法
>> - 迭代法（最佳阀值分割迭代法 k-means）
>> - 大律法（otsu阈值分割算法）
>> - 类内方差最小方差法
>> - 最小错误概率分类法
>> - 基于熵的二值化方法
>> - 局部自适应

###基于区域分割
![分割示意图](/home/charle/Pictures/seg/opencv_2.png)

####区域生长法
 区域生长的一致性描述是区域生长法的基本准则，一般是灰度，也可以考虑颜色/纹理/形状等其他属性<br>
 基于阈值的方法是基于单个点的特点。基于区域的方法考虑到相邻点的一致性。

 需要确定：
 > - 种子像素，一般可以根据聚类中心作为种子中心，也可以设定一个阈值，在此阈值内的点为种子点

 > - 生长方法和每次生长后这个区域的一致性准则，如灰度差小于阈值，简单的生长方法，区域的所有8邻域点。

 若该点加入后，该区域满足一致性准则，则加入。<br>
 当两个区域满足一定准则时，合并两个区域。该准则可以考虑两个区域分别的均值和方差。<br>
 如果没有预先确定的种子点，可采用一般步骤：<br>
&emsp;1.用某种准则把图像分割成许多小区域<br>
 &emsp;2.定义合并相邻区域的准则，需要注意区域合并得到的结果受区域合并顺序影响<br>
 &emsp;3.按照合并准则合并所有相邻的区域，如果没有再能够合并的块后停止。

 不同的分割方法和合并准则适应不同情况。相邻区域特征值之间的差异是计算强度的一个尺度。<br>强边界保留，弱边界消除，相邻区域合并。计算是一个迭代，每一步重新计算区域成员隶属关系，并消除弱边界。无弱边界消除时合并结束。<br>计算开销较大，但综合利用的话对自然场景分割效果相对最好。<br>
 生长准则：
>> - 灰度差准则<br>
1.dd 扫描图像，找出无隶属的像素<br>
2.检查邻域像素，逐个比较，灰度差小于阈值即合并<br>（对种子点依赖较大，可以求所有邻接区域平均灰度差，合并差小的邻接区域/ <br>还可直接用像素所在区域平均灰度值代替此像素灰度值进行比较。）<br>
3.以新合并的像素为中心，重复步骤2，直至区域不能进一步扩张<br>
4.返回步骤一，重复，至找不到无隶属像素，结束生长。（可以自己设定终止准则）<br>
>> - 灰度分布统计准则<br>
以灰度分布相似性座位上生长准则来决定区域的合并，步骤如下：<br>
1.把图像分为互不重叠的小区域<br>
2.比较邻接区域的累积灰度直方图很据灰度分布相似性进行区域合并<br>
3.设定终止准则，重复步骤2将各区域依次合并直至满足终止准则<br>
``灰度分布相似性检测方法 | Kolmogorov-Smirnov {maxz(h1(z)-h2(z))}  | Smoothed-Difference{Σz|h1(z)-h2(z)|} ``
>> - 区域形状准则<br>
方法1：把图像分割成灰度固定的区域，设两相邻区域周长分别位p1p2，把两区域共同边界线两侧灰度差小于给定值的部分设为L，若`L/min(p1,p2)>T1`则合并两区域。<br>
方法2：把图像分割成灰度固定的区域，设两邻接区域共同边界长度位B，把两区域共同边界线两侧灰度差小于给定值部分的长度设为L，若`L/B>T2`则合并<br>


####区域分裂<br>
原始图像&emsp;&emsp;&emsp;&emsp;模糊滤波&emsp;&emsp;&emsp;&emsp;分裂合并&emsp;&emsp;&emsp;分裂扩张<br>
![分割示意图](/home/charle/Pictures/seg/opencv_region.png)
区域分裂与区域合并相反<br>
先假设整个图像是一个对象，不满足一致性准则，则分裂（一般是均分成4个子图像），重复，直至所有区域满足一致性准则。像正方形的四叉树分裂
#### 区域分裂+合并
从中间层开始处理，按照一致性准则该分裂分裂该合并合并。起点是四叉树的某一层节点。
- 边缘+区域 分割
通过边缘限制，避免区域过分割，通过区域分割补充漏检边缘。<br>
如先进行边缘检测与连接，在比较相邻区域的特征（灰度均值，方差等），若相近则合并。<br>
对原始图像分别进行边缘检测和区域增长，获得边缘图和区域分段图后，再按一定准则融合，得到最终分割结果。
> - 连通域标记
基于边缘的方法根据所得闭合边界，采用边界跟踪和内部填充的方法。<br>
基于区域的方法一般采用连通性分析方法，按照一定的顺序把连通的像素用相同的序号标注<br>
>>1.把所有像素点放到待处理点集合A中。<br>
>>2.如果A空则结束。否则从A中任意移出一点作为连通域a（用集合表示）的初始点
>>3.在A中寻找所有与a连通的点，并移到a中，若没有找到，重复2，寻找下一个连通域。
>>4.重复3，迭代寻找新的连通点。

|其他分割|如|
|-|-|
|运动分割| 差分（时空灰度梯度）/光流（运动场）|
|特殊工具||
|人工智能方法
###运动分割
####差分
时-空灰度和梯度信息
####光流
LK稀疏光流(靠特征点提升速度);稠密光流Farneback检测效果好,时间效率低
###特殊工具分割
####小波
####马尔科夫随机场
####遗传算法
###神经网络/Kmeans/主动轮廓模型(能量函数) 
###SaliencyCut <br>
![分割示意图](/home/charle/Pictures/seg/opencv_1.png)<br>
[Global Contrast Based Salient Region Detection](http://ieeexplore.ieee.org/document/6871397/?arnumber=6871397&tag=1)<br>
_南开程明明 [download](http://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=6871397)

参考 ：[图像分割](chrome-extension://gbkeegbaiigmenfmjfclcdgdpimamgkj/views/app.html)

##PCL
因为维度的增加，是的分割成为三维图像对比二维图像的最大优势。使得最优分割成为可能<br>
![分割示意图](/home/charle/Pictures/seg/pcl_1.png)

###Ransac算法
随机采样一致,找平面,找线,找圆柱等 可以处理噪声较多的情况<br>
![分割示意图](/home/charle/Pictures/seg/pcl_ransac.png)<br>

使用方法:
>
  //创建一个模型参数对象，用于记录结果<br>
  pcl::ModelCoefficients::Ptr coefficients (new pcl::ModelCoefficients);<br>
  //inliers表示误差能容忍的点 记录的是点云的序号<br>
  pcl::PointIndices::Ptr inliers (new pcl::PointIndices);<br>
  // 创建一个分割器<br>
  pcl::SACSegmentation<pcl::PointXYZ> seg;<br>
  // Optional<br>
  seg.setOptimizeCoefficients (true);<br>
  // Mandatory-设置目标几何形状<br>
  seg.setModelType (pcl::SACMODEL_PLANE);<br>
  //分割方法：随机采样法<br>
  seg.setMethodType (pcl::SAC_RANSAC);<br>
  //设置误差容忍范围<br>
  seg.setDistanceThreshold (0.01);<br>
  //输入点云<br>
  seg.setInputCloud (cloud);<br>
  //分割点云<br>
  seg.segment (*inliers, *coefficients);<br>
  ![分割示意图](/home/charle/Pictures/seg/pcl_ransac2.png)<br>
>

###邻近信息
- kdTree & OcTree<br>
搜索策略,建立相邻关系
  >  
 #include <pcl/point_cloud.h><br>
 #include <pcl/kdtree/kdtree_flann.h><br>
   //创建kdtree 结构<br>
  pcl::KdTreeFLANN<pcl::PointXYZ> kdtree;<br>
  //传入点云<br>
  kdtree.setInputCloud (cloud);<br>
  //设置输入点<br>
  pcl::PointXYZ searchPoint;<br>
   //k邻近搜索<br>
   int K = 10;<br><br>
   //设置两个容器，第一个放点的标号，第二个点到SearchPoint的距离<br>
   std::vector<int> pointIdxNKNSearch(K);<br>
   std::vector<float> pointNKNSquaredDistance(K);<br>
   //进行搜索，注意，此函数有返回值>0为找到，<0则没找到<br>
   kdtree.nearestKSearch (searchPoint, K, pointIdxNKNSearch, pointNKNSquaredDistance)<br>
   //    基于距离的搜索    //<br>
  //两个未知大小的容器，作用同上<br>
  std::vector<int> pointIdxRadiusSearch;<br>
  std::vector<float> pointRadiusSquaredDistance;<br>
  // 搜索半径<br>
  float radius = 3;<br>
  //搜索，效果同上<br>
  kdtree.radiusSearch (searchPoint, radius, pointIdxRadiusSearch, pointRadiusSquaredDistance)<br>
> 

-   欧氏距离<br>
分割,可以用半径做滤波,删除离群点
>
  //被分割出来的点云团（标号队列）<br>
  std::vector<pcl::PointIndices> cluster_indices;<br>
  //欧式分割器<br>
  pcl::EuclideanClusterExtraction<pcl::PointXYZ> ec;<br>
  ec.setClusterTolerance (0.02); // 2cm<br>
  ec.setMinClusterSize (100);<br>
  ec.setMaxClusterSize (25000);<br>
  //搜索策略树
  ec.setSearchMethod (tree);<br>
  ec.setInputCloud (cloud_filtered);<br>
  ec.extract (cluster_indices);<br>
  >
- 区域增长
可以自定义准则,如法线,曲率,颜色,距离等等<br>
  ![分割示意图](/home/charle/Pictures/seg/pcl_region.png) 
  ![分割示意图](/home/charle/Pictures/seg/pcl_region2.png)<br>
>
 //一个点云团队列，用于存放聚类结果<br>
  std::vector <pcl::PointIndices> clusters;<br>
  //区域生长分割器<br>
  pcl::RegionGrowing<pcl::PointXYZ, pcl::Normal> reg;<br>
    //输入分割目标<br>
  reg.setSearchMethod (tree);<br>
  reg.setNumberOfNeighbours (30);<br>
  reg.setInputCloud (cloud);<br>
  //reg.setIndices (indices);<br>
  reg.setInputNormals (normals);<br>
    //设置限制条件及先验知识<br>
  reg.setMinClusterSize (50);<br>
  reg.setMaxClusterSize (1000000);<br>
  reg.setSmoothnessThreshold (3.0 / 180.0 * M_PI);<br>
  reg.setCurvatureThreshold (1.0);<br>
  reg.extract (clusters);<br>
>

###minCut算法
图论
  ![分割示意图](/home/charle/Pictures/seg/pcl_mincut.png)<br>

###超体聚类
类似于超像素的概念
超体聚类八叉树划分
  ![分割示意图](/home/charle/Pictures/seg/pcl_super.png)<br>
  不同晶体间的邻接关系
  ![分割示意图](/home/charle/Pictures/seg/pcl_super2.png)<br>

###基于形态学
  ![分割示意图](/home/charle/Pictures/seg/pcl_xingtai.png)<br>

###基于凹凸性
根据超体聚类之后不同的晶体计算凹凸关系,进行分割<br>
  ![分割示意图](/home/charle/Pictures/seg/pcl_auto.png)<br>
  只允许区域跨越凸边增长<br>
  ![分割示意图](/home/charle/Pictures/seg/pcl_auto1.png)<br>
  完美效果...<br>
  ![分割示意图](/home/charle/Pictures/seg/pcl_auto2.png)<br>
