%% ��������޳���,����ʱ��ĵ���������
n=400; %ģ��˿���
dt=exprnd(0.1,1,n); %����ʱ����
% events(2,:) = exprnd(ser_mean,1,arr_num);

st_1=exprnd(1/6,1,n); %����̨����ʱ��
st_2=exprnd(1/6,1,n); %����̨����ʱ��
%st=exprnd(2.5,1,n); %����̨����ʱ��
a=zeros(1,n); %ÿ���˵���ʱ��
a_1=zeros(1,n); %1��ÿ���˵���ʱ��
a_2=zeros(1,n);%2��ÿ���˵���ʱ��
b_1 =zeros(1,n); %1��ÿ���˿�ʼ���ܷ���ʱ��
b_2=zeros(1,n);%2��ÿ���˿�ʼ���ܷ���ʱ��
c_1=zeros(1,n);%1��ÿ�����뿪ʱ��
c_2=zeros(1,n);%2��ÿ�����뿪ʱ��
member_1 = [];
member_2 = [];

a(1)=0;
for i=2:n
  a(i)=a(i-1)+dt(i-1);%��i���˵���ʱ��
end  

a_1(1)=0;
b_1(1)=0;%��1���˿�ʼ����ʱ��Ϊ����ʱ��
c_1(1)=b_1(1)+st_1(1); %��1�����뿪ʱ��Ϊ����ʱ��
member_1 = [1];

for i=2:n
 len_1 = sum(c_1(member_1) > a(i));
 len_2 = sum(c_2(member_2) > a(i));
 if len_1<=len_2
     member_1=[member_1 length(member_1)+1 ];
     a_1(length(member_1))=a(i);
     if (a_1(length(member_1)) <= c_1(length(member_1)))
         b_1(length(member_1))=c_1(length(member_1)-1);%�����i���˵���ʱ���ǰһ�����뿪ʱ����,���俪ʼ����ʱ��Ϊǰһ���뿪ʱ��
     else
         b_1(length(member_1))=a_1(length(member_1)); %�����i���˵���ʱ���ǰһ�����뿪ʱ����,���俪ʼ����ʱ��Ϊ����ʱ��.
     end 
     c_1(length(member_1))=b_1(length(member_1))+st_1(length(member_1));  %��i�����뿪ʱ��Ϊ�俪ʼ����ʱ��+���ܷ���ʱ�� 
 else 
     member_2=[member_2 length(member_2)+1 ];
     a_2(length(member_2))=a(i);
     if (a_2(length(member_2)) <= c_2(length(member_2)))
         b_2(length(member_2))=c_2(length(member_2)-1);%�����i���˵���ʱ���ǰһ�����뿪ʱ����,���俪ʼ����ʱ��Ϊǰһ���뿪ʱ��
     else
         b_2(length(member_2))=a_2(length(member_2)); %�����i���˵���ʱ���ǰһ�����뿪ʱ����,���俪ʼ����ʱ��Ϊ����ʱ��.
     end 
     c_2(length(member_2))=b_2(length(member_2))+st_2(length(member_2));  %��i�����뿪ʱ��Ϊ�俪ʼ����ʱ��+���ܷ���ʱ�� 
 end     
end

%�������ʱ������ϵͳ���ܹ˿���
len_mem1 = length(member_1);
%*****************************************
%������
%*****************************************
%�����ڷ���ʱ���ڣ�����ϵͳ�����й˿͵ĵ���ʱ�̺���
%��ʱ������ͼ��stairs�����ƶ�ά����ͼ��
stairs([0 a_1(member_1)],0:len_mem1);
hold on;
stairs([0 c_1(member_1)],0:len_mem1);
legend('����ʱ�� ','�뿪ʱ�� ');
hold off;
grid on;
%�����ڷ���ʱ���ڣ�����ϵͳ�����й˿͵�ͣ��ʱ��͵�
%��ʱ������ͼ��plot�����ƶ�ά����ͼ��
figure;
plot(1:len_mem1,b_1(member_1)-a_1(member_1),'-*',1: len_mem1,c_1(member_1)-a_1(member_1),'-*');
legend('�ȴ�ʱ�� ','ͣ��ʱ�� ');
grid on;
