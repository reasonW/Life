t4=randsrc(1,length(da1),[7.55 5.28 11.06 9.98 9.15 8.82 12.61 15.44 11.88]);%          -> events(2,:)

%st=exprnd(2.5,1,n); %����̨����ʱ��
da2=zeros(1,length(da1)); %ÿ���˿�ʼ���ܷ���ʱ��   -> events(3,:)
da3=zeros(1,length(da1));%ÿ�����뿪ʱ��            -> events(4,:)
da4=zeros(1,length(da1));% %��ʶλ��ʾ�����ϵͳ��ϵͳ�ڹ��еĹ˿���        -> events(5,:)
da5=zeros(1,length(da1));% ��ʶλ�Ƿ���븴��

da2(1)=da1(1);%��1���˿�ʼ����ʱ��Ϊ����ʱ��
da3(1)=da2(1)+t4(1); %��1�����뿪ʱ��Ϊ����ʱ��
da4(1)=1;%һ���˿�,��־λ��Ϊ1
aerfa=0.1;
da5(1)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
%�����ϵͳ��ϵͳ�����г�Ա���Ϊ 1
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
        %    a2(i)=a3(i-1);%�����i���˵���ʱ���ǰһ�����뿪ʱ����,���俪ʼ����ʱ��Ϊǰһ���뿪ʱ��
        % else
        %    a2(i)=a1(i); %�����i���˵���ʱ���ǰһ�����뿪ʱ����,���俪ʼ����ʱ��Ϊ����ʱ��.
        % end

        % a3(i)=a2(i)+t1(i);  %��i�����뿪ʱ��Ϊ�俪ʼ����ʱ��+���ܷ���ʱ��
      end
end
%% ����ʱ����뿪ʱ��
%�������ʱ������ϵͳ���ܹ˿���
len_D_mem = length(member_D);
%*****************************************
%������
%*****************************************
%�����ڷ���ʱ���ڣ�����ϵͳ�����й˿͵ĵ���ʱ�̺���
%��ʱ������ͼ��stairs�����ƶ�ά����ͼ��
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

%% ���˶���ʱ��͵ȴ�ʱ��
%�����ڷ���ʱ���ڣ�����ϵͳ�����й˿͵�ͣ��ʱ��͵�
%��ʱ������ͼ��plot�����ƶ�ά����ͼ��
D_cost_time=zeros(1,len_D_mem); %��¼ÿ������ϵͳ����ʱ��
D_wait_time=zeros(1,len_D_mem); %��¼ÿ������ϵͳ�ȴ�ʱ��
for i=1:len_D_mem
    D_wait_time(i)=da2(i)-da1(i); %��i������ϵͳ�ȴ�ʱ��
    D_cost_time(i)=da3(i)-da1(i); %��i������ϵͳ����ʱ��
end
% figure;
% plot(1:len_D_mem,D_cost_time(member_D),'-', 1: len_D_mem,D_wait_time(member_D),'-');
% legend('D_p cost time ','D_p waiting time ');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% grid on;

%% x_���
T4=da3(len_D_mem)%��ʱ��
p4=sum(t4(member_D))/T4 %������
avert4=sum(D_wait_time(member_D))/len_D_mem;%ÿ����ϵͳƽ������ʱ��
fprintf('D_p averager cost time%6.2fs\n\n',avert4);
fprintf('D_p system working intensity%6.3f\n',p4);

%% B 
B_D_cost_time=B_cost_time; %��¼ÿ������ϵͳ����ʱ��
B_D_wait_time=B_wait_time; %��¼ÿ������ϵͳ�ȴ�ʱ��

for i=1:arr_num_b
  if sum(find(da1==b3(i)))~=0
      index=find(da1==b3(i));
      B_D_wait_time(i)=B_D_wait_time(i)+da2(index)-da1(index); %��i������ϵͳ�ȴ�ʱ��
      B_D_cost_time(i)=B_D_cost_time(i)+da3(index)-da1(index); %��i������ϵͳ����ʱ��
  end
end
