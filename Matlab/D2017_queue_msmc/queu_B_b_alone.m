%% ���B ���򵥷��񵥶���
 %%����һ�еķ���ʱ���Ƿ��Ӹ�ָ���ֲ�
t3=0.9*abs(exprnd(7.542,1,arr_num));
%st=exprnd(2.5,1,n); %����̨����ʱ��
bb1=a3; %ÿ���˵���ʱ��
bb2=zeros(1,arr_num); %ÿ���˿�ʼ���ܷ���ʱ��   -> events(3,:)
bb3=zeros(1,arr_num);%ÿ�����뿪ʱ��            -> events(4,:)
bb4=zeros(1,arr_num);% %��ʶλ��ʾ�����ϵͳ��ϵͳ�ڹ��еĹ˿���        -> events(5,:)
bb5=zeros(1,arr_num);% ��ʶλ�Ƿ���븴��

bb2(1)=bb1(1);%��1���˿�ʼ����ʱ��Ϊ����ʱ��
bb3(1)=bb2(1)+t3(1); %��1�����뿪ʱ��Ϊ����ʱ��
bb4(1)=1;%һ���˿�,��־λ��Ϊ1
aerfa=0.1;
bb5(1)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
%�����ϵͳ��ϵͳ�����г�Ա���Ϊ 1
member_B_ = [1];
bottleBb=zeros(1,10);
bottleBb(1)=0;
DeteBb=0;
DeteBb_t=[];
Pointer=1;

%% main loop
for i=2:arr_num
    number=sum(bb3(member_B_)>bb1(i));
      if number ==0
        bb2(i)=bb1(i);
        bb3(i)=bb1(i)+t3(i);
        bb4(i)=1;
        bb5(i)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
        member_B_=[member_B_,i];
        bottleBb(rem(Pointer+1,10)+1)=bb2(i)-bb1(i);
          Pointer=Pointer+1;
      else len_B_mem_=length(member_B_);
        bb2(i)=bb3(member_B_(len_B_mem_));
        bb3(i)=bb3(member_B_(len_B_mem_))+t3(i);
        bb4(i)=number+1;
        bb5(i)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
        member_B_=[member_B_,i];
        bottleBb(rem(Pointer+1,10)+1)=bb2(i)-bb1(i);
          Pointer=Pointer+1;
      end
    if (MODEL==1)
        if sum(bottleBb)/10>6.31*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteBb=DeteBb+1;
        DeteBb_t=[DeteBb_t,sum(bottleBb)/10];
        end
    else
        if sum(bottleBb)/10>5.27*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteBb=DeteBb+1;
        DeteBb_t=[DeteBb_t,sum(bottleBb)/10];
        end
    end
end
%% ����ʱ����뿪ʱ��
%�������ʱ������ϵͳ���ܹ˿���
len_B_mem_ = length(member_B_);
%*****************************************
%������
%*****************************************
%�����ڷ���ʱ���ڣ�����ϵͳ�����й˿͵ĵ���ʱ�̺���
%��ʱ������ͼ��stairs�����ƶ�ά����ͼ��
% figure;
% stairs([0 bb1(member_B_)],0:len_B_mem_,'o-','linewidth',1, 'MarkerFaceColor','g','markersize',2);
% hold on;
% stairs([0 bb3(member_B_)],0:len_B_mem_,'o-','linewidth',1, 'MarkerFaceColor','y','markersize',2);
% legend('B_b arriving time','B_b leaving time');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% hold off;
% grid on;

%% ���˶���ʱ��͵ȴ�ʱ��
%�����ڷ���ʱ���ڣ�����ϵͳ�����й˿͵�ͣ��ʱ��͵�
%��ʱ������ͼ��plot�����ƶ�ά����ͼ��
B_cost_time_b=zeros(1,len_B_mem_); %��¼ÿ������ϵͳ����ʱ��
B_wait_time_b=zeros(1,len_B_mem_); %��¼ÿ������ϵͳ�ȴ�ʱ��
for i=1:len_B_mem_
  B_cost_time_b(i)=bb3(i)-bb1(i); %��i������ϵͳ����ʱ��
  B_wait_time_b(i)=bb2(i)-bb1(i); %��i������ϵͳ�ȴ�ʱ��
end
% figure;
% plot(1:len_B_mem_,B_cost_time_(member_B_),'-', 1: len_B_mem_,B_wait_time_b(member_B_),'-');
% legend('B_b cost time ','B_b waiting time ');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% grid on;

%% x_���
% T3=bb3(len_B_mem_);%��ʱ��
% p3=sum(t3(member_B_))/T3; %������
% avert3=sum(B_wait_time_b(member_B_))/len_B_mem_;%ÿ����ϵͳƽ������ʱ��
% fprintf('B_b averager cost time%6.2fs\n',avert3);
% fprintf('B_b system working intensity%6.3f\n',p3);

%% D ������
da1_b=zeros(1,sum(bb5));
index_=find(bb5==1);
for i=1:sum(bb5)
    da1_b(i)=bb3(index_(i));
end


