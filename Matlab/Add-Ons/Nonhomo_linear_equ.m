%���������Է�����
function Nonhomo_liner_equ(A,b)
if nargin ==0
    A=[1 -2 3 -1;3 -1 5 -3 ;2 1 2 -2];
    b=[1 2 3]';
elseif nargin ~=2
    disp('����������A�����b����')
    A=input('����A:');
    b=input('����b:');
end
a=size(A);
n=a(2);
%��������Է��������
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

