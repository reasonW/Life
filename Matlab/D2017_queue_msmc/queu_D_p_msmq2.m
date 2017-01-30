%% ���D ���򵥷��񵥶���

sdata_d=randsrc(1,length(da1),[7.55 5.28 11.06 9.98 9.15 8.82 12.61 15.44 11.88]);

da2=zeros(1,length(da1)); %ÿ���˿�ʼ���ܷ���ʱ��   -> events(3,:)
da3=zeros(1,length(da1));%ÿ�����뿪ʱ��            -> events(4,:)
da4=zeros(1,length(da1));% %��ʶλ��ʾ�����ϵͳ��ϵͳ�ڹ��еĹ˿���        -> events(5,:)

da2(1)=da1(1);%��1���˿�ʼ����ʱ��Ϊ����ʱ��
da3(1)=da2(1)+sdata_d(1); %��1�����뿪ʱ��Ϊ����ʱ��+����ʱ��
da4(1)=1;%һ���˿�,��־λ��Ϊ1
%�����ϵͳ��ϵͳ�����г�Ա���Ϊ 1
member_D = [1];
bottleC=zeros(1,10);
bottleC(1)=0; 
DeteC=0;
DeteC_t=[];
Pointer=1;

for i=2:length(da1)
    number=sum(da3(member_D)>da1(i));
      if number ==0
        da2(i)=da1(i);
        da3(i)=da1(i)+sdata_d(i);
        da4(i)=1;
        member_D=[member_D,i];
        bottleC(rem(Pointer+1,10)+1)=da2(i)-da1(i);
        Pointer=Pointer+1;
      else
        len_D_mem=length(member_D);
        da2(i)=da3(member_D(len_D_mem));
        da3(i)=da3(member_D(len_D_mem))+sdata_d(i);
        da4(i)=number+1;
        member_D=[member_D,i];
        bottleC(rem(Pointer+1,10)+1)=da2(i)-da1(i);
        Pointer=Pointer+1;
      end
    if (MODEL==1)
        if sum(bottleC)/10>1.65*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteC=DeteC+1;
        DeteC_t=[DeteC_t sum(bottleB)/10];
        end
    else
        if sum(bottleC)/10>7.24*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteC=DeteC+1;
        DeteC_t=[DeteC_t sum(bottleB)/10];
        end
    end
end
%% ����ʱ����뿪ʱ��
%�������ʱ������ϵͳ���ܹ˿���
len_D_mem = length(member_D);
%*****************************************
%������
%*****************************************
%�����ڷ���ʱ���ڣ�����ϵͳ�����й˿͵ĵ���ʱ�̺���
% %��ʱ������ͼ��stairs�����ƶ�ά����ͼ��
% figure;
% stairs(0:len_D_mem,[0 da1(member_D)],'o-','linewidth',1, 'MarkerFaceColor','g','markersize',2);
% hold on;
% stairs(0:len_D_mem,[0 da3(member_D)],'o-','linewidth',1, 'MarkerFaceColor','y','markersize',2);
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
% T4=da3(len_D_mem)%��ʱ��
% p4=sum(sdata_d(member_D))/T4 %������
% avert4=sum(D_wait_time(member_D))/len_D_mem;%ÿ����ϵͳƽ������ʱ��
% fprintf('D_p averager cost time%6.2fs\n\n',avert4);
% fprintf('D_p system working intensity%6.3f\n',p4);

%% B 
B_D_cost_time=B_cost_time; %��¼ÿ������ϵͳ����ʱ��
B_D_wait_time=B_wait_time; %��¼ÿ������ϵͳ�ȴ�ʱ��

for i=1:arr_num
  if sum(find(da1==b3(i)))~=0
      index=find(da1==b3(i));
      B_D_wait_time(i)=B_D_wait_time(i)+da2(index)-da1(index); %��i������ϵͳ�ȴ�ʱ��
      B_D_cost_time(i)=B_D_cost_time(i)+da3(index)-da1(index); %��i������ϵͳ����ʱ��
  end
end

% figure;
% plot(1:arr_num_b,B_D_cost_time,'-', 1: arr_num_b,B_D_wait_time,'-');
% legend('B_p cost time ','B_p waiting time ');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% grid on;
