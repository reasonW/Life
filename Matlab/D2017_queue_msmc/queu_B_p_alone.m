%% ���B ���򵥷��񵥶���
 t2=zeros(1,47);state_b_b=zeros(1,arr_num);
tmp_a_b=normrnd(232.39,143.94,1,arr_num+1);
tmp_a_b=sort(abs(tmp_a_b));
for i=1:arr_num
    if(MODEL==1)
        t2(i)=(tmp_a_b(i+1)-tmp_a_b(i))*1/3.7;% pre check
    else
        t2(i)=1*(tmp_a_b(i+1)-tmp_a_b(i))*1;% Regular
    end
 end

%st=exprnd(2.5,1,n); %����̨����ʱ��
b1=a3; %ÿ���˵���ʱ��
b2=zeros(1,arr_num); %ÿ���˿�ʼ���ܷ���ʱ��   -> events(3,:)
b3=zeros(1,arr_num);%ÿ�����뿪ʱ��            -> events(4,:)
b4=zeros(1,arr_num);% %��ʶλ��ʾ�����ϵͳ��ϵͳ�ڹ��еĹ˿���        -> events(5,:)
b5=zeros(1,arr_num);% ��ʶλ�Ƿ���븴��

b2(1)=b1(1);%��1���˿�ʼ����ʱ��Ϊ����ʱ��
b3(1)=b2(1)+t2(1); %��1�����뿪ʱ��Ϊ����ʱ��
b4(1)=1;%һ���˿�,��־λ��Ϊ1
aerfa=0.1;
b5(1)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
%�����ϵͳ��ϵͳ�����г�Ա���Ϊ 1
member_B = [1];
bottleB=zeros(1,10);
bottleB(1)=0;
DeteB=0;
DeteB_t=[];
Pointer=1;

for i=2:arr_num
    number=sum(b3(member_B)>b1(i));
      if number ==0
        b2(i)=b1(i);
        b3(i)=b1(i)+t2(i);
        b4(i)=1;
        b5(i)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
        member_B=[member_B,i];
        bottleB(rem(Pointer+1,10)+1)=b2(i)-b1(i);
          Pointer=Pointer+1;
      else len_B_mem=length(member_B);
        b2(i)=b3(member_B(len_B_mem));
        b3(i)=b3(member_B(len_B_mem))+t2(i);
        b4(i)=number+1;
        b5(i)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
        member_B=[member_B,i];
        bottleB(rem(Pointer+1,10)+1)=b2(i)-b1(i);
          Pointer=Pointer+1;
      end
    if (MODEL==1)
        if sum(bottleB)/10>1.65*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteB=DeteB+1;
        DeteB_t=[DeteB_t sum(bottleB)/10];
        end
    else
        if sum(bottleB)/10>8.75*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteB=DeteB+1;
        DeteB_t=[DeteB_t sum(bottleB)/10];
        end
    end
end
%% ����ʱ����뿪ʱ��
%�������ʱ������ϵͳ���ܹ˿���
len_B_mem = length(member_B);
%*****************************************
%������
%*****************************************
%�����ڷ���ʱ���ڣ�����ϵͳ�����й˿͵ĵ���ʱ�̺���
%��ʱ������ͼ��stairs�����ƶ�ά����ͼ��
% figure;
% stairs([0 ba1(member_B)],0:len_B_mem,'o-','linewidth',1, 'MarkerFaceColor','g','markersize',2);
% hold on;
% stairs([0 ba3(member_B)],0:len_B_mem,'o-','linewidth',1, 'MarkerFaceColor','y','markersize',2);
% legend('B_p arriving time','B_p leaving time');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% hold off;
% grid on;

%% ���˶���ʱ��͵ȴ�ʱ��
%�����ڷ���ʱ���ڣ�����ϵͳ�����й˿͵�ͣ��ʱ��͵�
%��ʱ������ͼ��plot�����ƶ�ά����ͼ��
B_cost_time=zeros(1,len_B_mem); %��¼ÿ������ϵͳ����ʱ��
B_wait_time=zeros(1,len_B_mem); %��¼ÿ������ϵͳ�ȴ�ʱ��
for i=1:len_B_mem
  B_cost_time(i)=b3(i)-b1(i); %��i������ϵͳ����ʱ��
  B_wait_time(i)=b2(i)-b1(i); %��i������ϵͳ�ȴ�ʱ��
end
% figure;
% plot(1:len_B_mem,B_cost_time(member_B),'-', 1: len_B_mem,B_wait_time(member_B),'-');
% legend('B_p cost time ','B_p waiting time ');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% grid on;

%% x_���
% T2=b3(len_B_mem)%��ʱ��
% p2=sum(t2(member_B))/T2 %������
% avert2=sum(B_wait_time(member_B))/len_B_mem;%ÿ����ϵͳƽ������ʱ��
% fprintf('B_p averager cost time%6.2fs\n',avert2);
% fprintf('B_p system working intensity%6.3f\n',p2);

%% D ������
da1=zeros(1,sum(b5));
index=find(b5==1);
for i=1:sum(b5)
    da1(i)=b3(index(i));
end


