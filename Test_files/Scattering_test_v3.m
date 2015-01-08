
%% clear workspace

clear all;

close force all;

clc;

%% connect needed folders

addpath(genpath('C:\Users\Pavel\Documents\MATLAB'));

%% Control flags

use_radial = 0;

plot_incoming = 0;

plot_scattered = 0;

plot_total = 0;

plot_FF = 1;

%% Define physical constants

c = 3e8;

mu = 4*pi*1e-7;

epsilon = 8.854e-12;

%% Define frequency - related constants and Green function

Lambda = 1;

f = c / Lambda;

w = 2*pi*f;

%% Define space for Near-Field calculation

x_min = -1; x_max = 1; N_x = 101; x_axis = linspace(x_min, x_max, N_x);

y_min = -1; y_max = 1; N_y = 101; y_axis = linspace(y_min, y_max, N_y);

z_min = -1; z_max = 1; N_z = 101; z_axis = linspace(z_min, z_max, N_z);

%% Define scattering body (z-axed cylinder in this case)

half_l = 0.25*Lambda;

R = 0.005*Lambda;


%% Define and plot incoming field

% k = Vector(1/sqrt(2),0,-1/sqrt(2)) * 2*pi/Lambda;

k = Vector(1,0,0) * 2*pi/Lambda;

% Einc = Vector_field(Function3(@(c1,c2,c3)1/sqrt(2)*exp(-1i*(k * Coordinate(c1,c2,c3,'cart')))),...
%                     Function3(@(c1,c2,c3)0),...
%                     Function3(@(c1,c2,c3)1/sqrt(2)*exp(-1i*(k * Coordinate(c1,c2,c3,'cart')))),...
%                     'cart');

Einc = Vector_field(Function3(@(c1,c2,c3)0),...
                    Function3(@(c1,c2,c3)0),...
                    Function3(@(c1,c2,c3)1*exp(-1i*(k * Coordinate(c1,c2,c3,'cart')))),...
                    'cart');

if plot_incoming                
                
    E_field_inc = zeros(N_z, N_x);

    for nz = 1:N_z

        parfor nx = 1:N_x

            if ~(abs(x_axis(nx)) < r && abs(z_axis(nz)) < half_l)

                E_field_inc(nz,nx) = abs(real(Einc(Coordinate(x_axis(nx), 0, z_axis(nz)))));                

            end

        end

        fprintf('Evaluating nz = %d\n', nz);

    end

    delete(gcp);

    figure();

    surf_handle = pcolor(E_field_inc);

    set(surf_handle, 'EdgeColor', 'none');

    xlabel('X'); ylabel('Z'); title('Incoming E-field');

end

%% Define Green function

Green = G(abs(k));

%% Define meshing 

N_height = 5;

N_phi = 5;

N_radius = 1;

radius = linspace(R/(N_radius+1), R - R/(N_radius+1), N_radius);

height = linspace(-half_l, half_l, N_height);

phi = linspace(0, 2*pi*(N_phi - 1)/N_phi, N_phi);

if N_radius > 1 

    d_r = radius(2) - radius(1);
    
else
    
    d_r = 1;
    
end

if N_height > 1

    d_h = height(2) - height(1);

else
    
    d_h = 1;
    
end

if N_phi > 1

    d_p = phi(2) - phi(1);
    
else
    
    d_p = 1;
    
end

%% Define normals

Side_normals = Vector_field(Function3(@(c1,c2,c3)c1*cos(c2)),...
                            Function3(@(c1,c2,c3)c1*sin(c2)),...
                            Function3(@(c1,c2,c3)0), 'cyl');
                        
Top_normals = Vector_field(Function3(@(c1,c2,c3)0),...
    Function3(@(c1,c2,c3)0),...
    Function3(@(c1,c2,c3)1), 'cyl');

Bottom_normals = Vector_field(Function3(@(c1,c2,c3)0),...
    Function3(@(c1,c2,c3)0),...
    Function3(@(c1,c2,c3)-1), 'cyl');



%% Define numeric differentiation constants

% d_x = min([0.001*Lambda, d_r/5, d_h/5]);
% 
% d_y = min([0.001*Lambda, d_r/5, d_h/5]);
% 
% d_z = min([0.001*Lambda, d_r/5, d_h/5]);

d_x = 0.001;

d_y = 0.001;

d_z = 0.001;

%% Define base currents and their derivatives - Vector potentials and electric fields

Coordinates = cell(N_height * N_phi + 2*N_radius*N_phi,1);

Currents = cell(N_height * N_phi * 2 + 4*N_radius*N_phi,1);

As = cell(N_height * N_phi * 2 + 4*N_radius*N_phi,1); % This needs to be replaced afterwards to accomodate actual amount of vector currents 

Es = cell(N_height * N_phi * 2 + 4*N_radius*N_phi,1); % This needs to be replaced afterwards to accomodate actual amount of vector currents 

counter = 1;

waitbar_handle = waitbar(0,'Calculating fields of base currents');

for h = 1:N_height
    
    for p = 1 : N_phi
        
       Coordinates{counter} = Coordinate(R, phi(p), height(h), 'cyl'); 

       current_J = Vector_field(Function3(@(c1,c2,c3)0),...
                                Function3(@(c1,c2,c3)0),...
                                Function3(@(c1,c2,c3)(c1 == R)*(abs(c2 - phi(p)) < d_p/2)*(abs(c3 - height(h)) < d_h/2)),...
                                'cyl');
                            
       Currents{2*counter-1} = current_J;
       
       As{2*counter-1} = Green_integral(Green, current_J, 'yes', R, phi(1), height(1), R, phi(end), height(end), d_r, d_p, d_h, 'cyl');
      
       Es{2*counter-1} = As{2*counter-1}*(-1i*w) + Grad(Div(As{2*counter-1}, d_x, d_y, d_z),d_x, d_y, d_z)*(1/(1i*w*epsilon*mu));
       
       current_J = Vector_field(Function3(@(c1,c2,c3)(c1 == R)*(abs(c2 - phi(p)) < d_p/2)*(abs(c3 - height(h)) < d_h/2)*(-sin(c2))),...
                                Function3(@(c1,c2,c3)(c1 == R)*(abs(c2 - phi(p)) < d_p/2)*(abs(c3 - height(h)) < d_h/2)*(cos(c2))),...
                                Function3(@(c1,c2,c3)0),...
                                'cyl');
       
       Currents{2*counter} = current_J;
       
       As{2*counter} = Green_integral(Green, current_J, 'yes', R, phi(1), height(1), R, phi(end), height(end), d_r, d_p, d_h, 'cyl');
       
       Es{2*counter} = As{2*counter}*(-1i*w) + Grad(Div(As{2*counter}, d_x, d_y, d_z),d_x, d_y, d_z)*(1/(1i*w*epsilon*mu));

       counter = counter + 1; 
        
    end

    waitbar(counter/(N_height*N_phi+2*N_radius*N_phi), waitbar_handle);
    
end

if use_radial

    for r = 1:N_radius

        for p = 1 : N_phi

           Coordinates{counter} = Coordinate(radius(r), phi(p), half_l, 'cyl'); 

           current_J = Vector_field(Function3(@(c1,c2,c3)(abs(c1 - radius(r)) < d_r)*(abs(c2 - phi(p)) < d_p/2)*(c3 == half_l) * cos(c2)),...
                                    Function3(@(c1,c2,c3)(abs(c1 - radius(r)) < d_r)*(abs(c2 - phi(p)) < d_p/2)*(c3 == half_l) * sin(c2)),...
                                    Function3(@(c1,c2,c3)0),...
                                    'cyl');

           Currents{2*counter-1} = current_J;

           As{2*counter-1} = Green_integral(Green, current_J, 'yes', radius(1), phi(1), half_l, radius(end), phi(end), half_l, d_r, d_p, d_h, 'cyl');

           Es{2*counter-1} = As{2*counter-1}*(-1i*w) + Grad(Div(As{2*counter-1}, d_x, d_y, d_z),d_x, d_y, d_z)*(1/(1i*w*epsilon*mu));

           current_J = Vector_field(Function3(@(c1,c2,c3)(abs(c1 - radius(r)) < d_r/2)*(abs(c2 - phi(p)) < d_p/2)*(c3 == half_l)*(-sin(c2))),...
                                     Function3(@(c1,c2,c3)(abs(c1 - radius(r)) < d_r/2)*(abs(c2 - phi(p)) < d_p/2)*(c3 == half_l)*(cos(c2))),...
                                     Function3(@(c1,c2,c3)0),...
                                     'cyl');

           Currents{2*counter} = current_J;

           As{2*counter} = Green_integral(Green, current_J, 'yes', radius(1), phi(1), half_l, radius(end), phi(end), half_l, d_r, d_p, d_h, 'cyl');

           Es{2*counter} = As{2*counter}*(-1i*w) + Grad(Div(As{2*counter}, d_x, d_y, d_z),d_x, d_y, d_z)*(1/(1i*w*epsilon*mu));

           counter = counter + 1; 

        end

        waitbar(counter/(N_height*N_phi+2*N_radius*N_phi), waitbar_handle);

    end

    for r = 1:N_radius

        for p = 1 : N_phi

           Coordinates{counter} = Coordinate(radius(r), phi(p), -half_l, 'cyl'); 

           current_J = Vector_field(Function3(@(c1,c2,c3)(abs(c1 - radius(r)) < d_r)*(abs(c2 - phi(p)) < d_p/2)*(c3 == -half_l) * cos(c2)),...
                                    Function3(@(c1,c2,c3)(abs(c1 - radius(r)) < d_r)*(abs(c2 - phi(p)) < d_p/2)*(c3 == -half_l) * sin(c2)),...
                                    Function3(@(c1,c2,c3)0),...
                                    'cyl');

           Currents{2*counter-1} = current_J;

           As{2*counter-1} = Green_integral(Green, current_J, 'yes', radius(1), phi(1), -half_l, radius(end), phi(end), -half_l, d_r, d_p, d_h, 'cyl');

           Es{2*counter-1} = As{2*counter-1}*(-1i*w) + Grad(Div(As{2*counter-1}, d_x, d_y, d_z),d_x, d_y, d_z)*(1/(1i*w*epsilon*mu));

           current_J = Vector_field(Function3(@(c1,c2,c3)(abs(c1 - radius(r)) < d_r/2)*(abs(c2 - phi(p)) < d_p/2)*(c3 == -half_l)*(-sin(c2))),...
                                     Function3(@(c1,c2,c3)(abs(c1 - radius(r)) < d_r/2)*(abs(c2 - phi(p)) < d_p/2)*(c3 == -half_l)*(cos(c2))),...
                                     Function3(@(c1,c2,c3)0),...
                                     'cyl');

           Currents{2*counter} = current_J;

           As{2*counter} = Green_integral(Green, current_J, 'yes', radius(1), phi(1), -half_l, radius(end), phi(end), -half_l, d_r, d_p, d_h, 'cyl');

           Es{2*counter} = As{2*counter}*(-1i*w) + Grad(Div(As{2*counter}, d_x, d_y, d_z),d_x, d_y, d_z)*(1/(1i*w*epsilon*mu));

           counter = counter + 1; 

        end

        waitbar(counter/(N_height*N_phi+2*N_radius*N_phi), waitbar_handle);

    end

end

close(waitbar_handle);

counter = counter - 1;

%%  Create matrixes

Z_Matrix = zeros(counter);

Result_col = zeros(counter,1);

waitbar_handle = waitbar(0,'Populating Z-matrix elements');

for m = 1:counter
    
    if m <= N_height * N_phi

        Current_normal = Side_normals(Coordinates{m});
    
    elseif m > N_height*N_phi && m <= N_height*N_phi + N_phi*N_radius
        
        Current_normal = Top_normals(Coordinates{m});
        
    else
        
        Current_normal = Bottom_normals(Coordinates{m});
        
    end
    
    span1 = Vector(1,0,0) & Current_normal;
    
    span2 = Vector(0,1,0) & Current_normal;
    
    span3 = Vector(0,0,1) & Current_normal;
    
    if abs(span1) < abs(span2) && abs(span1) < abs(span3)
        
        Current_span1 = span2 / abs(span2);
        
        Current_span2 = span3 / abs(span3);
        
    elseif abs(span2) < abs(span1) && abs(span2) < abs(span3)
        
        Current_span1 = span1 / abs(span1);
        
        Current_span2 = span3 / abs(span3);
        
    elseif abs(span3) < abs(span1) && abs(span3) < abs(span2)
        
        Current_span1 = span1 / abs(span1);
        
        Current_span2 = span2 / abs(span2);
        
    else
        
        Current_span1 = span1 / abs(span1);
        
        Current_span2 = span2 / abs(span2);
        
    end

    Current_inc_E = Einc(Coordinates{m});

    Result_col(2*m-1) = Current_inc_E * Current_span1;
    
    Result_col(2*m) = Current_inc_E * Current_span2;

    for n = 1:2*counter
        
        Current_E = Es{n}(Coordinates{m});

        Z_Matrix(2*m-1,n) = Current_E * Current_span1;
        
        Z_Matrix(2*m,n) = Current_E * Current_span2;
        
    end
    
    waitbar(m/counter, waitbar_handle);

end

close(waitbar_handle);

%% Compute coefficients of the MOM and assemble scattered field

Field_coefficients = Z_Matrix \ Result_col;

waitbar_handle = waitbar(0,'Calculating fields of adjusted base currents');

As_ext = cell(counter*2,1); % This needs to be replaced afterwards to accomodate actual amount of vector currents 

Es_ext = cell(counter*2,1); % This needs to be replaced afterwards to accomodate actual amount of vector currents 

for n = 1:counter
    
       current_J = Currents{2*n-1}*Field_coefficients(2*n-1);
       
       As_ext{2*n-1} = Green_integral(Green, current_J, 'no', R, phi(1), height(1), R, phi(end), height(end), d_r, d_p, d_h, 'cyl');
      
       Es_ext{2*n-1} = As_ext{2*n-1}*(-1i*w) + Grad(Div(As_ext{2*n-1}, d_x, d_y, d_z),d_x, d_y, d_z)*(1/(1i*w*epsilon*mu));
       
       current_J = Currents{2*n}*Field_coefficients(2*n);
       
       As_ext{2*n} = Green_integral(Green, current_J, 'no', R, phi(1), height(1), R, phi(end), height(end), d_r, d_p, d_h, 'cyl');
       
       Es_ext{2*n} = As_ext{2*n}*(-1i*w) + Grad(Div(As_ext{2*n}, d_x, d_y, d_z),d_x, d_y, d_z)*(1/(1i*w*epsilon*mu));

       waitbar(n/counter, waitbar_handle);
    
end

close(waitbar_handle);

% counter = (counter - 1)*2;

waitbar_handle = waitbar(0,'Assembling scattered field ');

for n = 1:counter

    if n == 1

        Scattered_field = Es_ext{n};
 
    else

        Scattered_field = Scattered_field + (Es_ext{n});

    end

    waitbar(n/counter, waitbar_handle);

end

close(waitbar_handle);

%% Visualize Near field

if plot_total
 
    waitbar_handle = waitbar(0,'Calculating total field at given points');
                
    E_field_sc = zeros(N_z, N_x);

    for nz = 1:N_z

        parfor nx = 1:N_x

            if ~(abs(x_axis(nx)) <= R && abs(z_axis(nz)) <= half_l)

               E_field_sc(nz,nx) = abs(imag(Einc(Coordinate(x_axis(nx), 0, z_axis(nz))) + Scattered_field(Coordinate(x_axis(nx), 0, z_axis(nz)))));
%                     E_field_sc(nz,nx) = abs(imag(Es_ext{1}(Coordinate(x_axis(nx), 0, z_axis(nz)))));

            end

        end

        waitbar(nz/N_z, waitbar_handle);

    end

    close(waitbar_handle);

    delete(gcp);

    figure();

    surf_handle = pcolor(x_axis, z_axis, E_field_sc);

    set(surf_handle, 'EdgeColor', 'none');

    xlabel('X'); ylabel('Z'); title('Total E-field');

end

if plot_scattered
 
    waitbar_handle = waitbar(0,'Calculating scattered field at given points');
                
    E_field_sc = zeros(N_z, N_x);

    for nz = 1:N_z

        parfor nx = 1:N_x

            if ~(abs(x_axis(nx)) <= R && abs(z_axis(nz)) <= half_l)

               E_field_sc(nz,nx) = abs(imag(Scattered_field(Coordinate(x_axis(nx), 0, z_axis(nz)))));
%                     E_field_sc(nz,nx) = abs(imag(Es_ext{1}(Coordinate(x_axis(nx), 0, z_axis(nz)))));

            end

        end

        waitbar(nz/N_z, waitbar_handle);

    end

    close(waitbar_handle);

    delete(gcp);

    figure();

    surf_handle = pcolor(x_axis, z_axis, E_field_sc);

    set(surf_handle, 'EdgeColor', 'none');

    xlabel('X'); ylabel('Z'); title('Scattered E-field');

end


%% Visualize Far Field

if plot_FF

    figure;

    R = 1000;

    N_teta = 101;

    FF_E_sc = zeros(1, N_teta);

    teta = linspace(0,2*pi,N_teta);

    for n = 1:N_teta

        FF_E_sc(n) = abs(imag(Scattered_field(Coordinate(R*sin(teta(n)), 0, R*cos(teta(n))))));

    end
    
    

    polar(teta, FF_E_sc / max(FF_E_sc), '-b');
    
    hold on;
    
    polar(teta, abs(sin(teta)), '-r');
    
    hold off;
    
    legend('Computed', 'Theoretical');

end
    
view([90 -90]);


