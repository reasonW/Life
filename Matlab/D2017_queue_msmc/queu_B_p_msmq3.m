%% 这个B 区域多服务多队列
arr_num_b=arr_num;
% state_a_b=randsrc(1,47,b_p_ser_time);
% state_b_b=randsrc(1,47,b_p_ser_time);
state_a_b=zeros(1,arr_num_b);state_b_b=zeros(1,arr_num_b);
tmp_a_b=normrnd(232.39,143.94,1,arr_num_b+1);
tmp_a_b=sort(abs(tmp_a_b));
for i=1:arr_num_b
    if(MODEL==1)
        state_a_b(i)=(tmp_a_b(i+1)-tmp_a_b(i))*1/3.7;% pre check
    else
        state_a_b(i)=(tmp_a_b(i+1)-tmp_a_b(i))*1;% Regular
    end
end
tmp_b_b=normrnd(232.39,143.94,1,arr_num_b+1);
tmp_b_b=sort(abs(tmp_b_b));
for i=1:arr_num_b
    if(MODEL==1)
         state_b_b(i)=(tmp_b_b(i+1)-tmp_b_b(i))*1/7;% pre check
    else
         state_b_b(i)=(tmp_b_b(i+1)-tmp_b_b(i))*1;% Regular 
    end
end
tmp_c_b=normrnd(232.39,143.94,1,arr_num_b+1);
tmp_c_b=sort(abs(tmp_c_b));
for i=1:arr_num_b
    if(MODEL==1)
         state_c_b(i)=(tmp_c_b(i+1)-tmp_c_b(i))*1/7;% pre check
    else
         state_c_b(i)=(tmp_c_b(i+1)-tmp_c_b(i))*1;% Regular 
    end
end

 %st=exprnd(2.5,1,n); %服务台服务时间
ba1_a=zeros(1,arr_num_b); %每个人到达时间
ba2_a=zeros(1,arr_num_b); %每个人开始接受服务时间   -> events(3,:)
ba3_a=zeros(1,arr_num_b);%每个人离开时间            -> events(4,:)
ba4_a=zeros(1,arr_num_b);% %标识位表示其进入系统后，系统内共有的顾客数       -> events(5,:)
ba5_a=zeros(1,arr_num_b);% 标识位是否进入复查
aerfa=0.02;
ba1_b=zeros(1,arr_num_b); %每个人到达时间
ba2_b=zeros(1,arr_num_b); %每个人开始接受服务时间   -> events(3,:)
ba3_b=zeros(1,arr_num_b);%每个人离开时间            -> events(4,:)
ba4_b=zeros(1,arr_num_b);% %标识位表示其进入系统后，系统内共有的顾客数       -> events(5,:)
ba5_b=zeros(1,arr_num_b);% 标识位是否进入复查
ba1_c=zeros(1,arr_num_b); %每个人到达时间
ba2_c=zeros(1,arr_num_b); %每个人开始接受服务时间   -> events(3,:)
ba3_c=zeros(1,arr_num_b);%每个人离开时间            -> events(4,:)
ba4_c=zeros(1,arr_num_b);% %标识位表示其进入系统后，系统内共有的顾客数       -> events(5,:)
ba5_c=zeros(1,arr_num_b);% 标识位是否进入复查

ba1_a(1)=0;
% for i=2:arr_num
%   a1(i)=a1(i-1)+dt(i-1);%第i个人到达时间  -> events(1,:)
% end
arr_time_b=a3;
ba1_a(1)=arr_time_b(1);%第1个人到达时间
ba1_b(1)=arr_time_b(2);%第1个人到达时间
ba1_c(1)=arr_time_b(2);%第1个人到达时间
ba2_a(1)=arr_time_b(1);%第1个人开始接受服务时间为到达时间
ba2_b(1)=arr_time_b(2);%第1个人开始接受服务时间为到达时间
ba2_c(1)=arr_time_b(2);%第1个人开始接受服务时间为到达时间
ba3_a(1)=ba2_a(1)+state_a_b(1); %第1个人离开时间
ba3_b(1)=ba2_b(1)+state_b_b(1); %第1个人离开时间
ba3_c(1)=ba2_c(1)+state_c_b(1); %第1个人离开时间
ba4_a(1)=1;%一个顾客,标志位置为1
ba4_b(1)=1;%一个顾客,标志位置为1
ba4_c(1)=1;%一个顾客,标志位置为1
ba5_a(1)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
ba5_b(1)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
ba5_c(1)=randsrc(1,1,[0 1;aerfa 1-aerfa]);

%其进入系统后，系统内已有成员序号为 1
member_A_b = [1];
member_B_b = [1];
member_C_b = [1];
bottleB=zeros(1,10);
bottleB(1)=0;
bottleB(2)=0;
bottleB(3)=0;
DeteB=0;
DeteB_t=[];

Pointer=3;

for i=4:arr_num
    if ba4_a(length(member_A_b))== min(ba4_a(length(member_A_b)),min(ba4_b(length(member_B_b)),ba4_c(length(member_C_b))))
        member_A_b=[member_A_b,length(member_A_b)+1];
        len_A_mem_b=length(member_A_b);
        ba1_a(len_A_mem_b)=arr_time_b(i);
        number=sum(ba3_a(1:len_A_mem_b-1)>=ba1_a(len_A_mem_b));
          if number ==0
            ba2_a(len_A_mem_b)=ba1_a(len_A_mem_b);
            ba3_a(len_A_mem_b)=ba1_a(len_A_mem_b)+state_a_b(len_A_mem_b);
            ba4_a(len_A_mem_b)=1;
            ba5_a(len_A_mem_b)=randsrc(1,1,[0 1;1-aerfa aerfa]);
          else
            ba2_a(len_A_mem_b)=ba3_a(len_A_mem_b-1);
            ba3_a(len_A_mem_b)=ba2_a(len_A_mem_b)+state_a_b(len_A_mem_b);
            ba4_a(len_A_mem_b)=number+1;
            ba5_a(len_A_mem_b)=randsrc(1,1,[0 1;1-aerfa aerfa]);
          end
          bottleB(rem(Pointer+1,10)+1)=ba2_a(len_A_mem_b)-ba1_a(len_A_mem_b);
          Pointer=Pointer+1;
    elseif ba4_b(length(member_B_b))== min(ba4_a(length(member_A_b)),min(ba4_b(length(member_B_b)),ba4_c(length(member_C_b))))
         member_B_b=[member_B_b,length(member_B_b)+1];
         len_B_mem_b=length(member_B_b);
         ba1_b(len_B_mem_b)=arr_time_b(i);
         number=sum(ba3_b(1:len_B_mem_b-1)>=ba1_b(len_B_mem_b));
          if number ==0
            ba2_b(len_B_mem_b)=ba1_b(len_B_mem_b);
            ba3_b(len_B_mem_b)=ba1_b(len_B_mem_b)+state_b_b(len_B_mem_b);
            ba4_b(len_B_mem_b)=1;
            ba5_b(len_B_mem_b)=randsrc(1,1,[0 1;1-aerfa aerfa]);
          else
            ba2_b(len_B_mem_b)=ba3_b(len_B_mem_b-1);
            ba3_b(len_B_mem_b)=ba2_b(len_B_mem_b)+state_b_b(len_B_mem_b);
            ba4_b(len_B_mem_b)=number+1;
            ba5_b(len_B_mem_b)=randsrc(1,1,[0 1;1-aerfa aerfa]);
          end
          bottleB(rem(Pointer+1,10)+1)=ba2_b(len_B_mem_b)-ba1_b(len_B_mem_b);
          Pointer=Pointer+1;
    else
         member_C_b=[member_C_b,length(member_C_b)+1];
         len_C_mem_b=length(member_C_b);
         ba1_c(len_C_mem_b)=arr_time_b(i);
         number=sum(ba3_c(1:len_C_mem_b-1)>=ba1_c(len_C_mem_b));
          if number ==0
            ba2_c(len_C_mem_b)=ba1_c(len_C_mem_b);
            ba3_c(len_C_mem_b)=ba1_c(len_C_mem_b)+state_c_b(len_C_mem_b);
            ba4_c(len_C_mem_b)=1;
            ba5_c(len_C_mem_b)=randsrc(1,1,[0 1;1-aerfa aerfa]);
          else
            ba2_c(len_C_mem_b)=ba3_c(len_C_mem_b-1);
            ba3_c(len_C_mem_b)=ba2_c(len_C_mem_b)+state_c_b(len_C_mem_b);
            ba4_c(len_C_mem_b)=number+1;
            ba5_c(len_C_mem_b)=randsrc(1,1,[0 1;1-aerfa aerfa]);
          end
          bottleB(rem(Pointer+1,10)+1)=ba2_c(len_C_mem_b)-ba1_c(len_C_mem_b);
          Pointer=Pointer+1;
    end
    if (MODEL==1)
        if sum(bottleB)/20>1.65
%            fprintf('B person area %f people waiting long %f \n',i,sum(bottleA)/20);
        DeteB=DeteB+1;
        DeteB_t=[DeteB_t sum(bottleB)/10];

        end
    else
        if sum(bottleB)/20>7.27
%            fprintf('B person area %f people waiting long %f \n',i,sum(bottleA)/20);
        DeteB=DeteB+1;
        DeteB_t=[DeteB_t sum(bottleB)/10];
        end
    end
end
%% demo_绘图
len_A_mem_b = length(member_A_b);
len_B_mem_b = length(member_B_b);
len_C_mem_b = length(member_C_b);
b1=[ba1_a(1:len_A_mem_b) ba1_b(1:len_B_mem_b) ba1_c(1:len_C_mem_b)];
b2=[ba2_a(1:len_A_mem_b) ba2_b(1:len_B_mem_b) ba2_c(1:len_C_mem_b)];
b3=[ba3_a(1:len_A_mem_b) ba3_b(1:len_B_mem_b) ba3_c(1:len_C_mem_b)];
b4=[ba4_a(1:len_A_mem_b) ba4_b(1:len_B_mem_b) ba4_c(1:len_C_mem_b)];
b_tmp=[b1;b2;b3;b4];
b_tmp_=sortrows(b_tmp',1);
b_tmp=b_tmp_';
b1=b_tmp(1,:);
b2=b_tmp(2,:);
b3=b_tmp(3,:);
b4=b_tmp(4,:);
%仿真结束时，进入系统的总顾客数
%*****************************************
%输出结果
%*****************************************
%绘制在仿真时间内，进入系统的所有顾客的到达时刻和离
%开时刻曲线图（stairs：绘制二维阶梯图）
% figure;
% stairs(0:arr_num_b,[0 b1],'o-','linewidth',1, 'MarkerFaceColor','g','markersize',2);
% hold on;
% stairs(0:arr_num_b,[0 b3 ],'o-','linewidth',1, 'MarkerFaceColor','y','markersize',2);
% legend('B_p arriving time','B_p leaving time');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% hold off;
% grid on;
%绘制在仿真时间内，进入系统的所有顾客的停留时间和等
%待时间曲线图（plot：绘制二维线性图）
B_cost_time=zeros(1,arr_num_b); %记录每个人在系统逗留时间
B_wait_time=zeros(1,arr_num_b); %记录每个人在系统等待时间
for i=1:arr_num
  B_cost_time(i)=b3(i)-b1(i); %第i个人在系统逗留时间
  B_wait_time(i)=b2(i)-b1(i); %第i个人在系统等待时间
end


%% x_输出
% T1=ba3_a(len_A_mem_b)+ba3_b(len_B_mem_b)%总时间
% p1=sum(state_a_b(member_A_b))/T1+sum(state_a_b(member_A_b))/T1 %服务率
% avert1=sum(B_wait_time)/(sum(state_a_b(member_A_b)))%每个人系统平均逗留时间
% fprintf('B passenager averager cost time%fs\n',avert1);
% fprintf('B system working intensity %f\n',p1);

%% D 区复查
if sum(ba5_a)+sum(ba5_b)+sum(ba5_c)==0
    ba5_a(1)=1;
end

da1=zeros(1,sum(ba5_a)+sum(ba5_b)+sum(ba5_c));
index=find(ba5_a==1);
for i=1:sum(ba5_a)
    da1(i)=ba3_a(index(i));
end
index=find(ba5_b==1);n=1;
for i=sum(ba5_a)+1:sum(ba5_a)+sum(ba5_b)
    da1(i)=ba3_b(index(n));
    n=n+1;
end
index=find(ba5_c==1);n=1;
for i=sum(ba5_a)+sum(ba5_b)+1:sum(ba5_a)+sum(ba5_b)+sum(ba5_c)
    da1(i)=ba3_c(index(n));
    n=n+1;
end
da1=sort(da1);


