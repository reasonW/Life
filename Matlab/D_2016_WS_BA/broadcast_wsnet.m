function [knows,speed,memC,rec]=broadcast_wsnet()
%%% ����N���ڵ㣬ÿ���ڵ���2K���ھӽڵ��������������ͼͨ���������������WSС������·
%%% ��̵õ��Ľ�ѵ���Ǳ���ר�ã�һ������ֻ��һ���ô���������
%% A ��������������������������ڽӾ���
disp('�ó������ɹ㲥ʱ��WSС������·��');
N=378;K=2;p=0.2;
if N==0
    N=input('�������������������нڵ������N��');
end
if K==0
K=input('��������������������ÿ���ڵ���ھӽڵ�ĸ�����һ��K��');
end
if p==0
p=input('����������������ĸ���p:');
end
if K>floor(N/2)
    disp('�����Kֵ���Ϸ�')
    return;
end
load B.mat;
A=B;
%% ������ʼ��
t_times=1;
t=40*t_times;%ʱ��
lever=1;%���ܸ�����ֵ
infomAttribute=0.5;    %��Ϣ��������Ϣ���ԣ�
infomAcceptance=unifrnd(0,1,1,N);%��Ϣ���ܶȣ��������ԣ�
% infomAcceptance=normrnd(0.5,1,1,N);%��Ϣ���ܶȣ��������ԣ�
% infomAcceptance=randn([1,N]);%��Ϣ���ܶȣ��������ԣ�
infomSignstimuli=zeros(1,N);%��Ϣ�ܸ�ֵ������ǿ���ӣ�
infomPubFlag=boolean(zeros(1,N));
infomRecFlag=boolean(zeros(1,N));
infomDeadFlag=boolean(zeros(1,N));

% B=A;
tmp=fix(N*rand(fix(N*0.6),1))+1;%%��ѡ���ӵ�
for i=1:length(tmp)
     infomRecFlag(tmp(i))=1;%%��ʾ�˵㴦�ڽ���״̬
     infomSignstimuli(tmp(i))=1;     
end
%% ��ʼ
% speed_=0;
knows=zeros(t,1);
speed=zeros(t,1);
memC=zeros(N,1);
rec=zeros(N,2,5);
for tim=1:t%����
%     input('������Y');
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
            if(infomSignstimuli(i)>=memC(i))%%���ڴ̼��������˷���ֵ            
               infomPubFlag(i)=1;%%���Է�����
            else
               infomPubFlag(i)=0; 
            end 
        else
               infomPubFlag(i)=0; 
        end
    end 
    speed(tim)=sum(infomPubFlag); 

    for i=1:N 
        if(infomPubFlag(i)==1 && infomDeadFlag(i)==0)%%���ڿ����⴫������
            for j=i+1:N
                if (infomDeadFlag(j)==0 && A(i,j)~=0 && B(i,j)<1+t_times && infomPubFlag(j)~=1)%%��ʾ�͵�һ����������ͨ·���ܽ���ͨ��
                    infomRecFlag(j)=1;%%��ʾ����㴦�ڽ���״̬
                    B(i,j)=B(i,j)+1;
                    infomSignstimuli(j)=infomSignstimuli(j)+double(1/t_times);%%��ʾ�˴δ����̼���һ
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
title('�����ٶ�')
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
title('��������')
    set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','YGrid','on',...
    'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
figure
x=1:N;
y=memC;
plot(x,y,'-','linewidth',2,'MarkerFaceColor','g','markersize',4);
title('��Ϣ���Էֲ�')
    set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','YGrid','on',...
    'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);