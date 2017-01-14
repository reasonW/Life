// grubcut for video   
// Author : reasonW  
// Date   : 2016-12-29  
// HomePage : http://github.com/reasonW  
// Email  :charlewander@gmail.com 
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include <iostream>
using namespace std;
using namespace cv;

const Scalar RED = Scalar(0,0,255);
const Scalar PINK = Scalar(230,130,255);
const Scalar BLUE = Scalar(255,0,0);
const Scalar LIGHTBLUE = Scalar(255,255,160);
const Scalar GREEN = Scalar(0,255,0);

const int BGD_KEY = CV_EVENT_FLAG_CTRLKEY;
const int FGD_KEY = CV_EVENT_FLAG_SHIFTKEY;
int iterCount;
static void getBinMask( const Mat& comMask, Mat& binMask )
{
      if( binMask.empty() || binMask.rows!=comMask.rows || binMask.cols!=comMask.cols )
        binMask.create( comMask.size(), CV_8UC1 );
    binMask = comMask & 1;
}

int main( int argc, char** argv )
{
   	VideoCapture cap;

   	if(argc<=1)
		cap.open(0);
 	else
 		cap.open(argv[1]);
    	if( !cap.isOpened() )
        		return -1;
        		const string winName = "image";
        	Mat image;

	cap>>image;
	if( image.empty() )
		return -1;
	resize(image, image, Size (640,630*image.rows/image.cols));
	Mat mask,res,binMask;
	Mat bgdModel, fgdModel;
	res.create(image.size(), CV_8UC3);
	res.setTo(Scalar(0,0,0));
	imshow(winName, res );
	binMask.setTo(0);

	mask.create( image.size(), CV_8UC1);
    	mask.setTo( GC_BGD );   //GC_BGD == 0
    	int n=0;
	Rect rect;
	rect.x=60;
	rect.y=40;
	rect.width=image.cols-100;
	rect.height=image.rows-80;
    	(mask(rect)).setTo( Scalar(GC_PR_FGD) );    //GC_PR_FGD == 3£¬ 
	grabCut( image, mask, rect, bgdModel, fgdModel, 1,GC_INIT_WITH_RECT );
	while(1)
	{
		cap>>image;
		resize(image, image, Size (640,630*image.rows/image.cols));
		//uncomment this line code the programe will be normal		
		//grabCut( image, mask, rect, bgdModel, fgdModel, 1,GC_INIT_WITH_RECT ); 
		grabCut( image, mask, rect, bgdModel, fgdModel, 2,GC_EVAL );
		getBinMask( mask, binMask );
		image.copyTo( res, binMask );
		//rectangle( res, Point( rect.x, rect.y ), Point(rect.x + rect.width, rect.y + rect.height ), GREEN, 2);
		imshow( winName, res );
		char kk=waitKey(1);
		if (kk == 'q')break;
		else if(kk=='n')
		{
			cout<<n++<< "  ";
		}

	}

	destroyWindow( winName );
	return 0;
}
