alpha=1.5;
s=1000;
x=zeros(1,s);
y=zeros(1,s);

for n=2:s;
    theta=rand*2*pi;
    f=rand^(-1/alpha);
    x(n)=x(n-1)+f*cos(theta);
    y(n)=y(n-1)+f*sin(theta);
end;

figure('color', 'white');
axis equal off;
line(x,y);