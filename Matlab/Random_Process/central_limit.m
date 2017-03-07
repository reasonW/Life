close all
len=10000;
bin=50;
a=unifrnd(0,1,1,len);
a1=unifrnd(0,1,1,len);
a2=unifrnd(0,1,1,len);
a3=unifrnd(0,1,1,len);
a4=unifrnd(0,1,1,len);
subplot(4,4,1)
hist(a,bin)
xlabel('无叠加')
title('均匀分布,x~U(0,1)')
subplot(4,4,5)
hist(a+a1+a2,bin)
xlabel('二次叠加')
subplot(4,4,9)
hist(a+a1+a2,bin)
xlabel('三次叠加')
subplot(4,4,13)
hist(a+a1+a2+a3+a4,bin)
xlabel('五次叠加')

%%
b=randn(1,len);
b1=randn(1,len);
b2=randn(1,len);
b3=randn(1,len);
b4=randn(1,len);
subplot(4,4,2)
hist(b,bin)
title('高斯分布,x~N(0,1),')
xlabel('无叠加')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0.5];
h.EdgeColor = 'w';
subplot(4,4,6)
hist(b+b1,bin)
xlabel('二次叠加')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0.5];
h.EdgeColor = 'w';
subplot(4,4,10)
hist(b+b1+b2,bin)
xlabel('三次叠加')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0.5];
h.EdgeColor = 'w';
subplot(4,4,14)
hist(b+b1+b2+b3+b4,bin)
xlabel('五次叠加')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0.5];
h.EdgeColor = 'w';

%%
c=exprnd(5,1,len);
c1=exprnd(5,1,len);
c2=exprnd(5,1,len);
c3=exprnd(5,1,len);
c4=exprnd(5,1,len);
subplot(4,4,3)
hist(c,bin)
title('指数分布,mu=5')
xlabel('无叠加')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0];
h.EdgeColor = 'w';
subplot(4,4,7)
hist(c+c1,bin)
xlabel('二次叠加')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0];
h.EdgeColor = 'w';
subplot(4,4,11)
hist(c+c1+c2,bin)
xlabel('三次叠加')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0];
h.EdgeColor = 'w';
subplot(4,4,15)
hist(c+c1+c2+c3+c4,bin)
xlabel('五次叠加')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0];
h.EdgeColor = 'w';


%%
d=chi2rnd(5,1,len);
d1=chi2rnd(5,1,len);
d2=chi2rnd(5,1,len);
d3=chi2rnd(5,1,len);
d4=chi2rnd(5,1,len);
subplot(4,4,4)
hist(d,bin)
title('卡方分布,V=5')
xlabel('无叠加')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0.5];
h.EdgeColor = 'w';
subplot(4,4,8)
hist(d+d1,bin)
xlabel('二次叠加')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0.5];
h.EdgeColor = 'w';
subplot(4,4,12)
hist(d+d1+d2,bin)
xlabel('三次叠加')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0.5];
h.EdgeColor = 'w';
subplot(4,4,16)
hist(d+d1+d2+d3+d4,bin)
xlabel('五次叠加')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0.5];
h.EdgeColor = 'w';
