function [speed,matrix]=Communicatie_wsnet()
%%% ����N���ڵ㣬ÿ���ڵ���2K���ھӽڵ��������������ͼͨ���������������WSС������·
%%% ��̵õ��Ľ�ѵ���Ǳ���ר�ã�һ������ֻ��һ���ô���������
%% A �D�D�D�D�D�D��������������ڽӾ���
disp('�ó�������WSС������·��');
N=150;K=2;p=0.2;
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
load C.mat;
%% ������ʼ��
t_times=1;
t=200*t_times;%ʱ��
speed=zeros(1,t);
matrix=zeros(t,N);
% Com_convergence=zeros(1,N)+0.5; %�������Ӧ�0.5
% Com_convergence=unifrnd(0,1,1,N);% �������Ӧ̾��ȷֲ� �ֲ���ͬ��Ӱ����Ϣ�ۼ�
R=randn(1,N);
Com_convergence=exp(-R.^2/2)/sqrt(2*pi);%�������Ӧ̱�׼��̬�ֲ�
% Com_threshold=unifrnd(0,1,1,N);%��ֵ�� 
Com_threshold=zeros(1,N)+0.5;   %��ֵ��Խ����Ϣ�ۼ���Խ��
Com_opinion=unifrnd(0,1,1,N);%�۵�ֲ����ȷֲ�,rand��׼���ȷֲ�
% Com_opinion=poissrnd(70,[1,N])/100;%�۵�ֲ����ɷֲ�ƫ�ֲ���
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
Com_opinion(find(tmp_degree==max(tmp_degree)))=0.3;%% �����ĵ�
%% ִ�в���
for tim=1:t%����
    for i=1:N
        tmp=1000000;
        for j=i+1:N
          if (A(i,j)~=0)%%��ʾ�͵�һ����������ͨ·���ܽ���ͨ��
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
%     sprintf('{��=0.5,��=0.5 }'));
% set(hText, 'FontName', 'AvantGarde')
% set(hText, 'FontSize', 10)
set(gca,'Box','off','TickDir','out','TickLength',[.02 .02],...
'XMinorTick','on','YMinorTick','on',...
'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1)
