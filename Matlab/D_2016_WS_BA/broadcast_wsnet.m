function [knows,speed,memC,rec]=broadcast_wsnet()
%%% 从有N个节点，每个节点有2K个邻居节点的最近邻耦合网络图通过随机化重连生成WS小世界网路
%%% 编程得到的教训就是变量专用，一个变量只有一个用处，不复用
%% A ——————返回生成网络的邻接矩阵
disp('该程序生成广播时代WS小世界网路：');
N=378;K=2;p=0.2;
if N==0
    N=input('请输入最近邻耦合网络中节点的总数N：');
end
if K==0
K=input('请输入最近邻耦合网络中每个节点的邻居节点的个数的一半K：');
end
if p==0
p=input('请输入随机化重连的概率p:');
end
if K>floor(N/2)
    disp('输入的K值不合法')
    return;
end
load B.mat;
A=B;
%% 参数初始化
t_times=1;
t=40*t_times;%时间
lever=1;%社会杠杆作用值
infomAttribute=0.5;    %信息质量（信息属性）
infomAcceptance=unifrnd(0,1,1,N);%信息接受度（个体属性）
% infomAcceptance=normrnd(0.5,1,1,N);%信息接受度（个体属性）
% infomAcceptance=randn([1,N]);%信息接受度（个体属性）
infomSignstimuli=zeros(1,N);%信息杠杆值（社会加强因子）
infomPubFlag=boolean(zeros(1,N));
infomRecFlag=boolean(zeros(1,N));
infomDeadFlag=boolean(zeros(1,N));

% B=A;
tmp=fix(N*rand(fix(N*0.6),1))+1;%%挑选种子点
for i=1:length(tmp)
     infomRecFlag(tmp(i))=1;%%表示此点处于接收状态
     infomSignstimuli(tmp(i))=1;     
end
%% 开始
% speed_=0;
knows=zeros(t,1);
speed=zeros(t,1);
memC=zeros(N,1);
rec=zeros(N,2,5);
for tim=1:t%步数
%     input('请输入Y');
    if  tim==3
        infomSignstimuli=infomSignstimuli+1;
    end
    if  mod(tim,3)==0
        for i=1:length(tmp)
            infomSignstimuli(tmp(i))=infomSignstimuli(tmp(i))+1; 
        end
    end    
    for i=1:N 
        if infomRecFlag(i)==1 && infomDeadFlag(i)==0
            memC(i)=double((double(infomAttribute/infomAcceptance(i))-1)/lever)+1;
            if(infomSignstimuli(i)>=memC(i))%%对于刺激超过了兴奋阈值            
               infomPubFlag(i)=1;%%可以发出了
            else
               infomPubFlag(i)=0; 
            end 
        else
               infomPubFlag(i)=0; 
        end
    end 
    speed(tim)=sum(infomPubFlag); 

    for i=1:N 
        if(infomPubFlag(i)==1 && infomDeadFlag(i)==0)%%对于可向外传播的人
            for j=i+1:N
                if (infomDeadFlag(j)==0 && A(i,j)~=0 && B(i,j)<1+t_times && infomPubFlag(j)~=1)%%表示和第一级传播者有通路，能进行通信
                    infomRecFlag(j)=1;%%表示这个点处于接收状态
                    B(i,j)=B(i,j)+1;
                    infomSignstimuli(j)=infomSignstimuli(j)+double(1/t_times);%%表示此次传播刺激加一
                end
            end
           infomRecFlag(i)=0;
           infomDeadFlag(i)=1;
        end
    end
end
x=1:t;
y=speed;
figure
plot(x,y,'o-','linewidth',2, 'MarkerFaceColor','g','markersize',4);
title('传播速度')
    set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','YGrid','on',...
    'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
for i=1:t
    knows(i)=sum(speed(1:i));
end
figure
x=1:t;
y=knows;
plot(x,y,'o-',...
'color',[244 208 0]/255,...
'linewidth',2,'MarkerSize',5,'MarkerEdgecolor',[138 151 123]/255);
title('传播人数')
    set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','YGrid','on',...
    'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
figure
x=1:N;
y=memC;
plot(x,y,'-','linewidth',2,'MarkerFaceColor','g','markersize',4);
title('信息属性分布')
    set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','YGrid','on',...
    'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);