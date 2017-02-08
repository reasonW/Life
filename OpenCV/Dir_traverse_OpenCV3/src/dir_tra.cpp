#include <iostream>
#include <stdio.h>
#include <vector>
#include <iostream>
#include <sys/types.h>
#include <dirent.h>
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
using namespace cv;
using namespace std;

int main(int argc, char const *argv[])
{
	cout<<"waiting me loading previous faces"<<endl;
 	string inputPath=argv[1];
	string outputPath=argv[2];
	string imgExt=".jpg";
	DIR* pDir;
	struct dirent* ptr;
	if(!(pDir=opendir(inputPath.c_str())))
		return -1;
	while((ptr=readdir(pDir))!=0)
	{
		if(ptr->d_name[0]!='.')
		{
			cout<<ptr->d_name<<endl;
			string img_name(ptr->d_name);
			if (img_name.substr(img_name.size()-3)=="png")
			{
				string str_read=inputPath+"/"+img_name; 
				string str_write=outputPath+"/"+img_name; 
				cout<<str_read<<endl;
				Mat src=imread(str_read.c_str(),1);
				cout<<src.empty()<<endl;
				Mat des;
				des=src;
				imwrite(str_write.c_str(),des);
				cout<<img_name<<endl;
				
			}
		}
	}
 
 	  return 0;
}