function [speed,matrix]=Communicatie_wsnet()
%%% 从有N个节点，每个节点有2K个邻居节点的最近邻耦合网络图通过随机化重连生成WS小世界网路
%%% 编程得到的教训就是变量专用，一个变量只有一个用处，不复用
%% A ――――――返回生成网络的邻接矩阵
disp('该程序生成WS小世界网路：');
N=150;K=2;p=0.2;
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
load C.mat;
%% 参数初始化
t_times=1;
t=200*t_times;%时间
speed=zeros(1,t);
matrix=zeros(t,N);
% Com_convergence=zeros(1,N)+0.5; %收敛因子μ0.5
% Com_convergence=unifrnd(0,1,1,N);% 收敛因子μ均匀分布 分布不同，影响信息聚集
R=randn(1,N);
Com_convergence=exp(-R.^2/2)/sqrt(2*pi);%收敛因子μ标准正态分布
% Com_threshold=unifrnd(0,1,1,N);%阈值ε 
Com_threshold=zeros(1,N)+0.5;   %阈值ε越大信息聚集度越高
Com_opinion=unifrnd(0,1,1,N);%观点分布均匀分布,rand标准均匀分布
% Com_opinion=poissrnd(70,[1,N])/100;%观点分布泊松分布偏分布，
tmp_degree=zeros(1,N);
for i=1:N
    tmp_d_=0;
    for j=1:N
        if A(i,j)~=0
            tmp_d_=tmp_d_+1;
        end
    end
    tmp_degree(i)=tmp_d_;
end
Com_opinion(find(tmp_degree==max(tmp_degree)))=0.3;%% 度最大的点
%% 执行步数
for tim=1:t%步数
    for i=1:N
        tmp=1000000;
        for j=i+1:N
          if (A(i,j)~=0)%%表示和第一级传播者有通路，能进行通信
            if abs(tmp)>abs(Com_opinion(i)-Com_opinion(j));
              tmp=Com_opinion(j)-Com_opinion(i);
            end
          end
        end
        if abs(tmp)<Com_threshold(i)
          Com_opinion(i)=Com_opinion(i)+Com_convergence(i)*tmp;
        end
    end
    speed(tim)=var(Com_opinion);
    matrix(tim,:)=Com_opinion;
end
x=1:t;
y=speed;
plot(x,y,'ro','markersize',4);
plot(matrix,'DisplayName','matrix')
xlabel('Time'),title('Information trans')
% hText = text(160, 0.8, ...
%     sprintf('{μ=0.5,ε=0.5 }'));
% set(hText, 'FontName', 'AvantGarde')
% set(hText, 'FontSize', 10)
set(gca,'Box','off','TickDir','out','TickLength',[.02 .02],...
'XMinorTick','on','YMinorTick','on',...
'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1)
