%% init each lev & id
clc;
clear;
disp('init')
load('stuff_cost.mat');
a=size(stuff_Matrix);
%% stuff ability init(stuff_Matrix{:,4}) and Positivity set(stuff_Matrix{:,5}) 
%% and loyal set(stuff_Matrix{:,6})and leaving_id set(stuff_Matrix{:,7})
for i=1:a(1)
  if i<=6
    stuff_Matrix{i,4}=train_Matrix{i,2}*ones(1,length(stuff_Matrix{i,2}));
  end
  stuff_Matrix{i,5}=zeros(length(stuff_Matrix{i,2}),12);
  stuff_Matrix{i,6}=zeros(length(stuff_Matrix{i,2}),1);
  for j=1:length(stuff_Matrix{i,2})
    stuff_Matrix{i,3}(j)=i;
    stuff_Matrix{i,5}(j,:)=0.5+5/2*exp(-(randn(1,12)).^2/2)/sqrt(2*pi);
    stuff_Matrix{i,6}(j)=0;
    stuff_Matrix{i,7}(j)=0;
  end
end
disp('finished init lev & id')
%% % init bool matrix
% bool eligible train check element init(lamda{:,1})
lamda={zeros(1,10);zeros(1,20);zeros(1,25);zeros(1,25);zeros(1,110);zeros(1,150);};
b=size(lamda);
for i=1:b(1)
  % Dynamic storage area(lamda{:,2})
  lamda{i,2}=(lamda{i,1}+1);
  % bool eligible upgrade check element init(lamda{:,3})
  lamda{i,3}=lamda{i,1};
  % state is infection init (lamda{:,4})
  lamda{i,4}=(lamda{i,1}+2);
  % bool_for_each_id_valid
  %lamda{i,5}=lamda{i,1};
  lamda{i,5}=0;
  lamda{i,6}=lamda{i,1};
  lamda{i,7}=lamda{i,1};
end
disp('finished init bool matrix & Officially begin')
%% % init output_Matrix
%
maxtime=1;
for t=1:maxtime
  for i=1:b(1)
    output_Matrix{t,1,i}=lamda{i,1};
    output_Matrix{t,2,i}=lamda{i,1};
    output_Matrix{t,3,i}=lamda{i,1};
    output_Matrix{t,4,i}=lamda{i,1};
  end
end

set_a_thre=10;set_b_thre=10;
Pj=[2,3,1];aerfaj=[-1.2,1.2,1.8];
%% % loop
%% %upgrade_record=zeros(370,maxtime);
for t=1:maxtime    
  %% train check
  for i=1:a(1)-1
    %copy ability sort
    lamda{i,2}=sort(stuff_Matrix{i,4});
    for j=1:length(stuff_Matrix{i,4})
      % take the first 40%
      if stuff_Matrix{i,4}(j)>lamda{i,2}(4)
        %set bool_for_eligible_training;
        lamda{i,1}(j)=1;
      end
    end
  end
  %% updata ability as the result of training
  for i=1:a(1)-1
    for j=1:length(stuff_Matrix{i,3})
      %take level
      level=stuff_Matrix{i,3}(j);
      %Increases ability by level_month_fixed & train _ability
      if level~=0
         stuff_Matrix{i,4}(j)=stuff_Matrix{i,4}(j)+...
                          (train_Matrix{level,3}+lamda{i,1}(j)*train_Matrix{level,4})...
                          *stuff_Matrix{i,5}(j,rem(t,12)+1);
      end
    end
  end

  %% check  are eligible for upgrade
  tmp_order_level=zeros(1,370);
  tmp=1;
  for i=1:a(1)-1
    for j=1:length(stuff_Matrix{i,3})
      level=stuff_Matrix{i,3}(j);
      if level>1 && stuff_Matrix{i,4}(j)>train_Matrix{level-1,2}
          lamda{i,3}(j)=1;
          %upgrade_record(stuff_Matrix{i,2} ,t)=1;
          %stuff_Matrix{i,3}(j)=level-1;
      end
      tmp_order_level(tmp)=stuff_Matrix{i,3}(j);
      tmp=tmp+1;
    end
  end
 %% upgrade valid statistics
  for i=1:b(1)
    lamda{i,5}=length(lamda{i,2})-sum(find(tmp_order_level==i));
  end
  %% update loyal as the result of upgrade*ability & training & infection
  loyalThre=1;
  % loyal update
  %% update the Infectious disease model
  P0=0.25;
  for i=1:a(1)-1
    for j=1:length(stuff_Matrix{i,2})
      %calculate each parameter
      %bool_for_upgrade(bool_for_eligible_upgrade**number_for_each_level_valid more than 0);
      a_parameter=lamda{i,3}(j)*1 - (lamda{i,5}==0)*2;
      %bool for training
      b_parameter=lamda{i,1}(j)*2-1;
      c_parameter=(lamda{i,4}(j)==1)*(-0.5); %is infection
      abssum_p=abs(a_parameter)+abs(b_parameter)+abs(c_parameter);
      %calculate loyal_for_each-id
      stuff_Matrix{i,6}(j)=a_parameter*abs(a_parameter)/abssum_p+b_parameter*abs(b_parameter)/abssum_p...
               +c_parameter*abs(c_parameter)/abssum_p;
      %update level_for_each_id
      if stuff_Matrix{i,6}(j)<loyalThre;
        %set recruit time
        lamda{i,6}(j)=8-stuff_Matrix{i,3}(j);
        if lamda{i,6}(j)==2 || stuff_Matrix{i,3}(j)==1
          lamda{i,6}(j)=3-lamda{i,6}(j);
        end
        %earse level
        stuff_Matrix{i,3}(j)=0;
        %earse & init Loyal
        stuff_Matrix{i,6}(j)=1.5;
        %record id_leaving_for_each_level
        stuff_Matrix{i,7}(j)=stuff_Matrix{i,2}(j);
        % bool_for_each_id_valid
        lamda{i,5}=1;
      end
      %if level_for_each_id=0(Leaving)
      if  stuff_Matrix{i,3}(j)==0 || lamda{i,4}(j)==1
        col=stuff_Matrix{i,2}(j);
        %find weight and record related id(Index)
        col_index_vec=find(weight(col,:)~=0);% id vec
        %for each id recorded,according index
        for k=1:length(col_index_vec)
          probability=P0/weight(col,col_index_vec(k));
          %take weight,calculate probability
          col_level=find_vec(2,find(find_vec(1,:)==col_index_vec(k)));
          %take level col and row
          row_level=find_vec(3,find(find_vec(1,:)==col_index_vec(k)));
          if col_level<7
            %update state_for_infection according to probobility;
            lamda{col_level,4}(row_level)=lamda{col_level,4}(row_level)+((lamda{col_level,4}(row_level))==0)...
                                        *( randsrc(1,1,[[1,0];[probability,1-probability]]));
          end
          if lamda{i,4}(j)==1 && lamda{i,7}(j)==0
            output_Matrix{t,4,i}=stuff_Matrix{i,2}(j);
            lamda{i,7}(j)=3;
          end
          if lamda{i,4}(j)==2 && lamda{i,7}(j)==0
            lamda{i,7}(j)=6;
          end
        end
      end
      %take level
      level=stuff_Matrix{i,3}(j);
      %if  bool_for_eligible_upgrade & number_for_each_level_valid
      if level~=0 && lamda{i,3}(j)==1 && lamda{i-1,5}>0
        %upgrade;changed stuff_Matrix{:,3}
        stuff_Matrix{i,3}(j)=stuff_Matrix{i,3}(j)-1;
        output_Matrix{t,3,i}(j)=stuff_Matrix{i,2}(j);
        %stuff_Matrix{i,7}(j)=0;
        %reset recurit time
        lamda{i,6}(j)=0;
        %bool_for_eligible_upgrade set =0;changed lamda{:,3}
        lamda{i,3}(j)=0;
        %number_for_each_level_valid -1;changed lamda{:,5}
        lamda{i-1,5}=lamda{i-1,5}-1;
      end
    end
  end

  %% update recruitment of new employees
  for i=1:b(1)
   tmp=zeros(2,length(stuff_Matrix{i,4}));
   tmp(2,:)=1:length(stuff_Matrix{i,4});
   for j=1:length(stuff_Matrix{i,4})
    if  lamda{i,5}>0
      %check recurit time
      if stuff_Matrix{i,7}(j)~=0 &&  lamda{i,6}(j)>0;
        %take level col and row
        tmp(1,j)=stuff_Matrix{i,4}(j);
        %add stuff_Matrix{i,3}(j)=stuff_Matrix{i,3}(j)-1;
      end
    end
    end
    tmp=sortrows(tmp',-1)';
    for k=1:ceil(2/3*length(tmp))
      if tmp(1,k)~=0
          stuff_Matrix{i,3}(tmp(2,k))=i;
          stuff_Matrix{i,7}(tmp(2,k))=0;
          output_Matrix{t,2,i}(tmp(2,k))=stuff_Matrix{i,2}(tmp(2,k));
          lamda{i,5}=lamda{i,5}-1;
      end
    end
  end
%%   
  set_a=0;
  set_b=0;
  for i=1:a(1)-1
    tmp_set_a1=output_Matrix{t,2,i};
    tmp_set_a2=output_Matrix{t,3,i};
    set_a=set_a+sum(tmp_set_a1~=0)+sum(tmp_set_a2~=0);
    output_Matrix{t,1,i}=stuff_Matrix{i,7};
    tmp_set_b=output_Matrix{t,1,i};
    set_b=set_b+sum(tmp_set_b~=0);
  end
  if set_a<set_a_thre
    sa=1;
  elseif set_a==set_a_thre
    sa=2;
  else
    sa=3;
  end
  if set_b<set_b_thre
    sb=1;
  elseif set_b==set_b_thre
    sb=2;
  else
    sb=3;
  end
set_a
set_b
  RH=1.2*Pj(sa)*aerfaj(sa)*a/370+1.2*Pj(sb)*aerfaj(sb)*b/370

  %% clear
  for i=1:b(1)
    for j=1:length(lamda{i,1})
      stuff_Matrix{i,7}(j)=0;
      lamda{i,1}(j)=0;
      lamda{i,3}(j)=0;
      if lamda{i,6}(j)~=0
        lamda{i,6}(j)=lamda{i,6}(j)-1;
      elseif lamda{i,7}(j)~=0
        lamda{i,7}(j)=lamda{i,7}(j)-1;
      end
    end
  end
end
