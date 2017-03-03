#include <iostream>
#include <omp.h>
#include <Eigen/Core>
#include <Eigen/Dense>
#include <opencv2/core/eigen.hpp>  
#include <opencv2/opencv.hpp>

#include "dis_flow.h"
#include "cluster.h"
// #include "of/run_dense.h"
using namespace cv;
using namespace std;
using namespace Eigen;
bool ROI_flag=false;
bool saveFlag=false;
int  _time= 0 ; //selectObject的初始值为false,
bool _initdone = false;
float Rool_angle[2]={-1,-1.0};

#define UNKNOWN_FLOW_THRESH 1e9
vector<Scalar> colorwheel; //Scalar r,g,b  

//opencv coloe BGR system
void makecolorwheel(vector<Scalar> &colorwheel)  
{  //共55个方向
	int RY = 15;  
	int YG = 6;  
	int GC = 4;  
	int CB = 11;  
	int BM = 13;  
	int MR = 6;  
	
	int i;  
	
	for (i = 0; i < RY; i++) colorwheel.push_back(Scalar(255,       255*i/RY,     0));  
	for (i = 0; i < YG; i++) colorwheel.push_back(Scalar(255-255*i/YG, 255,       0));  
	for (i = 0; i < GC; i++) colorwheel.push_back(Scalar(0,         255,      255*i/GC));  
	for (i = 0; i < CB; i++) colorwheel.push_back(Scalar(0,         255-255*i/CB, 255));  
	for (i = 0; i < BM; i++) colorwheel.push_back(Scalar(255*i/BM,      0,        255));  
	for (i = 0; i < MR; i++) colorwheel.push_back(Scalar(255,       0,        255-255*i/MR));  
}  

void motionToColor(const Mat flow,Mat &color)  
{ 
//pre-process
   if (color.empty())  
        color.create(flow.rows, flow.cols, CV_8UC3);  
   	Mat flow_split[2];
  	split(flow, flow_split);
  	Mat flowx=flow_split[0];
  	Mat flowy=flow_split[1];
  	Mat flow_rad=flowx.mul(flowx)+flowy.mul(flowy);
    sqrt(flow_rad, flow_rad);
    threshold(flow_rad,flow_rad, 1000, 1000, 4);
    double maxrad,minrad;
    minMaxLoc(flow_rad,&minrad,&maxrad, 0, 0); 

//hist static
    int histSize[1];//number of hist
    float hranges[2];//pixels maximum value minimum value
    const float* ranges[1];
    int channels[1]; //only one channels 

    histSize[0]=40;
    hranges[0]=0.0;
    hranges[1]=40.0;
    ranges[0]=hranges;
    channels[0]=0;
    Mat hist,hist_thre;
    calcHist(&flow_rad, 1, channels, Mat(), hist,1, histSize, ranges);
 
     int thre_hist=flow_rad.rows*flow_rad.cols/10;
    threshold(hist,hist_thre, thre_hist, 10000, 4);
    threshold(hist_thre,hist_thre,100, 1, 0);
    Mat idx_thre;
    hist_thre.convertTo(hist_thre, CV_8UC1);
    findNonZero(hist_thre,idx_thre);
    vector<int> num_thre;
    for(int i=0;i<idx_thre.rows;i++)
    {
    	num_thre.push_back( idx_thre.at<int>(i,1)*hranges[1]/histSize[0]);
    }
 // plot
	#pragma omp parallel for 
        for (int i= 0; i < flow.rows; ++i)   
        {  
            for (int j = 0; j < flow.cols; ++j)   
            {  
            	bool flag=false;
                uchar *data = color.data + color.step[0] * i + color.step[1] * j; 
                float rad = flow_rad.at<float>(i,j);  
	            for (int k=0;k<num_thre.size();k++)
	            {

	            	if ((int)rad==(num_thre[k]+1))
	            	{
	            		flag=true;
	            		break;
	            	}
	            }
	            if (flag)
	            {
	      			rad=rad/maxrad;
	                float angle = atan2(-flowy.at<float>(i,j), -flowx.at<float>(i,j)) / CV_PI;  
	                float fk = (angle + 1.0) / 2.0 * (colorwheel.size()-1);  
	                int k0 = (int)fk;  
	                int k1 = (k0 + 1) % colorwheel.size();  
	                float f = fk - k0;  
	                //f = 0; // uncomment to see original color wheel  
	                 for (int b = 0; b < 3; b++)   
	                {  
	                    float col0 = colorwheel[k0][b] / 255.0;  
	                    float col1 = colorwheel[k1][b] / 255.0;  
	                    float col = (1 - f) * col0 + f * col1;  
	                    double thre=0.35;//I want to change this to 
	                    if (rad <= 1 && rad>thre)  
	                        col = 1 - rad * (1 - col); // increase saturation with radius  
	                    else  if (rad<=thre)
							col=0;                	
	                	else
	                        col *= .75; // out of range  
	                    data[2 - b] = (int)(255.0 * col);  
	                }  
	            }
                else
                {
                	data[0]=data[1]=data[2]=0;
                }	            	

            }  
        }  

}
bool isFlowCorrect(Point2f u)
{
    return !cvIsNaN(u.x) && !cvIsNaN(u.y) && fabs(u.x) < 1e9 && fabs(u.y) < 1e9;
}

 Vec3b computeColor(float fx, float fy)
{
    static bool first = true;

    // relative lengths of color transitions:
    // these are chosen based on perceptual similarity
    // (e.g. one can distinguish more shades between red and yellow
    //  than between yellow and green)
    const int RY = 15;
    const int YG = 6;
    const int GC = 4;
    const int CB = 11;
    const int BM = 13;
    const int MR = 6;
    const int NCOLS = RY + YG + GC + CB + BM + MR;
    static Vec3i colorWheel[NCOLS];

    if (first)
    {
        int k = 0;

        for (int i = 0; i < RY; ++i, ++k)
            colorWheel[k] = Vec3i(255, 255 * i / RY, 0);

        for (int i = 0; i < YG; ++i, ++k)
            colorWheel[k] = Vec3i(255 - 255 * i / YG, 255, 0);

        for (int i = 0; i < GC; ++i, ++k)
            colorWheel[k] = Vec3i(0, 255, 255 * i / GC);

        for (int i = 0; i < CB; ++i, ++k)
            colorWheel[k] = Vec3i(0, 255 - 255 * i / CB, 255);

        for (int i = 0; i < BM; ++i, ++k)
            colorWheel[k] = Vec3i(255 * i / BM, 0, 255);

        for (int i = 0; i < MR; ++i, ++k)
            colorWheel[k] = Vec3i(255, 0, 255 - 255 * i / MR);

        first = false;
    }

    const float rad = sqrt(fx * fx + fy * fy);
    const float a = atan2(-fy, -fx) / (float) CV_PI;

    const float fk = (a + 1.0f) / 2.0f * (NCOLS - 1);
    const int k0 = static_cast<int>(fk);
    const int k1 = (k0 + 1) % NCOLS;
    const float f = fk - k0;

    Vec3b pix;

    for (int b = 0; b < 3; b++)
    {
        const float col0 = colorWheel[k0][b] / 255.0f;
        const float col1 = colorWheel[k1][b] / 255.0f;

        float col = (1 - f) * col0 + f * col1;

        if (rad <= 1)
            col = 1 - rad * (1 - col); // increase saturation with radius
        else
            col *= .75; // out of range

        pix[2 - b] = static_cast<uchar>(255.0 * col);
    }

    return pix;
}

void drawOpticalFlow(const Mat_<float>& flowx, const Mat_<float>& flowy, Mat& dst, float maxmotion)
{
    dst.create(flowx.size(), CV_8UC3);
    dst.setTo(Scalar::all(0));

    // determine motion range:
    float maxrad = maxmotion;

    if (maxmotion <= 0)
    {
        maxrad = 1;
        for (int y = 0; y < flowx.rows; ++y)
        {
            for (int x = 0; x < flowx.cols; ++x)
            {
                Point2f u(flowx(y, x), flowy(y, x));

                if (!isFlowCorrect(u))
                    continue;

                maxrad = max(maxrad, sqrt(u.x * u.x + u.y * u.y));
            }
        }
    }

    for (int y = 0; y < flowx.rows; ++y)
    {
        for (int x = 0; x < flowx.cols; ++x)
        {
            Point2f u(flowx(y, x), flowy(y, x));

            if (isFlowCorrect(u))
                dst.at<Vec3b>(y, x) = computeColor(u.x / maxrad, u.y / maxrad);
        }
    }
}
Mat getHistImg(const MatND& hist)
{
    double maxVal=0;
    double minVal=0;

    //找到直方图中的最大值和最小值
    minMaxLoc(hist,&minVal,&maxVal,0,0);
    int histSize=hist.rows;
    Mat histImg(histSize,histSize,CV_8U,Scalar(255));
    // 设置最大峰值为图像高度的90%
    int hpt=static_cast<int>(0.9*histSize);

    for(int h=0;h<histSize;h++)
    {
        float binVal=hist.at<float>(h);
        int intensity=static_cast<int>(binVal*hpt/maxVal);
        line(histImg,Point(h,histSize),Point(h,histSize-intensity),Scalar::all(0));
    }

    return histImg;
}
void flow_cluster(const Mat flow,Mat &color)  
{
    Mat split_flow[2];
    split(flow,split_flow);
	Mat flowx,flowy,flowsum;
  	sqrt(split_flow[0].mul(split_flow[0])+split_flow[1].mul(split_flow[1]),flowsum);
 	threshold(flowsum, flowsum, 255, 255, 4);
 	Mat nflowsum;
 	flowsum.convertTo(nflowsum,CV_8UC1);
  	double minVal,maxVal;
 	minMaxLoc(nflowsum, &minVal, &maxVal,0,0);
 	cout<<minVal<<" "<<maxVal<<endl;
/*     const int channels[1]={0};
    int histSize[1]={5};
    float hranges[6]={0,50,80,150,230,255};
    const float* ranges[1]={hranges};

    MatND hist;
    calcHist(&nflowsum,1,channels,Mat(),hist,1,histSize,ranges,false);
    Mat histImage=getHistImg(hist);*/
	// imshow("nflowsum", nflowsum);
	// waitKey(1);
	color=nflowsum;
 

 
 }

