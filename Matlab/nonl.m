x0=rand(2,1);
A=[];B=[];Aeq=[];Beq=[];LB=zeros(2,1);UB=[];% A,�����Բ���ʽԼ��;B,�����Ե�ʽԼ��
options=optimset;                           %options�������Ż�����
[x,fval]=fmincon('nonl_main',x0,A,B,Aeq,Beq,LB,UB,'nonl_con',options)
