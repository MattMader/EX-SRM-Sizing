function [t,P0,s,m,h,v,a,q] = sim_rocket(x,rocket)

% ode solver options
opts = odeset('RelTol',1e-4,'Events',@eventsfun);


% calculate initial mass
m_prop = objfun(x,rocket); % [kg] propellant mass
m_inert = rocket.f_inert*m_prop/(1-rocket.f_inert); % [kg] inert mass
m_dry = m_inert + rocket.m_pay; % [kg] dry mass
m_wet = m_dry + m_prop;


% initial conditions
y0 = [101300; 0; m_wet; 0; 0];


% time span (sim should stop via events before tf)
tspan = [0,99];


% simulation
[t,y] = ode45(@(t,y)rocketode(t,y,x,rocket),tspan,y0,opts);


% unpack state vector
P0 = y(:,1)/1e5; % [bar] chamber pressure
s = y(:,2); % [m] linear burn distance
m = y(:,3); % [kg] rocket mass
h = y(:,4); % [m] rocket altitude
v = y(:,5); % [m/s] rocket velocity


% estimate acceleration (pretty close from numerical testing)
a = [-9.81; diff(v)./diff(t)]/9.81; % [g]


% atmospheric conditions
[~,~,~,rho] = atmosisa(h); % [kg/m^3]


% calculate dynamic pressure
q = 0.5*rho.*v.^2/1e3; % [kPa]


end