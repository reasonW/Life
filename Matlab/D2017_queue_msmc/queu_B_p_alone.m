%% 这个B 区域单服务单队列
 t2=zeros(1,47);state_b_b=zeros(1,arr_num);
tmp_a_b=normrnd(232.39,143.94,1,arr_num+1);
tmp_a_b=sort(abs(tmp_a_b));
for i=1:arr_num
    if(MODEL==1)
        t2(i)=(tmp_a_b(i+1)-tmp_a_b(i))*1/3.7;% pre check
    else
        t2(i)=1*(tmp_a_b(i+1)-tmp_a_b(i))*1;% Regular
    end
 end

%st=exprnd(2.5,1,n); %服务台服务时间
b1=a3; %每个人到达时间
b2=zeros(1,arr_num); %每个人开始接受服务时间   -> events(3,:)
b3=zeros(1,arr_num);%每个人离开时间            -> events(4,:)
b4=zeros(1,arr_num);% %标识位表示其进入系统后，系统内共有的顾客数        -> events(5,:)
b5=zeros(1,arr_num);% 标识位是否进入复查

b2(1)=b1(1);%第1个人开始服务时间为到达时间
b3(1)=b2(1)+t2(1); %第1个人离开时间为服务时间
b4(1)=1;%一个顾客,标志位置为1
aerfa=0.1;
b5(1)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
%其进入系统后，系统内已有成员序号为 1
member_B = [1];
bottleB=zeros(1,10);
bottleB(1)=0;
DeteB=0;
DeteB_t=[];
Pointer=1;

for i=2:arr_num
    number=sum(b3(member_B)>b1(i));
      if number ==0
        b2(i)=b1(i);
        b3(i)=b1(i)+t2(i);
        b4(i)=1;
        b5(i)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
        member_B=[member_B,i];
        bottleB(rem(Pointer+1,10)+1)=b2(i)-b1(i);
          Pointer=Pointer+1;
      else len_B_mem=length(member_B);
        b2(i)=b3(member_B(len_B_mem));
        b3(i)=b3(member_B(len_B_mem))+t2(i);
        b4(i)=number+1;
        b5(i)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
        member_B=[member_B,i];
        bottleB(rem(Pointer+1,10)+1)=b2(i)-b1(i);
          Pointer=Pointer+1;
      end
    if (MODEL==1)
        if sum(bottleB)/10>1.65*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteB=DeteB+1;
        DeteB_t=[DeteB_t sum(bottleB)/10];
        end
    else
        if sum(bottleB)/10>8.75*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteB=DeteB+1;
        DeteB_t=[DeteB_t sum(bottleB)/10];
        end
    end
end
%% 到达时间和离开时间
%仿真结束时，进入系统的总顾客数
len_B_mem = length(member_B);
%*****************************************
%输出结果
%*****************************************
%绘制在仿真时间内，进入系统的所有顾客的到达时刻和离
%开时刻曲线图（stairs：绘制二维阶梯图）
% figure;
% stairs([0 ba1(member_B)],0:len_B_mem,'o-','linewidth',1, 'MarkerFaceColor','g','markersize',2);
% hold on;
% stairs([0 ba3(member_B)],0:len_B_mem,'o-','linewidth',1, 'MarkerFaceColor','y','markersize',2);
% legend('B_p arriving time','B_p leaving time');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% hold off;
% grid on;

%% 个人逗留时间和等待时间
%绘制在仿真时间内，进入系统的所有顾客的停留时间和等
%待时间曲线图（plot：绘制二维线性图）
B_cost_time=zeros(1,len_B_mem); %记录每个人在系统逗留时间
B_wait_time=zeros(1,len_B_mem); %记录每个人在系统等待时间
for i=1:len_B_mem
  B_cost_time(i)=b3(i)-b1(i); %第i个人在系统逗留时间
  B_wait_time(i)=b2(i)-b1(i); %第i个人在系统等待时间
end
% figure;
% plot(1:len_B_mem,B_cost_time(member_B),'-', 1: len_B_mem,B_wait_time(member_B),'-');
% legend('B_p cost time ','B_p waiting time ');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% grid on;

%% x_输出
% T2=b3(len_B_mem)%总时间
% p2=sum(t2(member_B))/T2 %服务率
% avert2=sum(B_wait_time(member_B))/len_B_mem;%每个人系统平均逗留时间
% fprintf('B_p averager cost time%6.2fs\n',avert2);
% fprintf('B_p system working intensity%6.3f\n',p2);

%% D 区复查
da1=zeros(1,sum(b5));
index=find(b5==1);
for i=1:sum(b5)
    da1(i)=b3(index(i));
end


