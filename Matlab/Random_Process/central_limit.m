%%验证中心极限定理，画出钟形图，并对分布进行正态分布检验
%%
%%
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
xlabel('one random variables')
title('均匀分布,x~U(0,1)')
subplot(4,4,5)
hist(a+a1,bin)
xlabel('Two random variables')
subplot(4,4,9)
hist(a+a1+a2,bin)
xlabel('three random variables')
subplot(4,4,13)
hist(a+a1+a2+a3+a4,bin)      %%钟形图
xlabel('five random variables')
h_a =lillietest(a+a1+a2+a3+a4) %%正态分布检验



%%
b=randn(1,len);
b1=randn(1,len);
b2=randn(1,len);
b3=randn(1,len);
b4=randn(1,len);
subplot(4,4,2)
hist(b,bin)
title('高斯分布,x~N(0,1),')
xlabel('one random variables')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0.5];
h.EdgeColor = 'w';
subplot(4,4,6)
hist(b+b1,bin)
xlabel('Two random variables')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0.5];
h.EdgeColor = 'w';
subplot(4,4,10)
hist(b+b1+b2,bin)
xlabel('three random variables')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0.5];
h.EdgeColor = 'w';
subplot(4,4,14)
hist(b+b1+b2+b3+b4,bin)      %%钟形图
xlabel('five random variables')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0.5];
h.EdgeColor = 'w';
h_b =lillietest(b+b1+b2+b3+b4) %%正态分布检验
%%
c=exprnd(5,1,len);
c1=exprnd(5,1,len);
c2=exprnd(5,1,len);
c3=exprnd(5,1,len);
c4=exprnd(5,1,len);
subplot(4,4,3)
hist(c,bin)
title('指数分布,mu=5')
xlabel('one random variables')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0];
h.EdgeColor = 'w';
subplot(4,4,7)
hist(c+c1,bin)
xlabel('Two random variables')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0];
h.EdgeColor = 'w';
subplot(4,4,11)
hist(c+c1+c2,bin)
xlabel('three random variables')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0];
h.EdgeColor = 'w';
subplot(4,4,15)
hist(c+c1+c2+c3+c4,bin)      %%钟形图
xlabel('five random variables')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0.5 0];
h.EdgeColor = 'w';
h_c =lillietest(c+c1+c2+c3+c4) %%正态分布检验

%%
d=chi2rnd(5,1,len);
d1=chi2rnd(5,1,len);
d2=chi2rnd(5,1,len);
d3=chi2rnd(5,1,len);
d4=chi2rnd(5,1,len);
subplot(4,4,4)
hist(d,bin)
title('卡方分布,V=5')
xlabel('one random variables')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0.5];
h.EdgeColor = 'w';
subplot(4,4,8)
hist(d+d1,bin)
xlabel('Two random variables')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0.5];
h.EdgeColor = 'w';
subplot(4,4,12)
hist(d+d1+d2,bin)
xlabel('three random variables')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0.5];
h.EdgeColor = 'w';
subplot(4,4,16)
hist(d+d1+d2+d3+d4,bin)      %%钟形图
xlabel('five random variables')
h = findobj(gca,'Type','patch');
h.FaceColor = [0 0 0.5];
h.EdgeColor = 'w';
h_d =lillietest(d+d1+d2+d3+d4) %%正态分布检验
 
for ai=0:10000
    a=a+unifrnd(0,1,1,len);
    h_a_ =lillietest(a);
    if h_a_ == 0
        ai
        figure
        hist(a)
        break;
    end
end
disp('end')
for ci=0:10000
    c=c+exprnd(5,1,len);
    h_c_ =lillietest(c);
    if h_c_ == 0
        ci
        figure
        hist(c)
        break;
    end
end
disp('end')
for di=0:10000
    d=d+chi2rnd(5,1,len);
    h_d_ =lillietest(d);
    if h_d_ == 0
        di
        figure
        hist(d)
        break;
    end
end
disp('end')