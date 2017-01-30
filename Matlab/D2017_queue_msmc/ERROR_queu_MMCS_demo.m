%% 这个是有限长度,无限时间的单服务多队列
n=400; %模拟顾客数
dt=exprnd(0.1,1,n); %到达时间间隔
% events(2,:) = exprnd(ser_mean,1,arr_num);

st_1=exprnd(1/6,1,n); %服务台服务时间
st_2=exprnd(1/6,1,n); %服务台服务时间
%st=exprnd(2.5,1,n); %服务台服务时间
a=zeros(1,n); %每个人到达时间
a_1=zeros(1,n); %1队每个人到达时间
a_2=zeros(1,n);%2队每个人到达时间
b_1 =zeros(1,n); %1队每个人开始接受服务时间
b_2=zeros(1,n);%2队每个人开始接受服务时间
c_1=zeros(1,n);%1队每个人离开时间
c_2=zeros(1,n);%2队每个人离开时间
member_1 = [];
member_2 = [];

a(1)=0;
for i=2:n
  a(i)=a(i-1)+dt(i-1);%第i个人到达时间
end  

a_1(1)=0;
b_1(1)=0;%第1个人开始服务时间为到达时间
c_1(1)=b_1(1)+st_1(1); %第1个人离开时间为服务时间
member_1 = [1];

for i=2:n
 len_1 = sum(c_1(member_1) > a(i));
 len_2 = sum(c_2(member_2) > a(i));
 if len_1<=len_2
     member_1=[member_1 length(member_1)+1 ];
     a_1(length(member_1))=a(i);
     if (a_1(length(member_1)) <= c_1(length(member_1)))
         b_1(length(member_1))=c_1(length(member_1)-1);%如果第i个人到达时间比前一个人离开时间早,则其开始服务时间为前一人离开时间
     else
         b_1(length(member_1))=a_1(length(member_1)); %如果第i个人到达时间比前一个人离开时间晚,则其开始服务时间为到达时间.
     end 
     c_1(length(member_1))=b_1(length(member_1))+st_1(length(member_1));  %第i个人离开时间为其开始服务时间+接受服务时间 
 else 
     member_2=[member_2 length(member_2)+1 ];
     a_2(length(member_2))=a(i);
     if (a_2(length(member_2)) <= c_2(length(member_2)))
         b_2(length(member_2))=c_2(length(member_2)-1);%如果第i个人到达时间比前一个人离开时间早,则其开始服务时间为前一人离开时间
     else
         b_2(length(member_2))=a_2(length(member_2)); %如果第i个人到达时间比前一个人离开时间晚,则其开始服务时间为到达时间.
     end 
     c_2(length(member_2))=b_2(length(member_2))+st_2(length(member_2));  %第i个人离开时间为其开始服务时间+接受服务时间 
 end     
end

%仿真结束时，进入系统的总顾客数
len_mem1 = length(member_1);
%*****************************************
%输出结果
%*****************************************
%绘制在仿真时间内，进入系统的所有顾客的到达时刻和离
%开时刻曲线图（stairs：绘制二维阶梯图）
stairs([0 a_1(member_1)],0:len_mem1);
hold on;
stairs([0 c_1(member_1)],0:len_mem1);
legend('到达时间 ','离开时间 ');
hold off;
grid on;
%绘制在仿真时间内，进入系统的所有顾客的停留时间和等
%待时间曲线图（plot：绘制二维线性图）
figure;
plot(1:len_mem1,b_1(member_1)-a_1(member_1),'-*',1: len_mem1,c_1(member_1)-a_1(member_1),'-*');
legend('等待时间 ','停留时间 ');
grid on;
