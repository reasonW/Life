%% 这个D 区域单服务单队列
sdata_d=randsrc(1,length(da1_b),[7.55 5.28 11.06 9.98 9.15 8.82 12.61 15.44 11.88]);
da2_b=zeros(1,length(da1_b)); %每个人开始接受服务时间   -> events(3,:)
da3_b=zeros(1,length(da1_b));%每个人离开时间            -> events(4,:)
da4_b=zeros(1,length(da1_b));% %标识位表示其进入系统后，系统内共有的顾客数        -> events(5,:)

da2_b(1)=da1_b(1);%第1个人开始服务时间为到达时间
da3_b(1)=da2_b(1)+sdata_d(1); %第1个人离开时间为服务时间+到达时间
da4_b(1)=1;%一个顾客,标志位置为1
%其进入系统后，系统内已有成员序号为 1
member_D_b = [1];
bottleCb=zeros(1,10);
bottleCb(1)=0; 
DeteCb=0;
DeteCb_t=[];
Pointer=1;

for i=2:length(da1_b)
    number=sum(da3_b(member_D_b)>da1_b(i));
      if number ==0
        da2_b(i)=da1_b(i);
        da3_b(i)=da1_b(i)+sdata_d(i);
        da4_b(i)=1;
        member_D_b=[member_D_b,i];
        bottleCb(rem(Pointer+1,10)+1)=da2_b(i)-da1_b(i);
        Pointer=Pointer+1;
      else
        len_D_mem_b=length(member_D_b);
        da2_b(i)=da3_b(member_D_b(len_D_mem_b));
        da3_b(i)=da3_b(member_D_b(len_D_mem_b))+sdata_d(i);
        da4_b(i)=number+1;
        member_D_b=[member_D_b,i];
        bottleCb(rem(Pointer+1,10)+1)=da2_b(i)-da1_b(i);
        Pointer=Pointer+1;
      end
    if (MODEL==1)
        if sum(bottleCb)/10>1.65*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteCb=DeteCb+1;
        DeteCb_t=[DeteCb_t sum(bottleB)/10];
        end
    else
        if sum(bottleCb)/10>7.24*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteCb=DeteCb+1;
        DeteCb_t=[DeteCb_t sum(bottleB)/10];
        end
    end
end
%% 到达时间和离开时间
%仿真结束时，进入系统的总顾客数
len_D_mem_b = length(member_D_b);
%*****************************************
%输出结果
%*****************************************
%绘制在仿真时间内，进入系统的所有顾客的到达时刻和离
%开时刻曲线图（stairs：绘制二维阶梯图）
% figure;
% stairs(0:len_D_mem_b,[0 da1_b(member_D_b)],'o-','linewidth',1, 'MarkerFaceColor','g','markersize',2);
% hold on;
% stairs(0:len_D_mem_b,[0 da3_b(member_D_b)],'o-','linewidth',1, 'MarkerFaceColor','y','markersize',2);
% legend('D_b arriving time','D_b leaving time');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% hold off;
% grid on;

%% 个人逗留时间和等待时间
%绘制在仿真时间内，进入系统的所有顾客的停留时间和等
%待时间曲线图（plot：绘制二维线性图）
D_cost_time_b=zeros(1,len_D_mem_b); %记录每个人在系统逗留时间
D_wait_time_b=zeros(1,len_D_mem_b); %记录每个人在系统等待时间
for i=1:len_D_mem_b
    D_wait_time_b(i)=da2_b(i)-da1_b(i); %第i个人在系统等待时间
    D_cost_time_b(i)=da3_b(i)-da1_b(i); %第i个人在系统逗留时间
end
% figure;
% plot(1:len_D_mem_b,D_cost_time_b(member_D_b),'-', 1: len_D_mem_b,D_wait_time_b(member_D_b),'-');
% legend('D_b cost time ','D_b waiting time ');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% grid on;

%% x_输出
% T4_b=da3_b(len_D_mem_b)%总时间
% p4_b=sum(sdata_d(member_D_b))/T4_b %服务率
% avert4_b=sum(D_wait_time_b(member_D_b))/len_D_mem_b;%每个人系统平均逗留时间
% fprintf('D_b averager cost time%6.2fs\n\n',avert4_b);
% fprintf('D_b system working intensity%6.3f\n',p4_b);

%% B_
%% B 
B_D_cost_time_b=B_cost_time_b; %记录每个人在系统逗留时间
B_D_wait_time_b=B_wait_time_b; %记录每个人在系统等待时间
for i=1:arr_num
  if sum(find(da1_b==b3(i)))~=0
      index=find(da1_b==b3(i));
      B_D_wait_time_b(i)=B_D_wait_time_b(i)+da2_b(index)-da1_b(index); %第i个人在系统等待时间
      B_D_cost_time_b(i)=B_D_cost_time_b(i)+da3_b(index)-da1_b(index); %第i个人在系统逗留时间
  end
end

% figure;
% plot(1:arr_num_b,B_D_cost_time_b,'-', 1: arr_num_b,B_D_wait_time_b,'-');
% legend('B_b cost time ','B_b waiting time ');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% grid on;

%% all
Wait_time=zeros(1,arr_num);
Cost_time=zeros(1,arr_num);
for i=1:arr_num
  Wait_time( i)=A_wait_time(i)+max(B_D_wait_time(i),B_D_wait_time_b(i));
  Cost_time( i)=A_cost_time(i)+max(B_D_cost_time(i),B_D_cost_time_b(i));
end