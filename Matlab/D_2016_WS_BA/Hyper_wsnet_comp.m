function [y1,y2,knows1,speed1,memC]=Hyper_wsnet_comp()
%%% 从有N个节点，每个节点有2K个邻居节点的最近邻耦合网络图通过随机化重连生成WS小世界网路
%% A ——————返回生成网络的邻接矩阵
disp('该程序生成报纸时代WS小世界网路：');
N=214;K=2;p=0.2;
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
load H.mat;

%% 参数初始化
t_times=1;
t=40*t_times;%时间
lever=0.5;%社会杠杆作用值
infomAttribute=0.5;    %信息质量（信息属性）
infomAcceptance=unifrnd(0,1,1,N);%信息接受度（个体属性）
% infomAcceptance=normrnd(0.5,1,1,N);%信息接受度（个体属性）
% infomAcceptance=randn([1,N]);%信息接受度（个体属性）

%%%%
%% 开始报纸
%%%%
    B=A;
    infomSignstimuli=zeros(1,N);%信息杠杆值（社会加强因子）
    infomPubFlag=zeros(1,N);
    infomRecFlag=zeros(1,N);
    infomDeadFlag=boolean(zeros(1,N));
    tmp=fix(N*rand(fix(N/10),1))+1;%%挑选种子点
    for i=1:length(tmp)
         infomRecFlag(tmp(i))=1;%%表示此点处于接收状态
         infomSignstimuli(tmp(i))=1;
    end
    % speed_=0;
    knows1=zeros(t,1);
    speed1=zeros(t,1);
    memC=zeros(N,1);
    for tim=1:t%步数
        if tim==1 || tim==2
            continue
        end
        for i=1:N 
            if infomRecFlag(i)==1 && infomDeadFlag(i)==0
                memC(i)=double((double(infomAttribute/infomAcceptance(i))-1)/lever)+1;
                if(infomSignstimuli(i) >=memC(i))%%对于刺激超过了兴奋阈值            
                   infomPubFlag(i)=1;%%可以发出了
                end
            end
        end 
        speed1(tim)=sum(infomPubFlag);    
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
            if infomRecFlag(i)==0
                infomPubFlag(i)=0;
            end
        end
    end
%%%%
%% 开始无线电
%%%%
    B=A;
    infomSignstimuli=zeros(1,N);%信息杠杆值（社会加强因子）
    infomPubFlag=zeros(1,N);
    infomRecFlag=zeros(1,N);
    infomDeadFlag=boolean(zeros(1,N));
    tmp=fix(N*rand(fix(N*0.1),1))+1;%%挑选种子点
    for i=1:length(tmp)
         infomRecFlag(tmp(i))=1;%%表示此点处于接收状态
         infomSignstimuli(tmp(i))=1;
    end
    % spe
    % speed_=0;
    knows2=zeros(t,1);
    speed2=zeros(t,1);
    memC=zeros(N,1);
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
        speed2(tim)=sum(infomPubFlag); 
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
%%%%
%% 开始电视
%%%%
    B=A;
    infomSignstimuli=zeros(1,N);%信息杠杆值（社会加强因子）
    infomPubFlag=zeros(1,N);
    infomRecFlag=zeros(1,N);
    infomDeadFlag=boolean(zeros(1,N));
    tmp=fix(N*rand(fix(N*0.1),1))+1;%%挑选种子点
    for i=1:length(tmp)
         infomRecFlag(tmp(i))=1;%%表示此点处于接收状态
         infomSignstimuli(tmp(i))=1;
    end
    % speed_=0;
    knows3=zeros(t,1);
    speed3=zeros(t,1);
    memC=zeros(N,1);
    for tim=1:t%步数
    %     input('请输入Y');
        if  tim==2
            infomSignstimuli=infomSignstimuli+1;
        end
        if  mod(tim,2)==0
            for i=1:length(tmp)
                infomSignstimuli(tmp(i))=infomSignstimuli(tmp(i))+1.5; 
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
        speed3(tim)=sum(infomPubFlag); 
    %     disp(speed);
    %     speed_=speed_+speed;
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
 %% 画图   
    x=1:t;
    y1(:,1)=speed1;y1(:,2)=speed2;y1(:,3)=speed3;
    for i=1:t
        knows1(i)=sum(speed1(1:i));knows2(i)=sum(speed2(1:i)); knows3(i)=sum(speed3(1:i));
    end
    y2(:,1)=knows1;y2(:,2)=knows2;y2(:,3)=knows3;
    plot(x,y1,'o-','markersize',4);
    legend('Newspaper','Broadcast','Television'),title('传播速度')
    set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','YGrid','on',...
    'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
    figure
    plot(x,y2,'o-','markersize',4);
    legend('Newspaper','Broadcast','Television'),title('传播人数')
    set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','YGrid','on',...
    'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
