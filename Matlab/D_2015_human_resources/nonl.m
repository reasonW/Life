x0=rand(2,1);
A=[];B=[];Aeq=[];Beq=[];LB=zeros(2,1);UB=[];% A,是线性不等式约束;B,是线性等式约束
options=optimset;                           %options定义了优化参数
[x,fval]=fmincon('nonl_main',x0,A,B,Aeq,Beq,LB,UB,'nonl_con',options)
