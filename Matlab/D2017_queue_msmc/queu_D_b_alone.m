%% ���D ���򵥷��񵥶���
db1=da1_b;
t5=randsrc(1,length(da1_b),[7.55 5.28 11.06 9.98 9.15 8.82 12.61 15.44 11.88]);
%st=exprnd(2.5,1,n); %����̨����ʱ��
db2=zeros(1,length(da1_b)); %ÿ���˿�ʼ���ܷ���ʱ��   -> events(3,:)
db3=zeros(1,length(da1_b));%ÿ�����뿪ʱ��            -> events(4,:)
db4=zeros(1,length(da1_b));% %��ʶλ��ʾ�����ϵͳ��ϵͳ�ڹ��еĹ˿���        -> events(5,:)
db5=zeros(1,length(da1_b));% ��ʶλ�Ƿ���븴��

db2(1)=bb1(1);%��1���˿�ʼ����ʱ��Ϊ����ʱ��
db3(1)=db2(1)+t5(1); %��1�����뿪ʱ��Ϊ����ʱ��
db4(1)=1;%һ���˿�,��־λ��Ϊ1
aerfa=0.1;
db5(1)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
%�����ϵͳ��ϵͳ�����г�Ա���Ϊ 1
member_D_b = [1];

for i=2:length(db1)

    number=sum(db3(member_D_b)>db1(i));
      if number ==0
        db2(i)=db1(i);
        db3(i)=db1(i)+t5(i);
        db4(i)=1;
        db5(i)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
        member_D_b=[member_D_b,i];
      else len_D_mem_b=length(member_D_b);
        db2(i)=db3(member_D_b(len_D_mem_b));
        db3(i)=db3(member_D_b(len_D_mem_b))+t5(i);
        db4(i)=number+1;
        db5(i)=randsrc(1,1,[0 1;aerfa 1-aerfa]);
        member_D_b=[member_D_b,i];

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
len_D_mem_b = length(member_D_b);
%*****************************************
%������
%*****************************************
%�����ڷ���ʱ���ڣ�����ϵͳ�����й˿͵ĵ���ʱ�̺���
%��ʱ������ͼ��stairs�����ƶ�ά����ͼ��
% figure;
% stairs([0 db1(member_D_b)],0:len_D_mem_b,'o-','linewidth',1, 'MarkerFaceColor','g','markersize',2);
% hold on;
% stairs([0 db3(member_D_b)],0:len_D_mem_b,'o-','linewidth',1, 'MarkerFaceColor','y','markersize',2);
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
    D_wait_time_b(i)=db2(i)-db1(i); %��i������ϵͳ�ȴ�ʱ��
    D_cost_time_b(i)=db3(i)-db1(i); %��i������ϵͳ����ʱ��
end
% figure;
% plot(1:len_D_mem_,D_cost_time_b(member_D_),'-', 1: len_D_mem_,D_wait_time_b(member_D_),'-');
% legend('D_b cost time ','D_b waiting time ');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% grid on;

%% x_���
T5=db3(len_D_mem_b)%��ʱ��
p5=sum(t5(member_D_b))/T5 %������
avert5=sum(D_wait_time_b(member_D_b))/len_D_mem_b;%ÿ����ϵͳƽ������ʱ��
fprintf('D_b averager cost time%6.2fs\n\n',avert5);
fprintf('D_b system working intensity%6.3f\n',p5);

%% B 
% B_D_cost_time_b=B_cost_time_b; %��¼ÿ������ϵͳ����ʱ��
% B_D_wait_time_b=B_wait_time_b; %��¼ÿ������ϵͳ�ȴ�ʱ��
% for i=1:length(da1_b)
%   tmp1_=0;tmp2_=0;
%   if bb5(i)==1
%       tmp1_=db2(find(index_==i))-db1(find(index_==i));
%       tmp2_=db3(find(index_==i))-db1(find(index_==i));
%   end    
%   B_D_wait_time_b(i)=B_D_wait_time_b(i)+bb5(i)*tmp1_; %��i������ϵͳ�ȴ�ʱ��
%   B_D_cost_time_b(i)=B_D_cost_time_b(i)+bb5(i)*tmp2_; %��i������ϵͳ����ʱ��
% end
B_D_cost_time_b=B_cost_time_b; %��¼ÿ������ϵͳ����ʱ��
B_D_wait_time_b=B_wait_time_b; %��¼ÿ������ϵͳ�ȴ�ʱ��
for i=1:arr_num_b
  if sum(find(da1_b==b3(i)))~=0
      index=find(da1_b==b3(i));
      B_D_wait_time_b(i)=B_D_wait_time_b(i)+da2_b(index)-da1_b(index); %��i������ϵͳ�ȴ�ʱ��
      B_D_cost_time_b(i)=B_D_cost_time_b(i)+da3_b(index)-da1_b(index); %��i������ϵͳ����ʱ��
  end
end

%% all
Wait_time=zeros(1,arr_num);
Cost_time=zeros(1,arr_num);
for i=1:arr_num
  Wait_time( i)=A_wait_time(i)+max(B_D_wait_time(i),B_D_wait_time_b(i));
  Cost_time( i)=A_cost_time(i)+max(B_D_cost_time(i),B_D_cost_time_b(i));
end
