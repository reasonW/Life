#include "optical.h"
using namespace cv;
using namespace std;


int main(int argc, const char** argv )
{
   	VideoCapture cap;

   	if(argc<=1)
		cap.open(0);
 	else
 		cap.open(argv[1]);
    	if( !cap.isOpened() )
        		return -1;
        	VideoWriter writer;
	makecolorwheel(colorwheel);
    	Mat prevgray, gray, frame;
         	cvNamedWindow("Image",1); 
        	setMouseCallback( "Image", onMouse, 0 );
          	cap >> frame;
          	resize(frame, frame, Size(640,480));
         	imshow("Image", frame);
	while(1)
	{
	                if(ROI_flag)
	                {
	                         	cap >> frame;

	                         	if(frame.empty())
	                              		return -1;
        			resize(frame, frame, Size(640, 640*frame.rows/frame.cols), INTER_LINEAR);

	                           	if(!_initdone)
	                           	{
	                                	if(argc<=2)
	                                	{
	                                      		writer.open("../optical.avi",CV_FOURCC('D', 'I', 'V', 'X')  ,cap.get(CV_CAP_PROP_FPS), Size(640, 640*frame.rows/frame.cols),1);
	                                       		cout<<"argc<=2"<<endl;
	                                	}
	                              		else
	                              		{
	                                        		writer.open(argv[2], CV_FOURCC('D', 'I', 'V', 'X')  ,cap.get(CV_CAP_PROP_FPS), Size(640, 640*frame.rows/frame.cols),1);
	                              		}
	                              		_initdone=true;
	                           	}
	                        	double t = (double)cvGetTickCount();
	                        	cvtColor(frame(selection), gray, CV_BGR2GRAY);
	                        	if( prevgray.data )
	                        	{
	                        		Mat flow,flowx,flowy,motion2color;
		                          	calcOpticalFlowFarneback(prevgray, gray, flow, 0.5, 3, 15, 3, 5, 1.2, 0);  
		                          	Mat tmpmat[2];
		                          	split(flow, tmpmat);
		                          	flowx=tmpmat[0];
		                          	flowy=tmpmat[1];
		                          	motionToColor(flowx,flowy, motion2color);
		                          	Mat imageROI=frame(selection);
		                          	Mat mask;
		                          	cvtColor(motion2color, mask, CV_BGR2GRAY);
		                          	motion2color.copyTo(imageROI,mask);
		                          	std::stringstream ss;
		                          	ss<<Rool_angle[0];
		                          	string sss;
		                          	ss>>sss;
		                          	putText(frame, "Max speed angle :  "+sss, Point(20,415), 4,0.5 ,Scalar(0,255,0),1,8);	
		                          	std::stringstream ss1;
		                          	ss1<<Rool_angle[1];
		                          	string sss1;
		                          	ss1>>sss1;
		                          	putText(frame, "MS angle rate :  "+sss1+"%", Point(20,440), 4,0.5 ,Scalar(0,255,0),1,8);
		                          	imshow("Image", frame);
		                          	writer<<frame;
	                        	}
	                          	std::swap(prevgray, gray);
	                           	t = (double)cvGetTickCount() - t;
	                          	//cout << "cost time: " << t / ((double)cvGetTickFrequency()*1000.) <<"  ms/fps"<< endl;
	        	}
       	        	if(waitKey(5)>=0)
            			break;
 	}
    	writer.release();
    	return 0;
}