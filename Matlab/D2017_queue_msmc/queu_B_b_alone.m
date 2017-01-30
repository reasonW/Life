%% 这个B 区域单服务单队列
 %%下面一行的服务时间是服从负指数分布
t3=0.9*abs(exprnd(7.542,1,arr_num));
%st=exprnd(2.5,1,n); %服务台服务时间
bb1=a3; %每个人到达时间
bb2=zeros(1,arr_num); %每个人开始接受服务时间   -> events(3,:)
bb3=zeros(1,arr_num);%每个人离开时间            -> events(4,:)
bb4=zeros(1,arr_num);% %标识位表示其进入系统后，系统内共有的顾客数        -> events(5,:)
bb5=zeros(1,arr_num);% 标识位是否进入复查

bb2(1)=bb1(1);%第1个人开始服务时间为到达时间
bb3(1)=bb2(1)+t3(1); %第1个人离开时间为服务时间
bb4(1)=1;%一个顾客,标志位置为1
aerfa=0.1;
bb5(1)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
%其进入系统后，系统内已有成员序号为 1
member_B_ = [1];
bottleBb=zeros(1,10);
bottleBb(1)=0;
DeteBb=0;
DeteBb_t=[];
Pointer=1;

%% main loop
for i=2:arr_num
    number=sum(bb3(member_B_)>bb1(i));
      if number ==0
        bb2(i)=bb1(i);
        bb3(i)=bb1(i)+t3(i);
        bb4(i)=1;
        bb5(i)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
        member_B_=[member_B_,i];
        bottleBb(rem(Pointer+1,10)+1)=bb2(i)-bb1(i);
          Pointer=Pointer+1;
      else len_B_mem_=length(member_B_);
        bb2(i)=bb3(member_B_(len_B_mem_));
        bb3(i)=bb3(member_B_(len_B_mem_))+t3(i);
        bb4(i)=number+1;
        bb5(i)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
        member_B_=[member_B_,i];
        bottleBb(rem(Pointer+1,10)+1)=bb2(i)-bb1(i);
          Pointer=Pointer+1;
      end
    if (MODEL==1)
        if sum(bottleBb)/10>6.31*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteBb=DeteBb+1;
        DeteBb_t=[DeteBb_t,sum(bottleBb)/10];
        end
    else
        if sum(bottleBb)/10>5.27*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteBb=DeteBb+1;
        DeteBb_t=[DeteBb_t,sum(bottleBb)/10];
        end
    end
end
%% 到达时间和离开时间
%仿真结束时，进入系统的总顾客数
len_B_mem_ = length(member_B_);
%*****************************************
%输出结果
%*****************************************
%绘制在仿真时间内，进入系统的所有顾客的到达时刻和离
%开时刻曲线图（stairs：绘制二维阶梯图）
% figure;
% stairs([0 bb1(member_B_)],0:len_B_mem_,'o-','linewidth',1, 'MarkerFaceColor','g','markersize',2);
% hold on;
% stairs([0 bb3(member_B_)],0:len_B_mem_,'o-','linewidth',1, 'MarkerFaceColor','y','markersize',2);
% legend('B_b arriving time','B_b leaving time');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% hold off;
% grid on;

%% 个人逗留时间和等待时间
%绘制在仿真时间内，进入系统的所有顾客的停留时间和等
%待时间曲线图（plot：绘制二维线性图）
B_cost_time_b=zeros(1,len_B_mem_); %记录每个人在系统逗留时间
B_wait_time_b=zeros(1,len_B_mem_); %记录每个人在系统等待时间
for i=1:len_B_mem_
  B_cost_time_b(i)=bb3(i)-bb1(i); %第i个人在系统逗留时间
  B_wait_time_b(i)=bb2(i)-bb1(i); %第i个人在系统等待时间
end
% figure;
% plot(1:len_B_mem_,B_cost_time_(member_B_),'-', 1: len_B_mem_,B_wait_time_b(member_B_),'-');
% legend('B_b cost time ','B_b waiting time ');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% grid on;

%% x_输出
% T3=bb3(len_B_mem_);%总时间
% p3=sum(t3(member_B_))/T3; %服务率
% avert3=sum(B_wait_time_b(member_B_))/len_B_mem_;%每个人系统平均逗留时间
% fprintf('B_b averager cost time%6.2fs\n',avert3);
% fprintf('B_b system working intensity%6.3f\n',p3);

%% D 区复查
da1_b=zeros(1,sum(bb5));
index_=find(bb5==1);
for i=1:sum(bb5)
    da1_b(i)=bb3(index_(i));
end


