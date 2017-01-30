%解非齐次线性方程组
function Nonhomo_liner_equ(A,b)
if nargin ==0
    A=[1 -2 3 -1;3 -1 5 -3 ;2 1 2 -2];
    b=[1 2 3]';
elseif nargin ~=2
    disp('请重新输入A矩阵和b矩阵')
    A=input('输入A:');
    b=input('输入b:');
end
a=size(A);
n=a(2);
%非齐次线性方程组求解
B=[A b];
RA=rank(A);
RB=rank(B);
spr=sprintf('RA: %d, RB: %d',RA,RB);
disp(spr);
format rat;
if RA==RB & RA==n
    X=A\b
elseif RA==RB & RA<n
    X=A\b;
    C=null(A,'r');
    syms k1 k2;
    Nonhomo_liner_equate = k1*C(:,1)+k2*C(:,2)+X
else X='equition no solve'
end
end

