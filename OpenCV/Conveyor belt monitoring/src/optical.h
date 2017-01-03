// Farneback dense optical flow calculate for a conveyor belt monitoring 
// Author : reasonW  
// Date   : 2016-12-29  
// HomePage : http://github.com/reasonW  
// Email  :charlewander@gmail.com 
#include <iostream>
#include <opencv2/opencv.hpp>
#include <opencv2/highgui/highgui.hpp>  
#include <opencv2/imgproc/imgproc.hpp>  
#include <opencv2/features2d.hpp>
#include <opencv2/imgcodecs.hpp>
using namespace cv;
using namespace std;
bool ROI_flag=false;
bool saveFlag=false;
int  _time= 0 ; //selectObject的初始值为false,
int velocity=6;
bool _initdone = false;
float Rool_angle[2]={-1,-1.0};
Point origin;
Rect selection;
Mat frame;
#define UNKNOWN_FLOW_THRESH 1e9
//用鼠标选择目标图像区域
static vector<Scalar> colorwheel; //Scalar r,g,b
static void velocityseg( int, void* )
{
	//cout << "velocity=" << velocity << "; " << endl;
	//pyrMeanShiftFiltering( img, res, spatialRad, colorRad, maxPyrLevel );
	//floodFillPostprocess( res, Scalar::all(2) );
              	imshow("Image", frame);
}
void onMouse( int event, int x, int y, int, void* )
{  
	if (event == CV_EVENT_LBUTTONDOWN && !CV_EVENT_MOUSEMOVE)  
	{  
		if(event==CV_EVENT_LBUTTONDOWN) 
		{
			if(_time==0)
			{
				origin = Point(x,y);
				selection = Rect(x,y,0,0);
				cout<<"position1 "<<x<<" "<<y<<endl;
				_time++;
				ROI_flag=false;
			}
			else if (_time==1)
			{
				selection.x = MIN(x, origin.x);
				selection.y = MIN(y, origin.y);
				selection.width = std::abs(x - origin.x);
				selection.height = std::abs(y - origin.y);
				cout<<"selection area: "<<selection<<endl;
				_time++;
				ROI_flag=true;
			}
		}
	}  
}    
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
void make_contours_closed(vector<vector<Point> > contours) {
	for (int i = 0; i < contours.size(); i++) {
		vector<Point> cc;
		approxPolyDP(contours[i], cc, 0.1, true);
		contours[i] = cc;
	}
}
void motionToColor(const Mat &flowx, const Mat &flowy,Mat &color)  
{  
 	color.create(flowx.rows, flowx.cols, CV_8UC3);  
	color.setTo(Scalar(0,0,0));

	Mat Rad;
	Rad.create(flowx.size(), CV_8UC1);
	 Rad=abs(flowx)+abs(flowy);
	 //threshold(Rad, Rad, 2,1, CV_THRESH_TOZERO); 
 	 threshold(Rad, Rad,10,1, CV_THRESH_TOZERO_INV); 
 	 Rad=Rad*25;
	 double ss,sss;
	 minMaxIdx(Rad, &ss,&sss);
	// cout<<"max "<<sss<<endl;
 	//normalize(Rad, Rad, 0,255,NORM_MINMAX,-1,Mat());
 	Rad.convertTo(Rad, CV_8UC1);
 	threshold(Rad, Rad, velocity*25,1, CV_THRESH_TOZERO); 
 	int count_tmp=countNonZero(Rad);
 	//threshold(Rad, Rad,200,1, CV_THRESH_TOZERO_INV); 
 	Mat element=getStructuringElement(MORPH_RECT, Size(11,11));
 	dilate(Rad, Rad, element);
 	// GaussianBlur(Rad, Rad, Size(11,11), 1);

	vector<vector<Point> > contours;
	findContours(Rad,  contours, CV_RETR_TREE, CV_CHAIN_APPROX_NONE);
	make_contours_closed(contours);
	//threshold(Rad, color, 100,1,CV_THRESH_BINARY);
	//cout<<sum(color)<<endl;
	cvtColor(Rad, Rad, CV_GRAY2BGR);
	if (contours.size()!=0)
	{
 	cout<<"count  "<<count_tmp<<endl;
 
		for(vector<vector<Point> >::iterator iter=contours.begin(); iter!=contours.end(); )
		{
		 	RotatedRect box = minAreaRect(Mat(*iter));
		 	Rect rect=boundingRect(*iter);
  		     if(box.size.area()<3000||box.size.area()>20000   )
		     {
		                Rad(rect).setTo(0);	
		                iter = contours.erase(iter);
		     }
		      else
		      {
  			cout<<box.size.area()<<endl;
			Point2f vertex[4];
			box.points(vertex);
			cout<<vertex<<endl;
			for( int i = 0; i < 4; i++ )
			{				
			line(color, vertex[i], vertex[(i+1)%4], Scalar(0, 255, 0), 2, CV_AA);
			line(Rad, vertex[i], vertex[(i+1)%4], Scalar(0, 255, 0), 2, CV_AA);
			}
			iter ++ ;
		      	
		      }
		}
	}

  	imshow("jjj",Rad);
  	//color=Rad;

 }  
