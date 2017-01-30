%% 这个D 区域单服务单队列
db1=da1_b;
t5=randsrc(1,length(da1_b),[7.55 5.28 11.06 9.98 9.15 8.82 12.61 15.44 11.88]);
%st=exprnd(2.5,1,n); %服务台服务时间
db2=zeros(1,length(da1_b)); %每个人开始接受服务时间   -> events(3,:)
db3=zeros(1,length(da1_b));%每个人离开时间            -> events(4,:)
db4=zeros(1,length(da1_b));% %标识位表示其进入系统后，系统内共有的顾客数        -> events(5,:)
db5=zeros(1,length(da1_b));% 标识位是否进入复查

db2(1)=bb1(1);%第1个人开始服务时间为到达时间
db3(1)=db2(1)+t5(1); %第1个人离开时间为服务时间
db4(1)=1;%一个顾客,标志位置为1
aerfa=0.1;
db5(1)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
%其进入系统后，系统内已有成员序号为 1
member_D_b = [1];

for i=2:length(db1)

    number=sum(db3(member_D_b)>db1(i));
      if number ==0
        db2(i)=db1(i);
        db3(i)=db1(i)+t5(i);
        db4(i)=1;
        db5(i)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
        member_D_b=[member_D_b,i];
      else len_D_mem_b=length(member_D_b);
        db2(i)=db3(member_D_b(len_D_mem_b));
        db3(i)=db3(member_D_b(len_D_mem_b))+t5(i);
        db4(i)=number+1;
        db5(i)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
        member_D_b=[member_D_b,i];

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
len_D_mem_b = length(member_D_b);
%*****************************************
%输出结果
%*****************************************
%绘制在仿真时间内，进入系统的所有顾客的到达时刻和离
%开时刻曲线图（stairs：绘制二维阶梯图）
% figure;
% stairs([0 db1(member_D_b)],0:len_D_mem_b,'o-','linewidth',1, 'MarkerFaceColor','g','markersize',2);
% hold on;
% stairs([0 db3(member_D_b)],0:len_D_mem_b,'o-','linewidth',1, 'MarkerFaceColor','y','markersize',2);
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
    D_wait_time_b(i)=db2(i)-db1(i); %第i个人在系统等待时间
    D_cost_time_b(i)=db3(i)-db1(i); %第i个人在系统逗留时间
end
% figure;
% plot(1:len_D_mem_,D_cost_time_b(member_D_),'-', 1: len_D_mem_,D_wait_time_b(member_D_),'-');
% legend('D_b cost time ','D_b waiting time ');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% grid on;

%% x_输出
T5=db3(len_D_mem_b)%总时间
p5=sum(t5(member_D_b))/T5 %服务率
avert5=sum(D_wait_time_b(member_D_b))/len_D_mem_b;%每个人系统平均逗留时间
fprintf('D_b averager cost time%6.2fs\n\n',avert5);
fprintf('D_b system working intensity%6.3f\n',p5);

%% B 
% B_D_cost_time_b=B_cost_time_b; %记录每个人在系统逗留时间
% B_D_wait_time_b=B_wait_time_b; %记录每个人在系统等待时间
% for i=1:length(da1_b)
%   tmp1_=0;tmp2_=0;
%   if bb5(i)==1
%       tmp1_=db2(find(index_==i))-db1(find(index_==i));
%       tmp2_=db3(find(index_==i))-db1(find(index_==i));
%   end    
%   B_D_wait_time_b(i)=B_D_wait_time_b(i)+bb5(i)*tmp1_; %第i个人在系统等待时间
%   B_D_cost_time_b(i)=B_D_cost_time_b(i)+bb5(i)*tmp2_; %第i个人在系统逗留时间
% end
B_D_cost_time_b=B_cost_time_b; %记录每个人在系统逗留时间
B_D_wait_time_b=B_wait_time_b; %记录每个人在系统等待时间
for i=1:arr_num_b
  if sum(find(da1_b==b3(i)))~=0
      index=find(da1_b==b3(i));
      B_D_wait_time_b(i)=B_D_wait_time_b(i)+da2_b(index)-da1_b(index); %第i个人在系统等待时间
      B_D_cost_time_b(i)=B_D_cost_time_b(i)+da3_b(index)-da1_b(index); %第i个人在系统逗留时间
  end
end

%% all
Wait_time=zeros(1,arr_num);
Cost_time=zeros(1,arr_num);
for i=1:arr_num
  Wait_time( i)=A_wait_time(i)+max(B_D_wait_time(i),B_D_wait_time_b(i));
  Cost_time( i)=A_cost_time(i)+max(B_D_cost_time(i),B_D_cost_time_b(i));
end
