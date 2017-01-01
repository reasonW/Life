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
/*        	setMouseCallback( "Image", onMouse, 0 );
*/          	cap >> frame;
        	resize(frame, frame, Size(640, 640*frame.rows/frame.cols), INTER_LINEAR);
          	selection.x=200;
        	selection.y=frame.rows*0.1;
        	selection.width=640-selection.x-640*0.1;
        	selection.height=frame.rows*0.9;
        	ROI_flag=true;
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
		                          	calcOpticalFlowFarneback(prevgray, gray, flow, 0.5, 3, 20, 3, 7, 1.5, 1);  
		                          	Mat tmpmat[2];
		                          	split(flow, tmpmat);
		                          	flowx=tmpmat[0];
		                          	flowy=tmpmat[1];
		                          	motionToColor(flowx,flowy, motion2color);
		                          	Mat imageROI=frame(selection);
		                          	Mat mask;
		                          	cvtColor(motion2color, mask, CV_BGR2GRAY);
		                          	motion2color.copyTo(imageROI,mask);

		                          	t = ((double)cvGetTickCount() - t)/((double)cvGetTickFrequency()*1000.) ;
	                          		cout << "cost time: " << t <<"  ms/fps"<< endl;
		                          	std::stringstream ss;
		                          	ss<< t;
		                          	string sss;
		                          	ss>>sss;
		                          	putText(frame, sss+"  fps", Point(20,50), 4,0.5 ,Scalar(0,255,0),1,8);
		                          	if (saveFlag)
		                          	{
		                          		imwrite("outlier.png",frame);
		                          		saveFlag=false;
		                          	}
		                          	imshow("Image", frame);
		                          	writer<<frame;
	                        	}
	                          	std::swap(prevgray, gray);

	        	}
       	        	if(waitKey(5)>=0)
            			break;
 	}
    	writer.release();
    	return 0;
}
