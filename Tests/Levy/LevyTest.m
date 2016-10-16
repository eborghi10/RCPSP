clear;
clc;

%% DISTRIBUCIÓN DE PROBABILIDAD DE LÉVY FLIGHT

tic;
y = [];
alpha = 1.5;
s = 5.9;
%s = (gamma(1+alpha)*sin(pi*alpha/2)/(gamma((1+alpha)/2)*alpha*2^((alpha-1)/2)))^(1/alpha);
%I = [0:1:100];
I = rand(1,1000);

for i = I 
    y = [ y ; exp(-s*i^alpha) ];
    %y = [ y ; i^(-1/alpha) ];
end

figure(1);
plot(I,y);
figure(2);
scatter(I,y);
toc;

%% ESFERA TRIDIMENSIONAL
%{
step = 10000;
a=zeros(1,step);
b=zeros(1,step);
c=zeros(1,step);

for n=2:step;
    theta=rand*2*pi;
    phi = rand*pi;
    f=exp(-s*rand^alpha);
    a(n)=a(n-1)+f*cos(theta)*sin(phi);
    b(n)=b(n-1)+f*sin(theta)*sin(phi);
    c(n)=c(n-1)+f*cos(phi);
    if a(n)^2 + b(n)^2 + c(n)^2 > 10
        a(n) = a(n-1);
        b(n) = b(n-1);
        c(n) = c(n-1);
    end
end;

figure('color', 'white');
axis equal off;
line(a,b,c);
%}