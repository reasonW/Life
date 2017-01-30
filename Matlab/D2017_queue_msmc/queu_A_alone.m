%% 这个A 区域单服务单队列
 t1=1*randsrc(1,arr_num,[7.55 5.28 11.06 9.98 9.15 8.82 12.61 15.44 11.88]);
%st=exprnd(2.5,1,n); %服务台服务时间
a1=zeros(1,arr_num); %每个人到达时间
a2=zeros(1,arr_num); %每个人开始接受服务时间   -> events(3,:)
a3=zeros(1,arr_num);%每个人离开时间            -> events(4,:)
a4=zeros(1,arr_num);% %标识位表示其进入系统后，系统内共有的顾客数       -> events(5,:)
% for i=2:arr_num
%   a1(i)=a1(i-1)+dt(i-1);%第i个人到达时间  -> events(1,:)
% end
if(MODEL==1)% pre-check
    arr_time=arr_time2(1:arr_num);
else
    arr_time=arr_time1(1:arr_num);
end
Delay=unifrnd(0,5,1,arr_num);%观点分布均匀分布,rand标准均匀分布
Delay=zeros(1,arr_num);
% Delay=zeros(1,arr_num);
% a1=normrnd(273.964,165.70,1,arr_num);
a1=sort(abs(arr_time));

a2(1)=0;%第1个人开始服务时间为到达时间
a3(1)=a2(1)+t1(1); %第1个人离开时间为服务时间
a4(1)=1;%一个顾客,标志位置为1
%其进入系统后，系统内已有成员序号为 1
member_A = [1];
bottleA=zeros(1,10);
bottleA(1)=0;
DeteA=0;
DeteA_t=[ ];
Pointer=1;
for i=2:arr_num

    number=sum(a3(member_A)>a1(i));
      if number ==0
        a2(i)=a1(i)++Delay(i);
        a3(i)=a2(i)+t1(i);
        a4(i)=1;
        member_A=[member_A,i];
        bottleA(rem(Pointer+1,10)+1)=a2(i)-a1(i);
          Pointer=Pointer+1;
      else len_A_mem=length(member_A);
        a2(i)=a3(member_A(len_A_mem)) +Delay(i);
        a3(i)=a2(i)+t1(i);
        a4(i)=number+1;
        member_A=[member_A,i];
        bottleA(rem(Pointer+1,10)+1)=a2(i)-a1(i);
          Pointer=Pointer+1;
        % if(a1(i)<=a3(i-1))
        %    a2(i)=a3(i-1);%如果第i个人到达时间比前一个人离开时间早,则其开始服务时间为前一人离开时间
        % else
        %    a2(i)=a1(i); %如果第i个人到达时间比前一个人离开时间晚,则其开始服务时间为到达时间.
        % end

        % a3(i)=a2(i)+t1(i);  %第i个人离开时间为其开始服务时间+接受服务时间
      end
    if (MODEL==1)
        if sum(bottleA)/10>11.27*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteA=DeteA+1;
        DeteA_t=[DeteA_t,sum(bottleA)/10];
        end
    else
        if sum(bottleA)/10>18.81*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteA=DeteA+1;
        DeteA_t=[DeteA_t,sum(bottleA)/10];
        end
    end
end
%% demo_绘图
%仿真结束时，进入系统的总顾客数
len_A_mem = length(member_A);
%*****************************************
%输出结果
%*****************************************
%绘制在仿真时间内，进入系统的所有顾客的到达时刻和离
%开时刻曲线图（stairs：绘制二维阶梯图）
% len_A_mem
% stairs([0 a1(member_A)],0:len_A_mem,'o-','linewidth',1, 'MarkerFaceColor','g','markersize',2);
% hold on;
% stairs([0 a3(member_A)],0:len_A_mem,'o-','linewidth',1, 'MarkerFaceColor','y','markersize',2);
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
% plot(1:len_A_mem,A_cost_time(member_A),'-', 1: len_A_mem,A_wait_time(member_A),'-');
% legend('A cost time ','A waiting time ');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% grid on;

%% 
%demo
% plot(x,y,'o-','linewidth',2, 'MarkerFaceColor','g','markersize',4);
% title('传播速度')
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
%% x_输出

% 
% T1=a3(len_A_mem)%总时间
% p1=sum(t1(member_A))/T1 %服务率
% avert1=sum(A_wait_time(member_A))/len_A_mem%每个人系统平均逗留时间
% fprintf('A passenager averager cost time%fs\n',avert1);
% fprintf('A system working intensity %f\n',p1);


