%save C:\Users\test.txt data -ascii
%b=load('C:\Users\test.txt')

%Textread ����ʽ��ȡTXT�ı��ļ��е�����
%textread(filename,format,N,'headlines',M)  filename ���ļ���,format�Ƕ�ȡ��ʽ,��%d
%%f��,N�����ȡ������,headerlines����ӵ�M�п�ʼ��ȡ
%[name,types,x,y,answer]=textread('C:\Usres\test.txt','%s %s %f %d %d',2,...
%'headerlines',2)

%Fprint ����ʽ��txt�ļ�д������
%���ڻ���,�еĻ���Ϊ\n�еĻ���Ϊ\r\n
%eg: file=fopen('C:\Users\test.txt','w');
% fprintf(file,'%d %12.8f\r\n',1,3.14); 
% fprintf(file,'%.2f %.8f\r\n',5.0,-2.1);
% fclose(file)