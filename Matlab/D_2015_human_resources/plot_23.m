%同一幅图画不同函数曲线
close all;%关闭其他所有窗口
x0=0:pi/200: 2*pi;
%x=linspace(0,2*pi,60);%enerates 60 points between 0 and 2*pi.
a=sin(x0);
b=cos(x0);
% subplot(2,2,1);
% figure
plot(x0,a,'r.',x0,b,'b-.');
%函数绘图,'函数名',函数范围,误差值
%fplot('[sin(x),cos(x)]',[0 2*pi],1e-3,'r-')
axis([0,2*pi,-2,2]);%sets scaling for the x- and y-axes on the current plot.
legend('sin(x)','cos(x)')
text(2.8,0.5,'sin(x)');
text(1.4,0.3,'cos(x)');
%特殊函数绘图
%对对数,对数坐标系,双轴对数坐标转换
x1=0:pi/200:2*pi;
y1=abs(1000*sin(4*x1))+1;
% subplot(2,2,2);
figure
loglog(x1,y1,'-')
grid on
%单对数,单轴对数坐标转换
figure
semilogx(x1,y1)
grid on
figure
semilogy(x1,y1)
grid on
%极坐标绘制
theta=0:0.01:2*pi;
y2=sin(2*theta).*cos(2*theta);
figure
polar(theta,y2)
x3=-3:0.25:3;
y3=exp(-x3.*x3);
figure
stairs(x3,y3)
bar(x3,y3)
%plot3
figure
plot3(a,b,x0);
title('helix'),text(0,0,1,'hhh')
xlabel('sin(x)'),ylabel('cos(x)'),zlabel('x')
%mesh
figure
x4=0:0.15:2*pi;
y4=0:0.15:2*pi;
z4=sin(y4')*cos(x4);
mesh(x4,y4,z4)
view(-2.5,3)%agree from -y and -z
figure
surf(x4,y4,z4)
figure
contour3(x4,y4,z4,8)
