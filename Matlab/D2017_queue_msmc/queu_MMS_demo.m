%% 多服务台,二级,单队列
% meant=newMM2andMM1(1,1.5,2,0.2,1,300)
%%  function [meant]=newMM2andMM1(mean_arr,mean_serv,mean_serv1,mean_serv21,mean_serv22,peo_num) 
function [meant]=queu_MMS_demo(mean_arr,mean_serv,mean_serv1,mean_serv21,mean_serv22,peo_num) 
%mean_arr,到达的时间参数
%mean_serv,服务台a的服务时间参数
%mean_serv1,服务台b的服务时间参数
%mean_serv21,mean_serv22,二级服务台的均匀分布的参数
%peo_num,总服务人数

nt=exprnd(mean_arr,1,peo_num);
%各顾客到达时间间隔服从指数分布

state_a=zeros(3,peo_num);  
%用一个三行矩阵表示a台每个顾客的状态   
%三行依次为：到达时间间隔，服务时间，等待时间                  
state_b=zeros(3,peo_num);     
%用一个三行矩阵表示b台每个顾客的状态   
%三行依次为：到达时间间隔，服务时间，等待时间                    
state_a(2,:)=exprnd(mean_serv,1,peo_num);% 服务时间     
%生成a台各顾客服务时间的矩阵
state_b(2,:)=exprnd(mean_serv1,1,peo_num); % 服务时间     
%生成b台各顾客服务时间的矩阵
state_a(3,1)=0;% 等待时间                
state_b(3,1)=0;% 等待时间
a=1;%a台服务的人数
b=1;%b台服务的人数


arr_time=cumsum(nt);   
%到达时间由时间间隔变成连续时间
state_b(1,1)=arr_time(1);% 到达时间
state_a(1,1)=arr_time(2);% 到达时间                                
%state(1,:)=arr_time;  

lea_time_a(1)=sum(state_a(:,1));   
%先计算前1名顾客的离开时间   
lea_time_b(1)=sum(state_b(:,1));   
%先计算第2名顾客的离开时间
                
                
for i=3:peo_num 
if  lea_time_a(a)<lea_time_b(b) % 看那个服务台的顾客先离开
%第i个顾客到达，服务台满，等待时间为   
%当时服务台最早离开的顾客的离开时间减去第i个顾客的到达时间
        a=a+1;
        state_a(1,a)=arr_time(i);
        if state_a(1,a)<=state_a(3,a-1)+state_a(2,a-1)   
           state_a(3,a)=state_a(3,a-1)+state_a(2,a-1)-state_a(1,a-1);   
        else   
            state_a(3,a)=0;   
        end 
        lea_time_a(a)=sum(state_a(:,a));
    else
        b=b+1;
        state_b(1,b)=arr_time(i);
        if state_b(1,b)<=state_b(3,b-1)+state_b(2,b-1)   
           state_b(3,b)=state_b(3,b-1)+state_b(2,b-1)-state_b(1,b-1);   
        else   
            state_b(3,b)=0;   
        end 
        lea_time_b(b)=sum(state_b(:,b));
    end
end
%连接两个状态矩阵
state=[state_a(:,1:a),state_b(:,1:b)];
state(3,:)=[lea_time_a(1:a),lea_time_b(1:b)];

%连接两个离开时间
%[g,m]=min(lea_time_a);
%[h,n]=min(lea_time_b);
lea_time=[lea_time_a,lea_time_b];

%按离开时间的先后顺序排队,最后得到 guodo2
guodu1=lea_time;
guodu2=zeros(1,peo_num);
for i=1:peo_num
    [guodu2(i),j]=min(guodu1);
    guodu1(j)=max(guodu1);
end        
                                
state2=zeros(3,peo_num);   
%用一个三行矩阵表示二级服务台每个顾客的状态   
%三行依次为：到达时间间隔，服务时间，等待时间   
state2(2,:)=unifrnd(mean_serv21,mean_serv22,1,peo_num);
%产生二级服务台的服务时间分布      
state2(1,:)=guodu2;     

for i=2:peo_num   
if state2(1,i)<=state2(3,i-1)+state2(2,i-1)
%需要等待，更新等待时间   
        state2(3,i)=state2(3,i-1)+state2(2,i-1)-state2(1,i);   
    else   
        state2(3,i)=0;   
    end;   
end;   
   
%arr_time2=cumsum(state2(1,:)); 
%state2(1,:)=arr_time2;   
lea_time2=sum(state2);


%计算平均时间
t1=0;
t2=0;
for i=1:peo_num
    t1=t1+state(3,i)-state(1,i);
    t2=t2+lea_time2(i)-state2(1,i);
end
meant=(t1+t2)/peo_num;
