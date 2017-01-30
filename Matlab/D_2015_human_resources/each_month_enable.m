%%%init each lev & id
%%%
clc;
clear;
disp('init')
load('stuff_cost.mat');
a=size(stuff_Matrix);

% stuff ability init(stuff_Matrix{:,4}) and Positivity set(stuff_Matrix{:,5}) and loyal set(stuff_Matrix{:,6})
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
%%% init bool matrix
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
end
disp('finished init bool matrix & Officially begin')


%%% loop
%%%
maxtime=10;
%upgrade_record=zeros(370,maxtime);
for t=1:maxtime
  %train check
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

%  updata ability as the result of training
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

  tmp_order_level=zeros(1,370);
  tmp=1;
% check  are eligible for upgrade
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

 % upgrade valid statistics
  for i=1:b(1)
    lamda{i,5}=length(lamda{i,2})-sum(find(tmp_order_level==i));
  end

  %  update loyal as the result of upgrade*ability & training & infection
  loyalThre=1;
  % loyal update
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
        %earse level
        stuff_Matrix{i,3}(j)=0;
        %earse & init Loyal
        stuff_Matrix{i,6}(j)=1.5;
        %record id_leaving_for_each_level
        stuff_Matrix{i,7}(j)=stuff_Matrix{i,2}(j);
        % bool_for_each_id_valid
        lamda{i,5}=1;
      end
    end
  end

%%update the Infectious disease model
  P0=0.25;
  for i=1:a(1)-1
    for j=1:length(stuff_Matrix{i,4})
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
          end
      end
    end
  end

% update level(upgrade)
  for i=1:a(1)-1
    for j=1:length(stuff_Matrix{i,4})
      %take level
      level=stuff_Matrix{i,3}(j);
      %if  bool_for_eligible_upgrade & number_for_each_level_valid
      if level~=0 && lamda{i,3}(j)==1 && lamda{i-1,5}>0
        %upgrade;changed stuff_Matrix{:,3}
        stuff_Matrix{i,3}(j)=stuff_Matrix{i,3}(j)-1;
        %stuff_Matrix{i,7}(j)=0;
        %bool_for_eligible_upgrade set =0;changed lamda{:,3}
        lamda{i,3}(j)=0;
        %number_for_each_level_valid -1;changed lamda{:,5}
        lamda{i-1,5}=lamda{i-1,5}-1;
      end
     end
  end

% update recruitment of new employees
  for i=2:b(1)
      if  lamda{i,5}>0
         %% add stuff_Matrix{i,3}(j)=stuff_Matrix{i,3}(j)-1;
          lamda{i-1,5}=lamda{i-1,5}-1;
      end
  end

  %clear
  for i=1:b(1)
    for j=1:length(lamda{i,1})
      lamda{i,1}(j)=0;
      lamda{i,3}(j)=0;
    end
  end
end
