%% ���A ���򵥷��񵥶���
 t1=1*randsrc(1,arr_num,[7.55 5.28 11.06 9.98 9.15 8.82 12.61 15.44 11.88]);
%st=exprnd(2.5,1,n); %����̨����ʱ��
a1=zeros(1,arr_num); %ÿ���˵���ʱ��
a2=zeros(1,arr_num); %ÿ���˿�ʼ���ܷ���ʱ��   -> events(3,:)
a3=zeros(1,arr_num);%ÿ�����뿪ʱ��            -> events(4,:)
a4=zeros(1,arr_num);% %��ʶλ��ʾ�����ϵͳ��ϵͳ�ڹ��еĹ˿���       -> events(5,:)
% for i=2:arr_num
%   a1(i)=a1(i-1)+dt(i-1);%��i���˵���ʱ��  -> events(1,:)
% end
if(MODEL==1)% pre-check
    arr_time=arr_time2(1:arr_num);
else
    arr_time=arr_time1(1:arr_num);
end
Delay=unifrnd(0,5,1,arr_num);%�۵�ֲ����ȷֲ�,rand��׼���ȷֲ�
Delay=zeros(1,arr_num);
% Delay=zeros(1,arr_num);
% a1=normrnd(273.964,165.70,1,arr_num);
a1=sort(abs(arr_time));

a2(1)=0;%��1���˿�ʼ����ʱ��Ϊ����ʱ��
a3(1)=a2(1)+t1(1); %��1�����뿪ʱ��Ϊ����ʱ��
a4(1)=1;%һ���˿�,��־λ��Ϊ1
%�����ϵͳ��ϵͳ�����г�Ա���Ϊ 1
member_A = [1];
bottleA=zeros(1,10);
bottleA(1)=0;
DeteA=0;
DeteA_t=[ ];
Pointer=1;
for i=2:arr_num

    number=sum(a3(member_A)>a1(i));
      if number ==0
        a2(i)=a1(i)++Delay(i);
        a3(i)=a2(i)+t1(i);
        a4(i)=1;
        member_A=[member_A,i];
        bottleA(rem(Pointer+1,10)+1)=a2(i)-a1(i);
          Pointer=Pointer+1;
      else len_A_mem=length(member_A);
        a2(i)=a3(member_A(len_A_mem)) +Delay(i);
        a3(i)=a2(i)+t1(i);
        a4(i)=number+1;
        member_A=[member_A,i];
        bottleA(rem(Pointer+1,10)+1)=a2(i)-a1(i);
          Pointer=Pointer+1;
        % if(a1(i)<=a3(i-1))
        %    a2(i)=a3(i-1);%�����i���˵���ʱ���ǰһ�����뿪ʱ����,���俪ʼ����ʱ��Ϊǰһ���뿪ʱ��
        % else
        %    a2(i)=a1(i); %�����i���˵���ʱ���ǰһ�����뿪ʱ����,���俪ʼ����ʱ��Ϊ����ʱ��.
        % end

        % a3(i)=a2(i)+t1(i);  %��i�����뿪ʱ��Ϊ�俪ʼ����ʱ��+���ܷ���ʱ��
      end
    if (MODEL==1)
        if sum(bottleA)/10>11.27*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteA=DeteA+1;
        DeteA_t=[DeteA_t,sum(bottleA)/10];
        end
    else
        if sum(bottleA)/10>18.81*1.2
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteA=DeteA+1;
        DeteA_t=[DeteA_t,sum(bottleA)/10];
        end
    end
end
%% demo_��ͼ
%�������ʱ������ϵͳ���ܹ˿���
len_A_mem = length(member_A);
%*****************************************
%������
%*****************************************
%�����ڷ���ʱ���ڣ�����ϵͳ�����й˿͵ĵ���ʱ�̺���
%��ʱ������ͼ��stairs�����ƶ�ά����ͼ��
% len_A_mem
% stairs([0 a1(member_A)],0:len_A_mem,'o-','linewidth',1, 'MarkerFaceColor','g','markersize',2);
% hold on;
% stairs([0 a3(member_A)],0:len_A_mem,'o-','linewidth',1, 'MarkerFaceColor','y','markersize',2);
% legend('A arriving time','A leaving time');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% hold off;
% grid on;
%�����ڷ���ʱ���ڣ�����ϵͳ�����й˿͵�ͣ��ʱ��͵�
%��ʱ������ͼ��plot�����ƶ�ά����ͼ��
A_cost_time=zeros(1,arr_num); %��¼ÿ������ϵͳ����ʱ��
A_wait_time=zeros(1,arr_num); %��¼ÿ������ϵͳ�ȴ�ʱ��
for i=1:arr_num
  A_cost_time(i)=a3(i)-a1(i); %��i������ϵͳ����ʱ��
  A_wait_time(i)=a2(i)-a1(i); %��i������ϵͳ�ȴ�ʱ��
end
% figure;
% plot(1:len_A_mem,A_cost_time(member_A),'-', 1: len_A_mem,A_wait_time(member_A),'-');
% legend('A cost time ','A waiting time ');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% grid on;

%% 
%demo
% plot(x,y,'o-','linewidth',2, 'MarkerFaceColor','g','markersize',4);
% title('�����ٶ�')
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
%% x_���

% 
% T1=a3(len_A_mem)%��ʱ��
% p1=sum(t1(member_A))/T1 %������
% avert1=sum(A_wait_time(member_A))/len_A_mem%ÿ����ϵͳƽ������ʱ��
% fprintf('A passenager averager cost time%fs\n',avert1);
% fprintf('A system working intensity %f\n',p1);


