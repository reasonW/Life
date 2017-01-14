function [g,ceq]=nonl_con(x);
g=-x(1)^2+x(2);
ceq=-x(1)-x(2)^2+2;