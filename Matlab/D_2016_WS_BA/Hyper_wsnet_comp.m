function [y1,y2,knows1,speed1,memC]=Hyper_wsnet_comp()
%%% ����N���ڵ㣬ÿ���ڵ���2K���ھӽڵ��������������ͼͨ���������������WSС������·
%% A ��������������������������ڽӾ���
disp('�ó������ɱ�ֽʱ��WSС������·��');
N=214;K=2;p=0.2;
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
load H.mat;

%% ������ʼ��
t_times=1;
t=40*t_times;%ʱ��
lever=0.5;%���ܸ�����ֵ
infomAttribute=0.5;    %��Ϣ��������Ϣ���ԣ�
infomAcceptance=unifrnd(0,1,1,N);%��Ϣ���ܶȣ��������ԣ�
% infomAcceptance=normrnd(0.5,1,1,N);%��Ϣ���ܶȣ��������ԣ�
% infomAcceptance=randn([1,N]);%��Ϣ���ܶȣ��������ԣ�

%%%%
%% ��ʼ��ֽ
%%%%
    B=A;
    infomSignstimuli=zeros(1,N);%��Ϣ�ܸ�ֵ������ǿ���ӣ�
    infomPubFlag=zeros(1,N);
    infomRecFlag=zeros(1,N);
    infomDeadFlag=boolean(zeros(1,N));
    tmp=fix(N*rand(fix(N/10),1))+1;%%��ѡ���ӵ�
    for i=1:length(tmp)
         infomRecFlag(tmp(i))=1;%%��ʾ�˵㴦�ڽ���״̬
         infomSignstimuli(tmp(i))=1;
    end
    % speed_=0;
    knows1=zeros(t,1);
    speed1=zeros(t,1);
    memC=zeros(N,1);
    for tim=1:t%����
        if tim==1 || tim==2
            continue
        end
        for i=1:N 
            if infomRecFlag(i)==1 && infomDeadFlag(i)==0
                memC(i)=double((double(infomAttribute/infomAcceptance(i))-1)/lever)+1;
                if(infomSignstimuli(i) >=memC(i))%%���ڴ̼��������˷���ֵ            
                   infomPubFlag(i)=1;%%���Է�����
                end
            end
        end 
        speed1(tim)=sum(infomPubFlag);    
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
            if infomRecFlag(i)==0
                infomPubFlag(i)=0;
            end
        end
    end
%%%%
%% ��ʼ���ߵ�
%%%%
    B=A;
    infomSignstimuli=zeros(1,N);%��Ϣ�ܸ�ֵ������ǿ���ӣ�
    infomPubFlag=zeros(1,N);
    infomRecFlag=zeros(1,N);
    infomDeadFlag=boolean(zeros(1,N));
    tmp=fix(N*rand(fix(N*0.1),1))+1;%%��ѡ���ӵ�
    for i=1:length(tmp)
         infomRecFlag(tmp(i))=1;%%��ʾ�˵㴦�ڽ���״̬
         infomSignstimuli(tmp(i))=1;
    end
    % spe
    % speed_=0;
    knows2=zeros(t,1);
    speed2=zeros(t,1);
    memC=zeros(N,1);
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
        speed2(tim)=sum(infomPubFlag); 
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
%%%%
%% ��ʼ����
%%%%
    B=A;
    infomSignstimuli=zeros(1,N);%��Ϣ�ܸ�ֵ������ǿ���ӣ�
    infomPubFlag=zeros(1,N);
    infomRecFlag=zeros(1,N);
    infomDeadFlag=boolean(zeros(1,N));
    tmp=fix(N*rand(fix(N*0.1),1))+1;%%��ѡ���ӵ�
    for i=1:length(tmp)
         infomRecFlag(tmp(i))=1;%%��ʾ�˵㴦�ڽ���״̬
         infomSignstimuli(tmp(i))=1;
    end
    % speed_=0;
    knows3=zeros(t,1);
    speed3=zeros(t,1);
    memC=zeros(N,1);
    for tim=1:t%����
    %     input('������Y');
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
                if(infomSignstimuli(i)>=memC(i))%%���ڴ̼��������˷���ֵ            
                   infomPubFlag(i)=1;%%���Է�����
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
 %% ��ͼ   
    x=1:t;
    y1(:,1)=speed1;y1(:,2)=speed2;y1(:,3)=speed3;
    for i=1:t
        knows1(i)=sum(speed1(1:i));knows2(i)=sum(speed2(1:i)); knows3(i)=sum(speed3(1:i));
    end
    y2(:,1)=knows1;y2(:,2)=knows2;y2(:,3)=knows3;
    plot(x,y1,'o-','markersize',4);
    legend('Newspaper','Broadcast','Television'),title('�����ٶ�')
    set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','YGrid','on',...
    'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
    figure
    plot(x,y2,'o-','markersize',4);
    legend('Newspaper','Broadcast','Television'),title('��������')
    set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','YGrid','on',...
    'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
