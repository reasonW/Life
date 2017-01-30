%二次规划 非线性规划的目标函数自变量为x 的二次函数约束条件有全是线性的,称为二次规划
% min f(x)=2x1^2-4x1x2+4x2^2-6x1-3x2
% st.   x1+x2<=3 
%       4x1+x2<=9
%       x1>=0
%       x2>=0
% 实对称矩阵 的2倍问题 1/2 X^T*H*x=2x1^2-4x1x2+4x2^2
%h=[4,-4;-4,8];
%f=[-6;-3];
%a=[1,1;4,1];
%b=[3;9];
%[x,fval]=quadprog=(h,f,a,b,[],[],zeros(2,1))

[x,fval,exitflag,output,lambda]= quadprog(H,f,A,b,Aeq,beq,lb,ub,x0,options);
% f和b是列向量,A是相应维数的矩阵,H是实对称矩阵.
% x的返回值是一个向量 fval的返回值是目标函数在x处的值,
