
%% clear workspace

% clear all;

close force all;

clc;

%% connect needed folders

addpath(genpath('C:\Users\Pavel\Documents\MATLAB'));

%% Control flags

plot_FF = 1; % plot normalized radiation curve

plot_current = 1; % plot surface current

compute_impedance = 1; % compute impedance at delta-gap

%% Define physical constants

c = 3e8;

mu = 4*pi*1e-7;

epsilon = 8.854e-12;

%% Define frequency - related constants

Lambda = 1;

f = c / Lambda;

w = 2*pi*f;

%% Define excitation

Delta_z_size = 0.001*Lambda;

Einc = Vector_field(Function3(@(c1,c2,c3)0),...
                    Function3(@(c1,c2,c3)0),...
                    Function3(@(c1,c2,c3)abs(c3) <= Delta_z_size/2),...
                    'cart');

%% Define scattering body (z-axed cylinder in this case)

half_l = 0.7311/2*Lambda; % half_l is half of the length of the dipole

% half_l = 1.1/2*Lambda; % half_l is half of the length of the dipole

% half_l = 1*Lambda; % half_l is half of the length of the dipole

R = 0.0025*Lambda; % R is radius of the dipole wire



%% Define current elements number

N_currents = 31;

currents_limits = linspace(-half_l, half_l, N_currents+2);

%% Define weighting functions number

N_weights = 2*N_currents+1;

weights_limits = linspace(-half_l, half_l, N_weights+2);

%% Define integration grid

N_height = 2*floor(2*half_l/R) + 1; % amount of points in z direction

N_phi = 1;

%% Define Green function

Green = G(w/c); % calls constructor of Green functions class

%% Define numeric differentiation constants

d_x = min([0.0005*Lambda, 2*half_l/N_height/5]);

d_y = min([0.0005*Lambda, 2*half_l/N_height/5]);

d_z = min([0.0005*Lambda, 2*half_l/N_height/5]);


%% Define base currents and their derivatives - Vector potentials and electric fields

Currents = cell(N_currents,1); % define cell array of currents at each of the points, two per point

Es = cell(N_currents,1); % define cell array of electric fields generated by each of the currents

parfor n = 1:N_currents % create array of E-field functions generated by base currents located on the side of the dipole
    
    aux1 = num2str(currents_limits(n),15);
    
    aux2 = num2str(currents_limits(n+2),15);
    
    aux3 = num2str(currents_limits(n+1),15);
    
    f_string = ['@(c1,c2,c3)(c3 >= (', aux1,'))*(c3 < (', aux2,'))*(1 - abs(c3/((',aux2,')-(',aux3,')) - (',aux3,')/((', aux2,')-(', aux3,'))))'];
    
    current_J = Vector_field(Function3(@(c1,c2,c3)0),...
                                Function3(@(c1,c2,c3)0),...
                                Function3(eval(f_string)),...
                                'cart'); % Define current in z direction
                            
    Currents{n} = current_J;
    
    N_height_in_support = ceil((currents_limits(n+1)-currents_limits(n)) / (2*half_l/N_height));
       
    Current_A = Green_integral(Green, current_J, 'no', 0, 0, currents_limits(n), 0, 0, currents_limits(n+2), 1, 1, N_height_in_support, 'cart'); % Compute vector potential produced by z current
      
    Es{n} = Current_A*(-1i*w) + Grad(Div(Current_A, d_x, d_y, d_z),d_x, d_y, d_z)*(1/(1i*w*epsilon*mu)); % Compute E-field produced by z current
       
    fprintf('Current number = %d\n', n);
       
end

%% Define weighting functions 

Weights = cell(N_weights,1);

parfor n = 1:N_weights
    
    aux1 = num2str(weights_limits(n),15);
    
    aux2 = num2str(weights_limits(n+2),15);
    
    aux3 = num2str(weights_limits(n+1),15);
    
    f_string = ['@(c1,c2,c3)(c3 >= (', aux1,'))*(c3 < (', aux2,'))*(1 - abs(c3/((',aux2,')-(',aux3,')) - (',aux3,')/((', aux2,')-(', aux3,'))))'];
    
    Weights{n} = Vector_field(Function3(@(c1,c2,c3)0),...
                              Function3(@(c1,c2,c3)0),...
                              Function3(eval(f_string)),...
                              'cart'); % Define weighting current in z direction
                          
    fprintf('Weight number = %d\n', n); 
    
end


%%  Create Z matrix and right-hand column vector

Z_Matrix = zeros(N_weights, N_currents); % initialize Z matrix

Result_col = zeros(N_weights,1); % initialize right hand column vector

waitbar_handle = waitbar(0,'Populating Z-matrix elements');


for m = 1:N_weights % calculate members of z matrx and results vector
    
    N_height_in_support = 2*floor(ceil((weights_limits(m+2)-weights_limits(m)) / (2*half_l/N_height))/2)+1;
    
    Result_col(m) = Integral(Einc * Weights{m}, R, 0, weights_limits(m), R, 2*pi*(N_phi-1)/N_phi, weights_limits(m+2), 1, N_phi, N_height_in_support, 'cyl');

    parfor n = 1:N_currents
        
        Z_Matrix(m,n) = Integral(Es{n} * Weights{m}, R, 0, weights_limits(m), R, 2*pi*(N_phi-1)/N_phi, weights_limits(m+2), 1, N_phi, N_height_in_support, 'cyl');
        
    end
    
    waitbar(m/N_weights, waitbar_handle);

end

close(waitbar_handle);

%% Compute coefficients of the MOM

Field_coefficients = ((Z_Matrix') * Z_Matrix) \ (Z_Matrix') * Result_col; % solve for coefficients in LMSE sense

msgbox(sprintf('Residual is %0.3e', sum(abs(Z_Matrix*Field_coefficients - Result_col))));

%% Assemble scattered field

Es_ext = cell(N_currents,1);   

parfor n = 1:N_currents % Compute E-fields of base currents multiplied by found coefficients. Utilizes simpler Green integral form than one used in matching points
    
       Es_ext{n} = Es{n}*Field_coefficients(n);
       
       fprintf('Current = %d\n', n);
    
end

waitbar_handle = waitbar(0,'Assembling scattered field ');

for n = 1:N_currents % Summarize fields of adjusted base currents to get total scattered field

    if n == 1

        Scattered_field = Es_ext{n};
 
    else

        Scattered_field = Scattered_field + (Es_ext{n});

    end

    waitbar(n/N_currents, waitbar_handle);

end

close(waitbar_handle);


%% Visualize Far Field

if plot_FF % plot far-field radiation curves

    figure;

    Far_R = 10000; % choosing distance which is >> Lambda certainly >> than dipole size

    N_teta = 101;

    FF_E_sc = zeros(1, N_teta);
    
    FF_E_theoretical = zeros(1, N_teta);

    teta = linspace(0,2*pi,N_teta);

    for n = 1:N_teta

        FF_E_sc(n) = abs(Scattered_field(Coordinate(Far_R*sin(teta(n)), 0, Far_R*cos(teta(n)))));

        if sin(teta(n)) == 0
            
            FF_E_theoretical(n) = 0;
            
        else
        
            FF_E_theoretical(n) = (cos(w/c*half_l*cos(teta(n))) - cos(w/c*half_l))/sin(teta(n));
            
        end
        
    end
    

    polar(teta, FF_E_sc / max(FF_E_sc), '-b');
    
    hold on;
    
    polar(teta, abs(FF_E_theoretical/max(FF_E_theoretical)), '-r');
    
    hold off;
    
    legend('Computed', 'Theoretical');
    
    view([90 -90]);

end

%% Visualize current_distribution


if plot_current
    
    for n = 1:N_currents
        %% 
    
        if n == 1

            Cumulative_current = Currents{n} * Field_coefficients(n);

        else

            Cumulative_current = Cumulative_current + Currents{n} * Field_coefficients(n);

        end       
    
    end
    
    Current_to_plot = zeros(1, N_height);
    
    height = linspace(-half_l, half_l, N_height);
    
    for n = 1:N_height
        
        Current_to_plot(n) = abs(Cumulative_current(Coordinate(0,0,height(n))));
        
    end

    figure();
        
    plot(height, Current_to_plot);
    
    title('Z directed currents map');
    
    xlabel('Z'); ylabel('Currents,[A]');
        
end

%% Compute antenna impedance

if compute_impedance

    Summary_current = Cumulative_current(Coordinate(0,0,Delta_z_size/2));
    
    Summary_current = Summary_current.value(3);

    Einc_at_the_middle_of_dipole_surface = Scattered_field(Coordinate(R, 0, 0, 'cyl'));

    Feed_voltage = Delta_z_size * Einc_at_the_middle_of_dipole_surface.value(3);

    Z_dipole = -Feed_voltage / Summary_current; % minus is necessary because E fiield direction inside magnetic current ring is inverse to one seen at the outside

    msgbox(sprintf('Computed antenna impedance is %s', num2str(Z_dipole)));

end

