t4=randsrc(1,length(da1),[7.55 5.28 11.06 9.98 9.15 8.82 12.61 15.44 11.88]);%          -> events(2,:)

%st=exprnd(2.5,1,n); %服务台服务时间
da2=zeros(1,length(da1)); %每个人开始接受服务时间   -> events(3,:)
da3=zeros(1,length(da1));%每个人离开时间            -> events(4,:)
da4=zeros(1,length(da1));% %标识位表示其进入系统后，系统内共有的顾客数        -> events(5,:)
da5=zeros(1,length(da1));% 标识位是否进入复查

da2(1)=da1(1);%第1个人开始服务时间为到达时间
da3(1)=da2(1)+t4(1); %第1个人离开时间为服务时间
da4(1)=1;%一个顾客,标志位置为1
aerfa=0.1;
da5(1)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
%其进入系统后，系统内已有成员序号为 1
member_D = [1];

for i=2:length(da1)

    number=sum(da3(member_D)>da1(i));
      if number ==0
        da2(i)=da1(i);
        da3(i)=da1(i)+t4(i);
        da4(i)=1;
        da5(i)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
        member_D=[member_D,i];
      else len_D_mem=length(member_D);
        da2(i)=da3(member_D(len_D_mem));
        da3(i)=da3(member_D(len_D_mem))+t4(i);
        da4(i)=number+1;
        da5(i)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
        member_D=[member_D,i];

        % if(a1(i)<=a3(i-1))
        %    a2(i)=a3(i-1);%如果第i个人到达时间比前一个人离开时间早,则其开始服务时间为前一人离开时间
        % else
        %    a2(i)=a1(i); %如果第i个人到达时间比前一个人离开时间晚,则其开始服务时间为到达时间.
        % end

        % a3(i)=a2(i)+t1(i);  %第i个人离开时间为其开始服务时间+接受服务时间
      end
end
%% 到达时间和离开时间
%仿真结束时，进入系统的总顾客数
len_D_mem = length(member_D);
%*****************************************
%输出结果
%*****************************************
%绘制在仿真时间内，进入系统的所有顾客的到达时刻和离
%开时刻曲线图（stairs：绘制二维阶梯图）
% figure;
% stairs([0 da1(member_D)],0:len_D_mem,'o-','linewidth',1, 'MarkerFaceColor','g','markersize',2);
% hold on;
% stairs([0 da3(member_D)],0:len_D_mem,'o-','linewidth',1, 'MarkerFaceColor','y','markersize',2);
% legend('D_p arriving time','D_p leaving time');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% hold off;
% grid on;

%% 个人逗留时间和等待时间
%绘制在仿真时间内，进入系统的所有顾客的停留时间和等
%待时间曲线图（plot：绘制二维线性图）
D_cost_time=zeros(1,len_D_mem); %记录每个人在系统逗留时间
D_wait_time=zeros(1,len_D_mem); %记录每个人在系统等待时间
for i=1:len_D_mem
    D_wait_time(i)=da2(i)-da1(i); %第i个人在系统等待时间
    D_cost_time(i)=da3(i)-da1(i); %第i个人在系统逗留时间
end
% figure;
% plot(1:len_D_mem,D_cost_time(member_D),'-', 1: len_D_mem,D_wait_time(member_D),'-');
% legend('D_p cost time ','D_p waiting time ');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% grid on;

%% x_输出
T4=da3(len_D_mem)%总时间
p4=sum(t4(member_D))/T4 %服务率
avert4=sum(D_wait_time(member_D))/len_D_mem;%每个人系统平均逗留时间
fprintf('D_p averager cost time%6.2fs\n\n',avert4);
fprintf('D_p system working intensity%6.3f\n',p4);

%% B 
B_D_cost_time=B_cost_time; %记录每个人在系统逗留时间
B_D_wait_time=B_wait_time; %记录每个人在系统等待时间

for i=1:arr_num_b
  if sum(find(da1==b3(i)))~=0
      index=find(da1==b3(i));
      B_D_wait_time(i)=B_D_wait_time(i)+da2(index)-da1(index); %第i个人在系统等待时间
      B_D_cost_time(i)=B_D_cost_time(i)+da3(index)-da1(index); %第i个人在系统逗留时间
  end
end
