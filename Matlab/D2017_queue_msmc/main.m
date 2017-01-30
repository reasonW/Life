clear;
close all;
load 'time_tmp.mat'
loop=700;
MODEL=1

DeteAr=zeros(1,loop);
DeteBr=zeros(1,loop);
DeteBbr=zeros(1,loop);
if (MODEL==1)
    arr_num=45;
else
    arr_num=55;
end
 A_wait_time_record=zeros(loop,arr_num);
A_cost_time_record=zeros(loop,arr_num);
B_wait_time_record=zeros(loop,arr_num);
B_cost_time_record=zeros(loop,arr_num);
Bb_wait_time_record=zeros(loop,arr_num);
Bb_cost_time_record=zeros(loop,arr_num);
BD_wait_time_record=zeros(loop,arr_num);
BD_cost_time_record=zeros(loop,arr_num);
BDb_wait_time_record=zeros(loop,arr_num);
BDb_cost_time_record=zeros(loop,arr_num);
Wait_time_record=zeros(loop,arr_num);
Cost_time_record=zeros(loop,arr_num);
Queue_record=zeros(loop,arr_num);
count=0;
 for count= 1:loop
    Atmp;
%     queu_A_alone;
    queu_B_p_alone;
    queu_B_b_alone;
%      queu_A_msmq2;
%     queu_B_p_msmq2;
%     queu_B_b_msmq2;
%      queu_A_msmq3;
%     queu_B_p_msmq3;
%     queu_B_b_msmq3;
    
    queu_D_p_msmq2;
%     queu_D_p_alone;
    queu_D_b_msmq2;
%     queu_D_b_alone;
    A_wait_time_record(count,:) =A_wait_time;
    A_cost_time_record(count,:) =A_cost_time;
    B_wait_time_record(count,:)  =B_wait_time;
    B_cost_time_record(count,:) =B_cost_time;
    Bb_wait_time_record(count,:)  =B_wait_time_b;
    Bb_cost_time_record(count,:)  =B_cost_time_b;
    BD_wait_time_record(count,:)  =B_D_wait_time;
    BD_cost_time_record(count,:)  =B_D_cost_time;
    BDb_wait_time_record(count,:) =B_D_wait_time_b;
    BDb_cost_time_record(count,:) =B_D_cost_time_b; 
    Wait_time_record(count,:) =Wait_time;
    Cost_time_record(count,:)=Cost_time;
    Queue_record(count,:) =a4+max(bb4,bb4);
    DeteAr(count)=DeteA;
    DeteBr(count)=DeteB;
    DeteBbr(count)=DeteBb;
end

sum(DeteAr)    
sum(DeteBr)    
sum(DeteBbr)    
figure;
plot(1:arr_num,mean(A_cost_time_record),'-', 1:arr_num,mean(A_wait_time_record),'-');
legend('A cost time ','A waiting time ');
    set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','YGrid','on',...
    'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
grid on;

avertA=mean(mean(A_cost_time_record));%每个人A平均逗留时间
fprintf('A averager cost time%6.2fs\n\n',avertA);
avertA2=mean(mean(A_wait_time_record));%每个人A平均逗留时间
fprintf('A averager waiting time%6.2fs\n\n',avertA2);

figure;
plot(1:arr_num,mean(B_cost_time_record),'-', 1:arr_num,mean(B_wait_time_record),'-');
legend('B_p cost time ','B_p waiting time ');
    set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','YGrid','on',...
    'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
grid on;
avertB=mean(mean(B_cost_time_record));%每个人b平均逗留时间
fprintf('B averager cost time%6.2fs\n\n',avertB);
avertB2=mean(mean(B_wait_time_record));%每个人b平均逗留时间
fprintf('B averager waiting time%6.2fs\n\n',avertB2);

figure;
plot(1:arr_num,mean(Bb_cost_time_record),'-', 1:arr_num,mean(Bb_wait_time_record),'-');
legend('B_b cost time ','B_b waiting time ');
    set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','YGrid','on',...
    'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
grid on;
avertBb=mean(mean(Bb_cost_time_record));%每个人b平均逗留时间
fprintf('Bb averager cost time%6.2fs\n\n',avertBb);
avertBb2=mean(mean(Bb_wait_time_record));%每个人b平均逗留时间
fprintf('Bb averager waiting time%6.2fs\n\n',avertBb2);

figure;
plot(1:arr_num,mean(BD_cost_time_record),'-', 1:arr_num,mean(BD_wait_time_record),'-');
legend('B_D cost time ','B_D waiting time ');
    set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','YGrid','on',...
    'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
grid on;
avertBD=mean(mean(BD_cost_time_record));%每个人b平均逗留时间
fprintf('B_D averager cost time%6.2fs\n\n',avertBD);
avertBD2=mean(mean(BD_wait_time_record));%每个人b平均逗留时间
fprintf('B_D averager waiting time%6.2fs\n\n',avertBD2);

figure;
plot(1:arr_num,mean(BDb_cost_time_record),'-', 1:arr_num,mean(BDb_wait_time_record),'-');
legend('B_D_b cost time ','B_D_b waiting time ');
    set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','YGrid','on',...
    'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
grid on;
avertBDb=mean(mean(BDb_cost_time_record));%每个人b平均逗留时间
fprintf('B_D_b averager cost time%6.2fs\n\n',avertBDb);
avertBDb2=mean(mean(BDb_cost_time_record));%每个人b平均逗留时间
fprintf('B_D_b averager waiting time%6.2fs\n\n',avertBDb2);

figure;
plot(1:arr_num,mean(Cost_time_record),'-', 1:arr_num,mean(Wait_time_record),'-');
legend('Cost time ','Waiting time ');
    set(gca,'Box','off','TickDir','out','Ticklength',[.02 .02],...
    'XMinorTick','on','YMinorTick','on','YGrid','on',...
    'XColor',[.3 .3 .3],'YColor',[.3 .3 .3],'LineWidth',1);
grid on;
fprintf('Variance waiting time%6.2fs\n\n',var(mean(Wait_time_record)));
avert=mean(mean(Cost_time_record));%每个人b平均逗留时间
fprintf('Averager cost time%6.2fs\n\n',avert);
avert2=mean(mean(Wait_time_record));%每个人b平均逗留时间
fprintf('Averager waiting time%6.2fs\n\n',avert2);

Satisfily=-(mean(Wait_time_record)).^2/400+100;
plot(1:arr_num,Satisfily,'-');

3600*57/max(max(b3),max(bb3))
mean(mean(Queue_record))
sum(DeteA_t)/length(DeteA_t)
sum(DeteB_t)/length(DeteB_t)
sum(DeteBb_t)/length(DeteBb_t)
sum(DeteC_t)/length(DeteC_t)
sum(DeteCb_t)/length(DeteCb_t)
