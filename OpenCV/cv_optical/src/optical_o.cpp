#include "optical_o.h"
using namespace cv;
using namespace std;

void help()
{
	cout<< "argv[1] input_video_name\n \
argv[2] save_video_name\n \
argv[3] save_record_path\n"<<endl;
}
int main(int argc, const char** argv )
{
   	VideoCapture cap;
	  VideoWriter writer;

   	string input_video_name("../input/input_optical");
   	string save_video_name("../output/output_optical");
   	string save_record_path("../output/");
   	switch(argc)
   	{
   		case 0:	break;
   		case 1:	break;
   		case 2: input_video_name=argv[1];break;
   		case 3: input_video_name=argv[1];save_video_name=argv[2];break;
   		default: input_video_name=argv[1];save_video_name=argv[2];save_record_path=argv[3];break;
   	}
   	cout<<"input_video_name: " <<input_video_name.c_str()<<endl;
   	cout<<"save_video_name : " <<save_video_name.c_str()<<endl;
   	cout<<"save_record_path: " <<save_record_path.c_str()<<endl;
   	if(argc<2)
   		cap.open(0);
   	else
   	   	cap.open(input_video_name);
    if( !cap.isOpened() )
		return -1;
    if (colorwheel.empty())  
        makecolorwheel(colorwheel);  
	//makecolorwheel(colorwheel);
	Mat prevgray, gray, frame;
 //	cvNamedWindow("Image",1); 
 	cap >> frame;
 	cout<<"frame size : "<<frame.size()<<endl;
	resize(frame, frame, Size(320, 320*frame.rows/frame.cols), INTER_LINEAR);

	while(1)
	{

     	cap >> frame;
     	if(frame.empty())
      		return -1;
    resize(frame, frame, Size(320, 320*frame.rows/frame.cols), INTER_LINEAR);
		cvtColor(frame, gray, CV_BGR2GRAY);

     	if(!_initdone)
     	{
        	if(argc<=2)
        	{
    			ostringstream name_save;
     			time_t now;
    			time(&now);
    			name_save<<save_video_name.c_str() <<ctime(&now)<<".avi";
          		writer.open(name_save.str() ,CV_FOURCC('D', 'I', 'V', 'X')  ,cap.get(CV_CAP_PROP_FPS), Size(320, 640*frame.rows/frame.cols),1);
           		cout<<"save as :"<<name_save.str()<<endl;
        	}
      		else
      		{
        		writer.open(argv[2], CV_FOURCC('D', 'I', 'V', 'X')  ,cap.get(CV_CAP_PROP_FPS), Size(640, 640*frame.rows/frame.cols),1);
           		cout<<"save as :"<<argv[2]<<endl;
      		}
      		_initdone=true;
     	}

		if( prevgray.data )
		{
			double t = (double)cvGetTickCount();
			Mat flow,flowx,flowy,motion2color;
			// run_dense (prevgray,gray,flow);
			//calcOpticalFlowFarneback(prevgray, gray, flow, 0.5, 3, 20, 3, 7, 1.5, 1);  
			cv::optflow::DISOpticalFlowImpl dis;
			dis.calc(prevgray,gray, flow);
			double t1 = (double)cvGetTickCount();
			cout<<"optical_time:"<<(t1- t)/((double)cvGetTickFrequency()*1000.)<<endl;

			motionToColor(flow, motion2color);			           	
      double t2 = (double)cvGetTickCount();
      cout<<"motiontocolor_time:"<<(t2- t1)/((double)cvGetTickFrequency()*1000.)<<endl;
			//flow_cluster(flow,motion2color);
      double t3 = (double)cvGetTickCount();
      cout<<"hist_ime:"<<(t3-t2)/((double)cvGetTickFrequency()*1000.)<<endl;

			t= ((double)cvGetTickCount() - t)/((double)cvGetTickFrequency()*1000.) ;
			ostringstream record_cost;
			record_cost<<t<<" fps";
      cout<<"whole_time:"<<t <<endl;
      Mat mcluster_motion=cluster_motion(motion2color);
      imshow("cluster", mcluster_motion);

      putText(motion2color,record_cost.str(), Point(20,50), 4,0.5 ,Scalar(0,255,0),1,8);
      imshow("motion", motion2color);
      writer<<motion2color;
      char key=waitKey(1);
			switch (key)
			{
				case 'q':return 0;				
			}
		}
		cv::swap(prevgray, gray);
 	}
	writer.release();
	return 0;
}