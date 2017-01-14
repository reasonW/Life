# 机器人视觉报告--工具篇
视觉算法设计的对象就是矩阵，熟悉数据类是算法设计前提
##OpenCV数据类
-  Vec
> 一维向量
` Vec3b color; ` 	//用 color 变量 述一种 RGB 颜色<br>
` color[0]=255;  `	//B 分量<br>
` color[1]=0; ` 		//G分量<br>
` color[2]=0; `		//R分量<br>
- Point   .x .y
- size .width .height
- Point3 .x .y .z
- Rect .x .y .width .height
- RotatedRect .points .boundingRect
-  Scalar，vec的特殊情况Vec<_Tp,4>  double[val] RGBA值  
- Range Range(a,b)相当于Matlab中a:b,如`Mat img2 = img(Range(1:30), Range::all());`//取1-30行的数据
- Mat 	
> - 任意N维矩阵，自定义数据格式像素通道及行列  `Mat colorim(600, 800, CV_8UC3)` <br>
>- 通过这个函数访问任意像素值<br>
	` uchar *pixelPtr = cvMat.data + rowIndex * cvMat.step[0] + colIndex * cvMat.step[1] `<br>
> - 可选择矩阵特定区域，特定通道
>- 属性
>>A.total() //元素的个数
<br>A.elemSize() //元素的大小，如果是8UC3的话，返回3*sizeof(uchar)
<br>A.elemSize1() //如果是8UC3的话，返回sizeof(uchar)
<br>A.type() //元素的数据类型
<br>A.depth()//元素的位数
<br>A.channels()//矩阵的通道数
<br>A.step1() //矩阵的每一行元素的个数，A.step/A.elemSize1
<br>A.size() //矩阵的尺寸
<br>//注意以下是成员变量不是成员函数
<br>A.step //矩阵的一行的字节数
<br>A.rows //矩阵的行数，即高
<br>A.cols //矩阵的列数，即宽
> -  矩阵运算
>>向量的点乘`A.dot(B)`和x乘`A.cross(B)`
>> 加减乘除绝对值 add subtract multiply divide abs<br>
>>行列式值迹特征向量特征值转置求逆翻转 determinant trace eigen transpose  invert  flip<br> 
>>对数幂指数范数归一化 log exp pow norm normalize<br>
>>统计均值方差协方差马氏距离元素范围<br> sum countNonzero mean meanStddev  calcCovarMatrix  Mahalanobis max min  minMaxIdx minMaxLoc checkrange <br>
>>位逻辑运算等 compare 元素一一比较 bitwise_and /not/or/xor<br> 
>>通道拆分合并通道元素替换 split merge mixchannels LUT <br>
>>极坐标极角极径 carttopolar polartocart<br>
- SparseMat 稀疏矩阵 只储存非零元素，搜索时间平均位O(1),非零元素较少，矩阵维度较大时无论是进行存储还是运算都用得上

## PCL数据类
总共23个。。。<br>

- PointXY .x  .y
- PointXYZ .x .y .z `points[i].x /points[i].data[0]`
- PointXYZI .x .y .z .intensity(强度,表示单通道图像中的灰度强度的点结构。强度表示为浮点值，侧重程度)<br>

- InterestPoint .x .y .z .strength(表示关键点强度的测量值,侧重品质)，其他同上
- PointXYZRGBA 坐标和颜色
- PointXYZRGB 有些早期的函数只支持这个格式，不支持PointXYZRGBA

- Normal  normal[3]{.normal_x,normal_y,normal_z}, curvature <br>表示给定点所在样本曲面上的法线方向，及对应曲率测量值，通常用NormalEstimation获得
- PointNormal 存储point结构体及采样点法线曲率
- PointXYZRGBNormal参考上面
- PointXYZINormal参考上面

- PointWithRange 除了range包含从所获得的视点到采样点的距离测量值之外，其他与PoinxXYZI类似
- PointWithViewpoint 除了vp_x.vp_y,vp_z以三维点表示所获得的视点之外，其他与PoinxXYZI类似

- MomentInvariants .j1 .j2 .j3 <br>是一个包含采样曲面上面片的三个不变矩的point类型，描述面片上质量的分布情况,由MomentInvariantsEstimation获得
- PrincipalRadiiRSD  .r_min .r_max<br>
是一个包含曲面块上两个RSD半径的point类型，RSDEstimation获得
- Boundary .(uint8_t)boundary_point<br>
存储一个点是否位于曲面边界上的简单point类型，BoundaryEstimation获得
- PrincipalCurvatures .principal_curvature[3]{.principal_curvature_x/y/z},pc1,pc2<br>
PrincipalCurvatures包含给定点主曲率的简单point类型，PrincipalCurvaturesEstimation获得

- PFHSignature125/FPFHSignature33/VFHSignature308
包含给定点的局部特征：点特征直方图histogram[125]/快速点特征直方图histogram[33]<br>全局特征：视点特征直方图histogram[308]<br>相关函数PFHEstimation/FPFHEstimation/VFHEstimation
- Narf36  .x.y.z .roll .pitch .yaw .decriptor[36]<br>
包含给定点NARF(归一化对齐半径特征)的简单point NARFEstimation
- BorderDescription .x.y .traits<br>
包含给定点边界类型的简单point类型，BorderEstimation
- IntensityGrandient gradient[3]{. gradient_x/y/z}<br>
包含给定点强度的梯度point类型， IntensityGradientEstimation
- Histogram histogram[N];<br>
 用来存储一般用途的n维直方图。
- PointWithScale .x.y.z .scale<br>
 除了scale表示某点用于几何操作的尺度（例如，计算最近邻所用的球体半径，窗口尺寸等等），其它的和PointXYZI一样。
- PointSurfel .x.y.z normal[3],rgba,radius,confidence,curvature
存储XYZ坐标、曲面法线、RGB信息、半径、可信度和曲面曲率的复杂point类型。

##OpenNI API简介
形成标准的API,搭建视觉传感器与视觉感知中间件通信的桥梁

> 包含手部追踪框架，手势识别框架，自已自动对齐深度图数据到彩色图数据。
> 包含坐标数据和骨架姿势信息，支持特殊跟踪模式（只追踪手和头或上半身），与ＫinectSdk相比消耗的cpu少
> 支持红外

- openni::OpenNI  提供了一个静态的Api进入点，提供设备基础访问，视频流基础访问，设备事件驱动访问，错误信版本等信息
- openni::Device
>　提供传感器设备或ONI文件模拟设备连接系统的接口，在创建之前需要先对OpenNI类进行初始化<br>
    Device可以访问流Streams,流的打开必须基于已连接的传感器，有什么传感器开什么流 SENSOR_IR/COLOR/DEPTH<br>
   open(),close(),isValid(),getDeviceInfo<br>
   Registration,FramSync,General 配准帧同步通用功能

- openni::VideoStream 从设备里提取一个视频流，需要获取视频帧引用
> 创建和初始化视频流，基于轮询基于事件
> 视频帧率，分辨率像素格式，视野（弧度），像素最大最小值
> 配置视频模式，裁剪，镜像，通用属性

- openni::VideoFrameRef　从相关源数据里提取一个视频帧，从一个特定的流里面获取
> 访问帧，元数据，数据裁剪，时间戳，帧索引，视频模式，数据大小，有效性（初始化的时候调用会返回false）

- openni::Recorder 存储ＯpenNI视频流到文件
- openni::Listener 监听OpenNI 和Stream类产生的事件
- openni::PlaybackControl处理记录文件时查找，循环播放，改变播放速度等功能

- Support 传感器配置类，数据存储类 RGB888Pixel,存储彩色像素值 / Array简单数组类 /Coordinate Conversion 坐标转换（真实坐标和深度坐标）
- Middleware
> - NITE2
> -  3D Hand Tracking Library  python 无需标记，设备要求Windows/Ubuntu Nvidia CUDA support
> -  SigmaNIL Framework 手势重建精度高，手势识别，手势骨架跟踪，部分module需要boost/opencv/cuda/sample需要qt
> - TipTep Skeletonizer 根据手势的深度图提供手势的几何骨架  Windows  .NET 4.
> - 3D Face Identification  实时，可二次开发，支持GPU
>> 1.利用OpenCV的人脸检测在RGB图像中定位人脸；
>> 2.将人脸区域的深度数据转化为提前规范好的深度数据；
>> 3.将探测出的数据与数据库中的数据进行比对
> - Volumental  windows浏览器插件连接深度摄像机，云端重建3d模型
> - KScan3D Middleware windows 3d扫描重建
> - VIIm SDK2.0 增强版OpenNI/NITE windows
> -  GST API 标记用户动作，流畅
> - Motion Nexus Plugin 交互游戏开发
> - Starry Night Feature ExtractionDemonstration SDK 场景或对象扫描

