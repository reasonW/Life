%% ���A ������������
% arr_time=normrnd(273.964,165.70,1,arr_num);
% arr_time=sort(abs(arr_time));
% state_a=randsrc(1,47,[7.55 5.28 11.06 9.98 9.15 8.82 12.61 15.44 11.88]);
if(MODEL==1)
    arr_time=arr_time2(1:arr_num);
else
    arr_time=arr_time1(1:arr_num);
end

state_a=normrnd(12.946,4.54,1,arr_num);
state_a=1*abs(state_a);
% state_b=randsrc(1,47,[14.65 11.85 14.78 20.45 7.7 7.5 10.93]);
% Delay=unifrnd(0,5,1,arr_num);%�۵�ֲ����ȷֲ�,rand��׼���ȷֲ�
Delay=zeros(1,arr_num);
%st=exprnd(2.5,1,n); %����̨����ʱ��
a1_a=zeros(1,arr_num); %ÿ���˵���ʱ��
a2_a=zeros(1,arr_num); %ÿ���˿�ʼ���ܷ���ʱ��   -> events(3,:)
a3_a=zeros(1,arr_num);%ÿ�����뿪ʱ��            -> events(4,:)
a4_a=zeros(1,arr_num);% %��ʶλ��ʾ�����ϵͳ��ϵͳ�ڹ��еĹ˿���       -> events(5,:)

a1_a(1)=0;
% for i=2:arr_num
%   a1(i)=a1(i-1)+dt(i-1);%��i���˵���ʱ��  -> events(1,:)
% end
a1_a(1)=arr_time(1);%��1���˵���ʱ��
a2_a(1)=arr_time(1);%��1���˿�ʼ����ʱ��Ϊ����ʱ��
a3_a(1)=a2_a(1)+state_a(1); %��1�����뿪ʱ��
a4_a(1)=1;%һ���˿�,��־λ��Ϊ1
%�����ϵͳ��ϵͳ�����г�Ա���Ϊ 1
member_A = [1];
bottleA=zeros(1,10);
bottleA(1)=0;
DeteA=0;
DeteA_t=[ ];
Pointer=1;
Jump_rate=0.00;

for i=2:arr_num
            member_A=[member_A,length(member_A)+1];
            len_A_mem=length(member_A);
            a1_a(len_A_mem)=arr_time(i);
            number=sum(a3_a(1:len_A_mem-1)>=a1_a(len_A_mem));
              if number ==0
                a2_a(len_A_mem)=a1_a(len_A_mem);
                a3_a(len_A_mem)=a2_a(len_A_mem)+state_a(len_A_mem);
                a4_a(len_A_mem)=1;
              else
                    if(randsrc(1,1,[0 1;1-Jump_rate Jump_rate])==1)
                        i;
                        tmp=a4_a(len_A_mem-1);
                        a2_a(len_A_mem)=a3_a(len_A_mem-tmp);
                        a2_a(len_A_mem-tmp+1)=a2_a(len_A_mem)+state_a(len_A_mem);
                        a3_a(len_A_mem-tmp+1)=a2_a(len_A_mem-tmp+1)+state_a(len_A_mem-tmp+1);
                        while (tmp>2)% ���֮ǰһ�ζ��鳤����>2,��һ������һ��;
                            tmp=tmp-1;
                            a2_a(len_A_mem-tmp+1)=a3_a(len_A_mem-tmp);
                            a3_a(len_A_mem-tmp+1)=a2_a(len_A_mem-tmp+1)+state_a(len_A_mem-tmp+1);                            
                        end
                    else
                        a2_a(len_A_mem)=a3_a(len_A_mem-1)+Delay(i);                     %�Ļ�����:���ӳ�
 %                      a2_a(len_A_mem)=a3_a(len_A_mem-1);%���ӳ�                     
                    end
                    a3_a(len_A_mem)=a2_a(len_A_mem)+state_a(len_A_mem);
                    a4_a(len_A_mem)=number+1;                  
              end
              bottleA(rem(Pointer+1,10)+1)=a2_a(len_A_mem)-a1_a(len_A_mem);
              Pointer=Pointer+1;
     if (MODEL==1)
        if sum(bottleA)/10>11.27
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteA=DeteA+1;
        DeteA_t=[DeteA_t,sum(bottleA)/10];
        end
    else
        if sum(bottleA)/10>13.64
%             fprintf('A area %f people waiting long %f \n',i,sum(bottleA));
        DeteA=DeteA+1;
        DeteA_t=[DeteA_t,sum(bottleA)/10];
        end
    end
end
%% demo_��ͼ
len_A_mem = length(member_A);
a1=[a1_a(1:len_A_mem) ];
a2=[a2_a(1:len_A_mem)  ];
a3=[a3_a(1:len_A_mem) ];
a4=[a4_a(1:len_A_mem)  ];
a_tmp=[a1;a2;a3;a4];
a_tmp_=sortrows(a_tmp',1);
a_tmp=a_tmp_';
a1=a_tmp(1,:);
a2=a_tmp(2,:);
a3=a_tmp(3,:);
a4=a_tmp(4,:);
%�������ʱ������ϵͳ���ܹ˿���
%*****************************************
%������
%*****************************************
%�����ڷ���ʱ���ڣ�����ϵͳ�����й˿͵ĵ���ʱ�̺���
%��ʱ������ͼ��stairs�����ƶ�ά����ͼ��
% stairs(0:arr_num,[0 a1],'o-','linewidth',1, 'MarkerFaceColor','g','markersize',2);
% hold on;
% stairs(0:arr_num,[0 a3 ],'o-','linewidth',1, 'MarkerFaceColor','y','markersize',2);
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
% plot(1:arr_num,A_cost_time,'-', 1:arr_num,A_wait_time,'-');
% legend('A cost time ','A waiting time ');
%     set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
%     'XMinorTick','on','YMinorTick','on','YGrid','on',...
%     'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
% grid on;

%% x_���
% T1=a3_a(arr_num)%��ʱ��
% p1=sum(state_a(member_A))/T1+sum(state_b(member_B))/T1 %������
% avert1=sum(A_wait_time)/(sum(state_a(member_A))+sum(state_b(member_B)))%ÿ����ϵͳƽ������ʱ��
% fprintf('A passenager averager cost time%fs\n',avert1);
% fprintf('A system working intensity %f\n',p1);


