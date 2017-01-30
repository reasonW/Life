%求min f, 约束都是<=,则linprog(f,a,b...)
%求min f, 约束都是>=,则linprog(f,-a,-b...)
%求max f 约束都是>=,则linprog(-f,a,b...)
%sample of mixed int linear programming
data=[
% 目标函数   |约束函数1 |约束函数2 |约束函数3
    750         3           3       3       %常数项
    0           0           0       0       %x1
    0           0           0       0
    1486        1           1       0
    0           0           0       0
    495         1           0       0
    2760        1           0       0
    0           0           0       0
    2760        1           1       1
    120         0           0       1
    120         1           0       1
    2070        1           1       1
    2070        1           1       0
    0           0           0       0
    0           0           0       0
    90          0           0       0      ];%x15

const = data(1,:);
data(1,:)=[];
%优化参数定义
n=size(data,1);     %变量个数
f=data(:,1)';       %目标函数系数
f_const=const(1);   %目标函数常数项
intcon=1:n;         %提取变量个数序号,intcon 是一个指示 解的分量是正整数的分量
lb=zeros(1,n);      %下边缘为0
ub=ones(1,n);       %上边缘为1,即构造0-1变量,若无上限则   ub= -Inf ,
%                   或LB(i) = -Inf if X(i) is unbounded below,分别指定变量上下限
A=-data(:,2:end )'; %不等式约束方程系数,因为是<所以变成负号
b=-const(:,2:end )';%y约束方程右端b
Aeq=[];
beq=[];
%混合整数线性规划
%            min f'*x               %求最小值
%           约束:  A*x  <= b        %小于约束
%                  Aeq*x = beq      %等于约束
%                  lb <= x <= ub    %x取值上下限,x(i)是整数,i是x的向量索引

%   若X变量不限于整数,则用下面这个函数
%   x=linprog(f,intcon,A,b,Aeq,beq,lb,ub);%求解,注意优化问题定义最小值,-f
%   X是变量值
%   FVAl是函数的解FVAL = f'*X
%   EXTIFLAG是退出的情况flag
%                         1     linprog收敛到解决方案X.
%                         0     达到了最大迭代次数。
%                         -2    没有找到可行的点。 
%                         -3    问题无限。
%                         -4    算法执行过程中遇到了NaN值。
%                         -5    原始和双重问题都是不可行的。 
%                         -7    搜索方向的大小过小; 没有进一步的 可以进步。 问题是病态或坏条件。
%   否则就用下面这个
[x,fval,existflag,output ]=intlinprog(f,intcon,A,b,Aeq,beq,lb,ub)%求解,注意优化问题定义最小值,-f
%	[X，FVAL，EXITFLAG] = intlinprog（f，intcon，A，b，...）
%   X是变量值
%   FVAl是函数的解FVAL = f'*X
%   EXTIFLAG是退出的情况flag
%	             2      求解器过早停止。发现整数可行点。
%	             1      找到最佳解决方案。
%	             0      解算器过早停止。没有找到整数可行点。
%	             -2     没有找到可行的点。
%	             -3     根LP的问题是无限的。
obj=sum(x.*f')+f_const;
disp(obj)


