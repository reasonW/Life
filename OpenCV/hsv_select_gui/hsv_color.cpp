// Farneback dense optical flow calculate for a conveyor belt monitoring 
// Author : reasonW  
// Date   : 2016-12-29  
// HomePage : http://github.com/reasonW  
// Email  :charlewander@gmail.com 
#include <iostream>
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"


using namespace cv;
using namespace std;

int bSums(Mat src)
{

    int counter = 0;
    //迭代器访问像素点
    Mat_<uchar>::iterator it = src.begin<uchar>();
    Mat_<uchar>::iterator itend = src.end<uchar>();
    for (; it!=itend; ++it)
    {
        if((*it)>0) counter+=1;//二值化后，像素点是0或者255
    }
    return counter;
}
int main(int argc, char** argv)
{


namedWindow("Control", CV_WINDOW_AUTOSIZE); //创建窗口


int iLowH = 90;
int iHighH = 100;


int iLowS = 0;


int iHighS = 255;


int iLowV = 255;
int iHighV = 255;


//创建控制条
cvCreateTrackbar("LowH", "Control", &iLowH, 179); //Hue (0 - 179)
cvCreateTrackbar("HighH", "Control", &iHighH, 179);


cvCreateTrackbar("LowS", "Control", &iLowS, 255); //Saturation (0 - 255)
cvCreateTrackbar("HighS", "Control", &iHighS, 255);


cvCreateTrackbar("LowV", "Control", &iLowV, 255); //Value (0 - 255)
cvCreateTrackbar("HighV", "Control", &iHighV, 255);
  int a=0;
  int b=0;

while (true)
{
Mat imgOriginal=imread("10.jpg");
Mat imgOriginal_=imread("11.jpg");
//Mat M(7,7,CV_32FC2,Scalar(1,3));解释如下：创建一个M矩阵，7行7列，类型为CV_32F，C2表示有2个通道。
//Scalar(1,3)是对矩阵进行初始化赋值。第一个通道全为1，第2个通道全为3。
/*Mat tmp;
addWeighted(imgOriginal, 1, imgOriginal_, 1, 2, tmp);
imwrite("13.jpg", tmp);
*/
Mat imgHSV;
vector<Mat> hsvSplit;
cvtColor(imgOriginal, imgHSV, COLOR_BGR2HSV); //颜色空间转换 BGR to HSV


//因为我们读取的是彩色图，直方图均衡化需要在HSV空间做
split(imgHSV, hsvSplit); //分离通道到hsvSplit(h s v)
equalizeHist(hsvSplit[2], hsvSplit[2]);//直方图均衡化，增加对比度，使亮的更亮，暗的更暗
merge(hsvSplit, imgHSV);//通道合成，将多个通道合成到一个mat中
Mat imgThresholded;
inRange(imgHSV, Scalar(iLowH, iLowS, iLowV), Scalar(iHighH, iHighS, iHighV), imgThresholded);
//检测imgHSV图像的每一个像素是不是在Scalar(iLowH, iLowS, iLowV)和Scalar(iHighH, iHighS, iHighV)之间，
//如果是，这个像素就设置为255，并保存在imgThresholded图像中，否则为0
//Scalar结构体是赋初值的，如Scalar(iLowH, iLowS, iLowV)则表示有三通道，第一个通道为iLowH，第二个通道为iLowS，第三个通道为iLowV


//开操作 (去除一些噪点)
Mat element = getStructuringElement(MORPH_RECT, Size(5, 5));//获取常用的结构元素的形状：矩形（包括线形）、椭圆（包括圆形）及十字形。
//MORPH_RECT， MORPH_ELLIPSE， MORPH_CROSS
morphologyEx(imgThresholded, imgThresholded, MORPH_OPEN, element);
//morphologyEx的内部实现都是调用腐蚀erode与膨胀dilate函数。


//闭操作 (连接一些连通域)
morphologyEx(imgThresholded, imgThresholded, MORPH_CLOSE, element);

 if(a!= bSums(imgThresholded))
 {
a= bSums(imgThresholded);
   cout<<"a:"<<a<<endl;
 }
imshow("Thresholded Image", imgThresholded); //showthe thresholded image
imshow("Original", imgOriginal); //show the original image
Mat imgHSV_;
vector<Mat> hsvSplit_;
cvtColor(imgOriginal_, imgHSV_, COLOR_BGR2HSV); //颜色空间转换 BGR to HSV


//因为我们读取的是彩色图，直方图均衡化需要在HSV空间做
split(imgHSV_, hsvSplit_); //分离通道到hsvSplit_(h s v)
equalizeHist(hsvSplit_[2], hsvSplit_[2]);//直方图均衡化，增加对比度，使亮的更亮，暗的更暗
merge(hsvSplit_, imgHSV_);//通道合成，将多个通道合成到一个mat中
Mat imgThresholded_;
inRange(imgHSV_, Scalar(iLowH, iLowS, iLowV), Scalar(iHighH, iHighS, iHighV), imgThresholded_);
//检测imgHSV_图像的每一个像素是不是在Scalar(iLowH, iLowS, iLowV)和Scalar(iHighH, iHighS, iHighV)之间，
//如果是，这个像素就设置为255，并保存在imgThresholded_图像中，否则为0
//Scalar结构体是赋初值的，如Scalar(iLowH, iLowS, iLowV)则表示有三通道，第一个通道为iLowH，第二个通道为iLowS，第三个通道为iLowV


//开操作 (去除一些噪点)
Mat element_ = getStructuringElement(MORPH_RECT, Size(5, 5));//获取常用的结构元素的形状：矩形（包括线形）、椭圆（包括圆形）及十字形。
//MORPH_RECT， MORPH_ELLIPSE， MORPH_CROSS
morphologyEx(imgThresholded_, imgThresholded_, MORPH_OPEN, element_);
//morphologyEx的内部实现都是调用腐蚀erode与膨胀dilate函数。


//闭操作 (连接一些连通域)
morphologyEx(imgThresholded_, imgThresholded_, MORPH_CLOSE, element_);
 if(b!= bSums(imgThresholded_))
 {
b= bSums(imgThresholded_);
   cout<<"b:"<<b<<endl;
 }

imshow("Thresholded_ Image", imgThresholded_); //showthe thresholded image
imshow("Original_", imgOriginal_); //show the original image

char key = (char)waitKey(30);
if (key == 27)
break;
}


return 0;


}

