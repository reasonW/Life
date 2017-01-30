%save C:\Users\test.txt data -ascii
%b=load('C:\Users\test.txt')

%Textread 按格式读取TXT文本文件中的内容
%textread(filename,format,N,'headlines',M)  filename 是文件名,format是读取格式,如%d
%%f等,N代表读取多少行,headerlines代表从第M行开始读取
%[name,types,x,y,answer]=textread('C:\Usres\test.txt','%s %s %f %d %d',2,...
%'headerlines',2)

%Fprint 按格式像txt文件写入内容
%关于换行,有的换行为\n有的换行为\r\n
%eg: file=fopen('C:\Users\test.txt','w');
% fprintf(file,'%d %12.8f\r\n',1,3.14); 
% fprintf(file,'%.2f %.8f\r\n',5.0,-2.1);
% fclose(file)