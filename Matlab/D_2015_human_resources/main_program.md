#Init
clear & load

## init each lev & id
- pre
    - stuff_Matrix{:,1} = level_name;
    - stuff_Matrix{:,2} = level_each_id;
    - train_Matrix{:,1} = level_name;
    - train_Matrix{:,2} = level_ability;
    - train_Matrix{:,3} = level_month_fixed_ability_increase;
    - train_Matrix{:,4} = level_month_train_ability_increase;
    - find_vec(:,1)     = each_id;
    - find_vec(:,2)     = each_id's_level;
    - find_vec(:,3)     = each_id's_level_order;
- init
    - stuff_Matrix{:,4} = ability_for_each_id;
    - stuff_Matrix{:,3} = level_for_each_id;
    - stuff_Matrix{:,5} = Subjective_initiative_vec_for_12_mouth;
    - stuff_Matrix{:,6} = Loyal_for_each_id;
    - stuff_Matrix{:,7} = id_leaving_for_each_level;

## init bool matrix
- init
    - lamda{:,1}        = bool_for_eligible_training;
    - lamda{:,2}        = id_sort_for_ability;
    - lamda{:,3}        = bool_for_eligible_upgrade;
    - lamda{:,4}        = state_for_infection;
    - lamda{:,5}        = bool_for_each_id_valid;
    - lamda{:,6}        = time_recruit_for_each_id_leaving
    - lamda{:,7}        = time_infection_for_each_id_leaving

## init output matrix
- init
    - output_Matrix{t,1,:,:} = number_leaving & id
    - output_Matrix{t,2,:,:} = number_recruitment & id
    - output_Matrix{t,3,:,:} = number_upgrade & id
    - output_Matrix{t,4,:,:} = number_infection & id

#Loop
set maxtime
## check  are eligible for training
- %train check
- %copy ability sort ;changed lamda{:,2}
- %take the first 40%
- %set bool_for_eligible_training; changed lamda{:,1}

## updata ability as the result of training
- %take level & check level ~=0
- %Increases ability by level_month_fixed & train _ability;changed stuff_Matrix{:,4}

## check  are eligible for upgrade
condition: level >1 & ability > next_level_ability_threshold

- %set bool_for_eligible_upgrade; changed lamda{:,3}
- record each level valid;changed tmp_order_level
- bool_for_each_id_valid;changed lamda{:,5}

## update loyal as the result of upgrade*ability & training & infection
- %set loyalthre
- %calculate each parameter
    - %bool_for_upgrade(bool_for_eligible_upgrade**number_for_each_level_valid more than 0);
    - %bool for training
    - %is infection
- %calculate loyal_for_each_id; changed stuff_Matrix{:,6}
- %update level_for_each_id ,if loyal less than loyalthre,set it to 0(laveing);changed stuff_Matrix{:,3}
    - %set recruit time
    - %earse level
    - %earse & init Loyal
    - %record  id_leaving_for_each_level;
    - %bool_for_each_id_valid

## update infection state after someone level be set to 0
set probility thre

- %if level_for_each_id=0(Leaving) find weight and record related id(col_index_vec)
- %for each id recorded,according index
    - %take weight,calculate probability
    - %take level col and row
    - %update state_for_infection according to probobility;

## update level(upgrade)
- %take level & check level ~=0
- %if  bool_for_eligible_upgrade & number_for_each_level_valid
    - %upgrade id_level;changed stuff_Matrix{:,3};
    - %bool_for_eligible_upgrade reset =0;changed lamda{:,3}
    - %number_for_each_level_valid -1;changed lamda{:,5}

## update recruitment of new employees
- for each level check number_for_each_level_valid<br>
    *** record recruiment time up to recruit***
    - find id_leaving_for_each_level
    - take each id's ability and sort it
    - supplement for the sort first 2/3,set the id_leaving_for_each_level to id_new
    - set id_new level & ability
    - number_for_each_level_valid=number_for_each_level_valid*1/3

#Output
- output_Matrix;

- for each month
    - output_Matrix{t,1:4,:,:}
    - ***calculate_risk(=input_key_prople+output_key_peopel)***

- ***for each year***
    - ***rate_leaving(=average(sum(12 months)))***
