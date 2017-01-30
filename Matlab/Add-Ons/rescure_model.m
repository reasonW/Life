function [g1,x]=rescure_model()
load('rescure.mat')
Qa=4;
xg1=[ 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 ];
s=-1;
y=zeros(5,1);
P0=0;
for j=1:5
    if Tla(j)>Ta(j) && j<=Qa
        y(j)=1;
    end
    P0=P0+(1-Ta(j)/Tla(j))*Aa(j)*y(j);
end
Pv=Av;
Q0=2000;
Qv=Tv.*Av;
G11=0;G12=0;
while(1)
    s=s+1;
    x=xg1;
    for i=1:15
        G11=G11+Pv(i)*x(i);
        G12=G12+Qv(i)*x(i);
    end
    G1=(G11+P0)/(G12+Q0);
    x=zeros(1,15);
    [g1,x]=max((G11+P0)-G1*(G12+Q0));
    
    if(g1==0)
        break;
    else
        disp(s);
    end
end
end

    