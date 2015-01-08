
clc;

% clear all;

close all;

addpath(genpath('C:\Users\Pavel\Documents\MATLAB'));

c = 3e8;

L = 1;

f = c / L;

k = 2*pi / L;

dx = 0.05;

dy = 0.05;

dz = 0.05;

mu = 4*pi*1e-7;

N = 11;
half_l = L*0.25;

dipole = linspace(-half_l,half_l,N);

% dipole = [-L/2,L/2,0];

dl = dipole(2) - dipole(1);

Green = G(k);

J = Vector_field(Function3(@(c1,c2,c3)0),...
                 Function3(@(c1,c2,c3)0),...
                 Function3(@(c1,c2,c3)cos(k*c3)), 'cart');
             
 A = Green_integral(Green, J, 'no', 0,0,-half_l,0,0,half_l,1,1,dl,'cart');   

% for n = 1:N    
%         
% %     source = Coordinate(0,0,dipole(n));
%     
%     J_vector = J(Coordinate(0,0,dipole(n)));
%     
% %     Green = G(k);
%     
%     aux = Green('source', Coordinate(0,0,dipole(n)));
% 
%     if n == 1
%         
%         A = aux * J_vector;
%         
%     else
%         
%         A = A + (aux * J_vector);
%         
%     end
%     
% end

H = A.Curl(dx,dy,dz);

% Div_A = A.Div(dx, dy, dz);
% 
% E = A*(-1i*2*pi) + Div_A.Grad(dx,dy,dz)/1i/2/pi/eps/mu;

x = -2:0.1:2;

z = -2:0.1:2;

K = 1;

F(K) = struct('cdata',[],'colormap',[]);

phase = linspace(0,2*pi*(K-1)/K,K);

parpool(2);

for k = 1:K

    aux = zeros(length(x), length(z));

    for n = 1:length(x);

        parfor m = 1:length(z)

            if x(n) == 0 && z(m) <= half_l && z(m) >= -half_l

                aux(n,m) = 0;

            else

                aux(n,m) = abs(imag(H(Coordinate(x(n),0,z(m)))*exp(1i*phase(k))));

            end       

        end

        fprintf('n = %d\n',n);

    end

    surf_handle = pcolor(aux);

    set(surf_handle, 'EdgeColor', 'none');
    
    drawnow;
    
    F(k) = getframe;

end

delete(gcp);
%%

% filename = 'C:\Users\Pavel\Documents\MATLAB\Saved_figures\1_Lambda_dipole.gif';
% 
% for k = 1:K
% 
%     im = frame2im(F(k));
% 
%     [imind,cm] = rgb2ind(im,256);
% 
%     if k == 1;
% 
%       imwrite(imind,cm,filename,'gif', 'Loopcount',inf, 'DelayTime', 0.1);
% 
%     else
% 
%       imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime', 0.1);
% 
%     end
%     
% end
% 

































