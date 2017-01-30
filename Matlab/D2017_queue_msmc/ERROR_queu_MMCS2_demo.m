%% ����ǵ�����̨����������ʱ��Ͷ��г��ȵĳ���
clear
clc
%*****************************************
%��ʼ���˿�Դ
%*****************************************
%�ܷ���ʱ��
Total_time = 10;                            % �ֱ�����ʱ��
%������󳤶�
N = 10000000000;                            % �ֱ����� ����,���г���
%�������������
lambda = 10;%% ÿһ��λʱ���ڵ��ﳬ��
mu = 6;%% ÿһ��λʱ���ڵ��ﳬ��
%ƽ������ʱ����ƽ������ʱ��
arr_mean = 1/lambda;
ser_mean = 1/mu;
arr_num = round(Total_time*lambda*2);% ȡ��
events = [];
%����ָ���ֲ��������˿ʹﵽʱ����
events(1,:) = exprnd(arr_mean,1,arr_num);
%���˿͵ĵ���ʱ�̵���ʱ�������ۻ���
events(1,:) = cumsum(events(1,:));%��i���˵���ʱ��
%����ָ���ֲ��������˿ͷ���ʱ��
events(2,:) = exprnd(ser_mean,1,arr_num);
%�������˿͸�����������ʱ���ڷ���ʱ���ڵĹ˿���
len_sim = sum(events(1,:)<= Total_time);        %���˸�����ʱ������
%*****************************************
%����� 1���˿͵���Ϣ
%*****************************************
%�� 1���˿ͽ���ϵͳ��ֱ�ӽ��ܷ�������ȴ�
a1=zeros(1,arr_num);a1(1)=0;
b1=zeros(1,arr_num);b1(1) = 0;                                %��b1
%���뿪ʱ�̵����䵽��ʱ�������ʱ��֮��
c1=zeros(1,arr_num);c1(1) = events(1,1)+events(2,1);          %��c1
%��϶���ϵͳ���ɣ���ʱϵͳ�ڹ���
%1���˿ͣ��ʱ�־λ��1
d1=zeros(1,arr_num);d1(1) = 1;
%�����ϵͳ��ϵͳ�����г�Ա���Ϊ 1
member_1 = [1];
a2=zeros(1,arr_num);
b2=zeros(1,arr_num);                                %��b1
%���뿪ʱ�̵����䵽��ʱ�������ʱ��֮��
c2=zeros(1,arr_num);       %��c1
%��϶���ϵͳ���ɣ���ʱϵͳ�ڹ���
%1���˿ͣ��ʱ�־λ��1
d2=zeros(1,arr_num);
%�����ϵͳ��ϵͳ�����г�Ա���Ϊ 1
member_1 = [1];
member_2 = [1];
for i = 2:arr_num
    %����� i���˿͵ĵ���ʱ�䳬���˷���ʱ�䣬������ѭ��
    if events(1,i)>Total_time
        break;
    else
        number = sum(c1(member_1) > events(1,i))+sum(c2(member_2) > events(1,i));
        %���ϵͳ��������ϵͳ�ܾ��� i���˿ͣ����־λ�� 0
        if number >= N+1
            d1(length(member_1)) = 0;
            d2(length(member_2)) = 0;
        %���ϵͳΪ�գ���� i���˿�ֱ�ӽ��ܷ���
        else
            if number == 0
                member_1 = [member_1,i];            %�����������
                %��ȴ�ʱ��Ϊ 0
                % 2009.1516
                a1(length(member_1))=events(1,i);
                %ϵͳ����Ϊ��ʱ,����˵ȴ�ʱ��Ϊ0;
                b1(length(member_1)) = 0;
                %���뿪ʱ�̵��ڵ���ʱ�������ʱ��֮��
                c1(length(member_1)) = events(1,i)+events(2,i);
                %���־λ�� 1
                d1(length(member_1)) = 1;
            %���ϵͳ�й˿����ڽ��ܷ�����ϵͳ�ȴ�����δ������ �� i���˿ͽ���ϵͳ
            else
                if length(member_1)<=length(member_2)
                    len_mem = length(member_1);
                    %��ȴ�ʱ����ڶ�����ǰһ���˿͵��뿪ʱ�̼�ȥ�䵽 ��ʱ��
                    a1(member_1(len_mem)+1)=events(1,i);
                    b1(member_1(len_mem)+1)=c1(member_1(len_mem))-events(1,i);
                    %���뿪ʱ�̵��ڶ�����ǰһ���˿͵��뿪ʱ�̼������
                    %��ʱ��
                    c1(member_1(len_mem)+1)=c1(member_1(len_mem))+events(2,i);
                    %��ʶλ��ʾ�����ϵͳ��ϵͳ�ڹ��еĹ˿���
                    d1(member_1(len_mem)+1) = number+1;
                    member_1 = [member_1,member_1(len_mem)+1];
                else
                    len_mem = length(member_2);
                    %��ȴ�ʱ����ڶ�����ǰһ���˿͵��뿪ʱ�̼�ȥ�䵽 ��ʱ��
                    a2(member_2(len_mem)+1)=events(1,i);
                    b2(member_2(len_mem))=c2(member_2(len_mem))-events(1,i);
                    %���뿪ʱ�̵��ڶ�����ǰһ���˿͵��뿪ʱ�̼������
                    %��ʱ��
                    c2(member_2(len_mem))=c2(member_2(len_mem))+events(2,i);
                    %��ʶλ��ʾ�����ϵͳ��ϵͳ�ڹ��еĹ˿���
                    d2(member_2(len_mem)) = number+1;
                    member_2= [member_2,member_2(len_mem)+1];
                end

            end
        end
    end
end
%�������ʱ������ϵͳ���ܹ˿���
len_mem = length(member_1);
%*****************************************
%������
%*****************************************
%�����ڷ���ʱ���ڣ�����ϵͳ�����й˿͵ĵ���ʱ�̺���
%��ʱ������ͼ��stairs�����ƶ�ά����ͼ��
stairs([0 a1(member_1)],0:len_mem);
hold on;
stairs([0 c1(member_1)],0:len_mem,'-');
legend('����ʱ�� ','�뿪ʱ�� ');
hold off;
grid on;
%�����ڷ���ʱ���ڣ�����ϵͳ�����й˿͵�ͣ��ʱ��͵�
%��ʱ������ͼ��plot�����ƶ�ά����ͼ��
figure;
plot(1:len_mem,b1(member_1),'-*',1: len_mem,events(2,member_1)+b1(member_1),'-*');
legend('�ȴ�ʱ�� ','ͣ��ʱ�� ');
grid on;
