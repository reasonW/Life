%% ���D ���򵥷��񵥶���
sdata_d=randsrc(1,length(da1_b),[7.55 5.28 11.06 9.98 9.15 8.82 12.61 15.44 11.88]);
da2_b=zeros(1,length(da1_b)); %ÿ���˿�ʼ���ܷ���ʱ��   -> events(3,:)
da3_b=zeros(1,length(da1_b));%ÿ�����뿪ʱ��            -> events(4,:)
da4_b=zeros(1,length(da1_b));% %��ʶλ��ʾ�����ϵͳ��ϵͳ�ڹ��еĹ˿���        -> events(5,:)

da2_b(1)=da1_b(1);%��1���˿�ʼ����ʱ��Ϊ����ʱ��
da3_b(1)=da2_b(1)+sdata_d(1); %��1�����뿪ʱ��Ϊ����ʱ��+����ʱ��
da4_b(1)=1;%һ���˿�,��־λ��Ϊ1
%�����ϵͳ��ϵͳ�����г�Ա���Ϊ 1
member_D_b = [1];
bottleCb=zeros(1,10);
bottleCb(1)=0; 
DeteCb=0;
DeteCb_t=[];
Pointer=1;

for i=2:length(da1_b)
    number=sum(da3_b(member_D_b)>da1_b(i));
      if number ==0
        da2_b(i)=da1_b(i);
        da3_b(i)=da1_b(i)+sdata_d(i);
        da4_b(i)=1;
        member_D_b=[member_D_b,i];
        bottleCb(rem(Pointer+1,10)+1)=da2_b(i)-da1_b(i);
        Pointer=Pointer+1;
      else
        len_D_mem_b=length(member_D_b);
        da2_b(i)=da3_b(member_D_b(len_D_mem_b));
        da3_b(i)=da3_b(member_D_b(len_D_mem_b))+sdata_d(i);
        da4_b(i)=number+1;
        member_D_b=[member_D_b,i];
        bottleCb(rem(Pointer+1,10)+1)=da2_b(i)-da1_b(i);
        Pointer=Pointer+1;
      end
    if (MODEL==1)
        if sum(bottleCb)/10>1.65*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteCb=DeteCb+1;
        DeteCb_t=[DeteCb_t sum(bottleB)/10];
        end
    else
        if sum(bottleCb)/10>7.24*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteCb=DeteCb+1;
        DeteCb_t=[DeteCb_t sum(bottleB)/10];
        end
    end
end
%% ����ʱ����뿪ʱ��
%�������ʱ������ϵͳ���ܹ˿���
len_D_mem_b = length(member_D_b);
%*****************************************
%������
%*****************************************
%�����ڷ���ʱ���ڣ�����ϵͳ�����й˿͵ĵ���ʱ�̺���
%��ʱ������ͼ��stairs�����ƶ�ά����ͼ��
% figure;
% stairs(0:len_D_mem_b,[0 da1_b(member_D_b)],'o-','linewidth',1, 'MarkerFaceColor','g','markersize',2);
% hold on;
% stairs(0:len_D_mem_b,[0 da3_b(member_D_b)],'o-','linewidth',1, 'MarkerFaceColor','y','markersize',2);
% legend('D_b arriving time','D_b leaving time');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% hold off;
% grid on;

%% ���˶���ʱ��͵ȴ�ʱ��
%�����ڷ���ʱ���ڣ�����ϵͳ�����й˿͵�ͣ��ʱ��͵�
%��ʱ������ͼ��plot�����ƶ�ά����ͼ��
D_cost_time_b=zeros(1,len_D_mem_b); %��¼ÿ������ϵͳ����ʱ��
D_wait_time_b=zeros(1,len_D_mem_b); %��¼ÿ������ϵͳ�ȴ�ʱ��
for i=1:len_D_mem_b
    D_wait_time_b(i)=da2_b(i)-da1_b(i); %��i������ϵͳ�ȴ�ʱ��
    D_cost_time_b(i)=da3_b(i)-da1_b(i); %��i������ϵͳ����ʱ��
end
% figure;
% plot(1:len_D_mem_b,D_cost_time_b(member_D_b),'-', 1: len_D_mem_b,D_wait_time_b(member_D_b),'-');
% legend('D_b cost time ','D_b waiting time ');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% grid on;

%% x_���
% T4_b=da3_b(len_D_mem_b)%��ʱ��
% p4_b=sum(sdata_d(member_D_b))/T4_b %������
% avert4_b=sum(D_wait_time_b(member_D_b))/len_D_mem_b;%ÿ����ϵͳƽ������ʱ��
% fprintf('D_b averager cost time%6.2fs\n\n',avert4_b);
% fprintf('D_b system working intensity%6.3f\n',p4_b);

%% B_
%% B 
B_D_cost_time_b=B_cost_time_b; %��¼ÿ������ϵͳ����ʱ��
B_D_wait_time_b=B_wait_time_b; %��¼ÿ������ϵͳ�ȴ�ʱ��
for i=1:arr_num
  if sum(find(da1_b==b3(i)))~=0
      index=find(da1_b==b3(i));
      B_D_wait_time_b(i)=B_D_wait_time_b(i)+da2_b(index)-da1_b(index); %��i������ϵͳ�ȴ�ʱ��
      B_D_cost_time_b(i)=B_D_cost_time_b(i)+da3_b(index)-da1_b(index); %��i������ϵͳ����ʱ��
  end
end

% figure;
% plot(1:arr_num_b,B_D_cost_time_b,'-', 1: arr_num_b,B_D_wait_time_b,'-');
% legend('B_b cost time ','B_b waiting time ');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% grid on;

%% all
Wait_time=zeros(1,arr_num);
Cost_time=zeros(1,arr_num);
for i=1:arr_num
  Wait_time( i)=A_wait_time(i)+max(B_D_wait_time(i),B_D_wait_time_b(i));
  Cost_time( i)=A_cost_time(i)+max(B_D_cost_time(i),B_D_cost_time_b(i));
end