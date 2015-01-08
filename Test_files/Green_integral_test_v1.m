clc;

clear all;

close all;

J = Vector_field(Function3(@(c1,c2,c3)0), Function3(@(c1,c2,c3)0), Function3(@(c1,c2,c3)1),'cart');

Lambda = 1;

mu = 4*pi*1e-7;

epsilon = 8.854e-12;

c = 3e8;

w = c/Lambda*2*pi;

Green = G(2*pi/Lambda);

A = Green_integral(Green, J, 'no', 0.1,0,0,0.1,0,0,1,1,1, 'cyl');

aux = A.Div(0.01,0.01,0.01);

E = A*(-1i*w) + aux.Grad(0.01,0.01,0.01)/(1i*w*mu*epsilon);

x_axis = -3:0.1:3;
z_axis = -3:0.1:3;

F = zeros(length(z_axis), length(x_axis));

for n = 1:length(x_axis)
    parfor m = 1:length(z_axis)
        
        F(m,n) = abs(imag(E(Coordinate(x_axis(n), 0, z_axis(m)))));
        
    end
    
    n
end

pcolor(F);

axis square;

N_teta = 101;

teta = linspace(0,2*pi,N_teta);

E_FF = zeros(1, N_teta);

R = 1000;

for n = 1:N_teta
    
    E_FF(n) = abs((E(Coordinate(R*sin(teta(n)), 0, R*cos(teta(n))))));
    
end

figure;

polar(teta, E_FF);

view([90 -90]);

axis square;
    