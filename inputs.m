%% Clear
clear
close all
clc;

%% Generate parameter structure

% Animal Motor Works: Blue Baboon
rocket.rho_p = 1260; % [kg/m^3] propellant density
rocket.a = 0.132; % [cm/s/kPa^n] burn rate coefficient
rocket.n = 0.16; % [1] burn rate exponent
rocket.gamma = 1.18; % [1] specific heat ratio
rocket.R_g = 8314/23; % [J/kg/K] specific gas constant
rocket.T0 = 2900; % [k] adiabatic flame temperature

% Student-built airframe
rocket.m_pay = 4; % [kg] payload mass
rocket.f_inert = 0.785; % [kg] inert mass fraction
rocket.C_d = 0.5; % [1] drag coefficient

%% Test design variables

x = zeros(5,1);
x(1) = 0.066; % [m] grain outer diameter
x(2) = 0.03; % [m] grain inner diameter
x(3) = 0.35; % [m] total grain length
x(4) = 3; % [1] number of grain segments
x(5) = 1.887e-4; % [m^2] nozzle throat area

%% Simulate


f = objfun(x,rocket);


%%
tic
g = consfun(x,rocket);
toc

%%

[t,P0,s,m,h,v,a,q] = sim_rocket(x,rocket);

%% plot

figure(1)
plot(t,q)
grid on