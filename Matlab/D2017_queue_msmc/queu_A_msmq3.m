%% 这个A 区域多服务多队列
% arr_time=normrnd(273.964,165.70,1,arr_num); %ERROR正态分布
% arr_time=sort(abs(arr_time));
if(MODEL==1)
    arr_time=arr_time2(1:arr_num);
else
    arr_time=arr_time1(1:arr_num);
end
% state_a=randsrc(1,47,[7.55 5.28 11.06 9.98 9.15 8.82 12.61 15.44 11.88]);
state_a=normrnd(12.946,4.54,1,arr_num);
state_a=abs(state_a);
% state_b=randsrc(1,47,[14.65 11.85 14.78 20.45 7.7 7.5 10.93]);
state_b=normrnd(12.551,4.54,1,arr_num);
state_b=abs(state_b);
state_c=normrnd(12.551,4.54,1,arr_num);
state_c=abs(state_c);

%st=exprnd(2.5,1,n); %服务台服务时间
a1_a=zeros(1,arr_num); %每个人到达时间
a2_a=zeros(1,arr_num); %每个人开始接受服务时间   -> events(3,:)
a3_a=zeros(1,arr_num);%每个人离开时间            -> events(4,:)
a4_a=zeros(1,arr_num);% %标识位表示其进入系统后，系统内共有的顾客数       -> events(5,:)
a1_b=zeros(1,arr_num); %每个人到达时间
a2_b=zeros(1,arr_num); %每个人开始接受服务时间   -> events(3,:)
a3_b=zeros(1,arr_num);%每个人离开时间            -> events(4,:)
a4_b=zeros(1,arr_num);% %标识位表示其进入系统后，系统内共有的顾客数       -> events(5,:)
a1_c=zeros(1,arr_num); %每个人到达时间
a2_c=zeros(1,arr_num); %每个人开始接受服务时间   -> events(3,:)
a3_c=zeros(1,arr_num);%每个人离开时间            -> events(4,:)
a4_c=zeros(1,arr_num);% %标识位表示其进入系统后，系统内共有的顾客数       -> events(5,:)

a1_a(1)=0;
% for i=2:arr_num
%   a1(i)=a1(i-1)+dt(i-1);%第i个人到达时间  -> events(1,:)
% end
a1_a(1)=arr_time(1);%第1个人到达时间
a1_b(1)=arr_time(2);%第1个人到达时间
a1_c(1)=arr_time(3);%第1个人到达时间
a2_a(1)=arr_time(1);%第1个人开始服务时间为到达时间
a2_b(1)=arr_time(2);%第1个人开始服务时间为到达时间
a2_c(1)=arr_time(3);%第1个人开始服务时间为到达时间
a3_a(1)=a2_a(1)+state_a(1); %第1个人离开时间
a3_b(1)=a2_b(1)+state_b(1); %第1个人离开时间
a3_c(1)=a2_c(1)+state_c(1); %第1个人离开时间
a4_a(1)=1;%一个顾客,标志位置为1
a4_b(1)=1;%一个顾客,标志位置为1
a4_c(1)=1;%一个顾客,标志位置为1
%其进入系统后，系统内已有成员序号为 1
member_A = [1];
member_B = [1];
member_C = [1];
bottleA=zeros(1,10);
bottleA(1)=0;
bottleA(2)=0;
bottleA(3)=0;
DeteA=0;
DeteA_t=[ ];

Pointer=3;
for i=4:arr_num
    if a4_a(length(member_A)) == min(a4_a(length(member_A)),min(a4_b(length(member_B)),a4_c(length(member_C))))
        member_A=[member_A,length(member_A)+1];
        len_A_mem=length(member_A);
        a1_a(len_A_mem)=arr_time(i);
        number=sum(a3_a(1:len_A_mem-1)>=a1_a(len_A_mem));
          if number ==0
            a2_a(len_A_mem)=a1_a(len_A_mem);
            a3_a(len_A_mem)=a1_a(len_A_mem)+state_a(len_A_mem);
            a4_a(len_A_mem)=1;
          else
            a2_a(len_A_mem)=a3_a(len_A_mem-1);
            a3_a(len_A_mem)=a2_a(len_A_mem)+state_a(len_A_mem);
            a4_a(len_A_mem)=number+1;
          end
          bottleA(rem(Pointer+1,10)+1)=a2_a(len_A_mem)-a1_a(len_A_mem);
          Pointer=Pointer+1;
    elseif  a4_b(length(member_B)) ==  min(a4_a(length(member_A)),min(a4_b(length(member_B)),a4_c(length(member_C))))
         member_B=[member_B,length(member_B)+1];
         len_B_mem=length(member_B);
         a1_b(len_B_mem)=arr_time(i);
         number=sum(a3_b(1:len_B_mem-1)>=a1_b(len_B_mem));
          if number ==0
            a2_b(len_B_mem)=a1_b(len_B_mem);
            a3_b(len_B_mem)=a1_b(len_B_mem)+state_b(len_B_mem);
            a4_b(len_B_mem)=1;
          else
            a2_b(len_B_mem)=a3_b(len_B_mem-1);
            a3_b(len_B_mem)=a2_b(len_B_mem)+state_b(len_B_mem);
            a4_b(len_B_mem)=number+1;
          end
          bottleA(rem(Pointer+1,10)+1)=a2_b(len_B_mem)-a1_b(len_B_mem);
          Pointer=Pointer+1;
    else
         member_C=[member_C,length(member_C)+1];
         len_C_mem=length(member_C);
         a1_c(len_C_mem)=arr_time(i);
         number=sum(a3_b(1:len_C_mem-1)>=a1_c(len_C_mem));
          if number ==0
            a2_c(len_C_mem)=a1_c(len_C_mem);
            a3_c(len_C_mem)=a1_c(len_C_mem)+state_c(len_C_mem);
            a4_c(len_C_mem)=1;
          else
            a2_c(len_C_mem)=a3_c(len_C_mem-1);
            a3_c(len_C_mem)=a2_c(len_C_mem)+state_c(len_C_mem);
            a4_c(len_C_mem)=number+1;
          end
          bottleA(rem(Pointer+1,10)+1)=a2_b(len_C_mem)-a1_b(len_C_mem);
          Pointer=Pointer+1;          
    end
    if (MODEL==1)
        if sum(bottleA)/10>11.27
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteA=DeteA+1;
        DeteA_t=[DeteA_t,sum(bottleA)/10];
        end
    else
        if sum(bottleA)/10>13.64
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteA=DeteA+1;
        DeteA_t=[DeteA_t,sum(bottleA)/10];        
        end
    end
end
%% demo_绘图
len_A_mem = length(member_A);
len_B_mem = length(member_B);
len_C_mem = length(member_C);
a1=[a1_a(1:len_A_mem) a1_b(1:len_B_mem) a1_c(1:len_C_mem)];
a2=[a2_a(1:len_A_mem) a2_b(1:len_B_mem) a2_c(1:len_C_mem)];
a3=[a3_a(1:len_A_mem) a3_b(1:len_B_mem) a3_c(1:len_C_mem)];
a4=[a4_a(1:len_A_mem) a4_b(1:len_B_mem) a4_c(1:len_C_mem)];
a_tmp=[a1;a2;a3;a4];
a_tmp_=sortrows(a_tmp',1);
a_tmp=a_tmp_';
a1=a_tmp(1,:);
a2=a_tmp(2,:);
a3=a_tmp(3,:);
a4=a_tmp(4,:);
%仿真结束时，进入系统的总顾客数
%*****************************************
%输出结果
%*****************************************
%绘制在仿真时间内，进入系统的所有顾客的到达时刻和离
%开时刻曲线图（stairs：绘制二维阶梯图）
% stairs(0:arr_num,[0 a1],'o-','linewidth',1, 'MarkerFaceColor','g','markersize',2);
% hold on;
% stairs(0:arr_num,[0 a3 ],'o-','linewidth',1, 'MarkerFaceColor','y','markersize',2);
% legend('A arriving time','A leaving time');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% hold off;
% grid on;
%绘制在仿真时间内，进入系统的所有顾客的停留时间和等
%待时间曲线图（plot：绘制二维线性图）
A_cost_time=zeros(1,arr_num); %记录每个人在系统逗留时间
A_wait_time=zeros(1,arr_num); %记录每个人在系统等待时间
for i=1:arr_num
  A_cost_time(i)=a3(i)-a1(i); %第i个人在系统逗留时间
  A_wait_time(i)=a2(i)-a1(i); %第i个人在系统等待时间
end
% figure;
% plot(1:arr_num,A_cost_time,'-', 1:arr_num,A_wait_time,'-');
% legend('A cost time ','A waiting time ');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% grid on;

%% x_输出
% T1=a3_a(arr_num)%总时间
% p1=sum(state_a(member_A))/T1+sum(state_b(member_B))/T1 %服务率
% avert1=sum(A_wait_time)/(sum(state_a(member_A))+sum(state_b(member_B)))%每个人系统平均逗留时间
% fprintf('A passenager averager cost time%fs\n',avert1);
% fprintf('A system working intensity %f\n',p1);


