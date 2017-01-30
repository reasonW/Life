%% 这个是单服务台单队列限制时间和队列长度的程序
clear
clc
%*****************************************
%初始化顾客源
%*****************************************
%总仿真时间
Total_time = 10;                            % 分别限制时间
%队列最大长度
N = 10000000000;                            % 分别限制 超出,队列长度
%到达率与服务率
lambda = 10;%% 每一单位时间内到达超出
mu = 6;%% 每一单位时间内到达超出
%平均到达时间与平均服务时间
arr_mean = 1/lambda;
ser_mean = 1/mu;
arr_num = round(Total_time*lambda*2);% 取整
events = [];
%按负指数分布产生各顾客达到时间间隔
events(1,:) = exprnd(arr_mean,1,arr_num);
%各顾客的到达时刻等于时间间隔的累积和
events(1,:) = cumsum(events(1,:));%第i个人到达时间
%按负指数分布产生各顾客服务时间
events(2,:) = exprnd(ser_mean,1,arr_num);
%计算仿真顾客个数，即到达时刻在仿真时间内的顾客数
len_sim = sum(events(1,:)<= Total_time);        %加了个仿真时间限制
%*****************************************
%计算第 1个顾客的信息
%*****************************************
%第 1个顾客进入系统后直接接受服务，无需等待
a1=zeros(1,arr_num);a1(1)=0;
b1=zeros(1,arr_num);b1(1) = 0;                                %即b1
%其离开时刻等于其到达时刻与服务时间之和
c1=zeros(1,arr_num);c1(1) = events(1,1)+events(2,1);          %即c1
%其肯定被系统接纳，此时系统内共有
%1个顾客，故标志位置1
d1=zeros(1,arr_num);d1(1) = 1;
%其进入系统后，系统内已有成员序号为 1
member_1 = [1];
a2=zeros(1,arr_num);
b2=zeros(1,arr_num);                                %即b1
%其离开时刻等于其到达时刻与服务时间之和
c2=zeros(1,arr_num);       %即c1
%其肯定被系统接纳，此时系统内共有
%1个顾客，故标志位置1
d2=zeros(1,arr_num);
%其进入系统后，系统内已有成员序号为 1
member_1 = [1];
member_2 = [1];
for i = 2:arr_num
    %如果第 i个顾客的到达时间超过了仿真时间，则跳出循环
    if events(1,i)>Total_time
        break;
    else
        number = sum(c1(member_1) > events(1,i))+sum(c2(member_2) > events(1,i));
        %如果系统已满，则系统拒绝第 i个顾客，其标志位置 0
        if number >= N+1
            d1(length(member_1)) = 0;
            d2(length(member_2)) = 0;
        %如果系统为空，则第 i个顾客直接接受服务
        else
            if number == 0
                member_1 = [member_1,i];            %序号依次增加
                %其等待时间为 0
                % 2009.1516
                a1(length(member_1))=events(1,i);
                %系统队列为空时,这个人等待时间为0;
                b1(length(member_1)) = 0;
                %其离开时刻等于到达时刻与服务时间之和
                c1(length(member_1)) = events(1,i)+events(2,i);
                %其标志位置 1
                d1(length(member_1)) = 1;
            %如果系统有顾客正在接受服务，且系统等待队列未满，则 第 i个顾客进入系统
            else
                if length(member_1)<=length(member_2)
                    len_mem = length(member_1);
                    %其等待时间等于队列中前一个顾客的离开时刻减去其到 达时刻
                    a1(member_1(len_mem)+1)=events(1,i);
                    b1(member_1(len_mem)+1)=c1(member_1(len_mem))-events(1,i);
                    %其离开时刻等于队列中前一个顾客的离开时刻加上其服
                    %务时间
                    c1(member_1(len_mem)+1)=c1(member_1(len_mem))+events(2,i);
                    %标识位表示其进入系统后，系统内共有的顾客数
                    d1(member_1(len_mem)+1) = number+1;
                    member_1 = [member_1,member_1(len_mem)+1];
                else
                    len_mem = length(member_2);
                    %其等待时间等于队列中前一个顾客的离开时刻减去其到 达时刻
                    a2(member_2(len_mem)+1)=events(1,i);
                    b2(member_2(len_mem))=c2(member_2(len_mem))-events(1,i);
                    %其离开时刻等于队列中前一个顾客的离开时刻加上其服
                    %务时间
                    c2(member_2(len_mem))=c2(member_2(len_mem))+events(2,i);
                    %标识位表示其进入系统后，系统内共有的顾客数
                    d2(member_2(len_mem)) = number+1;
                    member_2= [member_2,member_2(len_mem)+1];
                end

            end
        end
    end
end
%仿真结束时，进入系统的总顾客数
len_mem = length(member_1);
%*****************************************
%输出结果
%*****************************************
%绘制在仿真时间内，进入系统的所有顾客的到达时刻和离
%开时刻曲线图（stairs：绘制二维阶梯图）
stairs([0 a1(member_1)],0:len_mem);
hold on;
stairs([0 c1(member_1)],0:len_mem,'-');
legend('到达时间 ','离开时间 ');
hold off;
grid on;
%绘制在仿真时间内，进入系统的所有顾客的停留时间和等
%待时间曲线图（plot：绘制二维线性图）
figure;
plot(1:len_mem,b1(member_1),'-*',1: len_mem,events(2,member_1)+b1(member_1),'-*');
legend('等待时间 ','停留时间 ');
grid on;
