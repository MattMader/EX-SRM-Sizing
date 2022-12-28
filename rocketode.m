function dydt = rocketode(~,y,x,rocket)

% unpack state vector
P0 = y(1); % [Pa] chamber pressure
s = y(2); % [m] linear burn distance
m = y(3); % [kg] rocket mass
h = y(4); % [m] rocket altitude
v = y(5); % [m/s] rocket velocity


% unpack design variables
D = x(1); % [m] grain outer diameter
d = x(2); % [m] grain inner diameter
L = x(3); % [m] total grain length
N = x(4); % [int] number of grain segments
A_star = x(5); % [m^2] nozzle throat area


% unpack required rocket parameters
m_pay = rocket.m_pay; % [kg] payload mass
f_inert = rocket.f_inert; % [1] inert mass fraction
k = rocket.gamma; % [1] specific heat ratio
R_g = rocket.R_g; % [J/kg/K] specific gas constant
T0 = rocket.T0; % [K] adiabatic flame temperature
rho_p = rocket.rho_p; % [kg/m^3] propellant solid density
a = rocket.a; % [cm/s/kPa^n] burn rate coefficient
n = rocket.n; % [1] burn rate exponent


% calculate derivated rocket parameters
m_prop = objfun(x,rocket); % [kg] propellant mass
m_inert = f_inert*m_prop; % [kg] inert mass
m_dry = m_inert + m_pay; % [kg] dry mass
S_ref = pi/4*D^2; % [m^2] aerodynamic reference area
R = d/2 + s; % [m] current grain inner radius
l = L/N - 2*s; % [m] current grain segment length


% constrain variables to their bounds
m = max(m,m_dry); % min mass is dry mass
P0 = max(P0,0); % P0 needs to be positive


% choked mass flow
m_dot = P0*A_star*sqrt(k/R_g/T0*(2/(k+1))^((k+1)/(k-1)));


% if still propellant left
if R < D/2 && l > 0
    r = a*(P0/1e3)^n/100; % [m/s] current burn rate
    A_b = N*(2*pi*R*l + 2*pi*(D^2/4-R^2)); % [m^2] current burn area
    V_c = N*(pi*R^2*l + pi/4*D^2*2*s); % [m^3] current chamber volume

% if propellant is all gone
else
    r = 0; % [m/s] no longer burning
    A_b = 0; % [m^2] no burn area
    V_c = pi/4*D^2*L; % [m^3] full chamber volume

end


% chamber pressure rate
P0_dot = R_g*T0/V_c*(A_b*rho_p*r-m_dot-P0/R_g/T0*A_b*r);


% current atmospheric conditions
[~,~,Pa,rho] = atmosisa(h); % [Pa,kg/m^3]


% nozzle exit pressure
Pe = 101300; % [Pa] assume this for now


% nozzle exit area
Ae = S_ref;


% thrust
if P0 > 101300
    F = k*P0*A_star*sqrt(2/(k-1)*(2/(k+1))^((k+1)/(k-1))*(1-(Pe./P0).^((k-1)/k))) + Ae*(Pe-Pa);
else
    F = 0;
end


% dynamic pressure
q = 0.5*rho*v^2; % [Pa]


% drag
D = -sign(v)*q*rocket.C_d*S_ref; % [N]


% acceleration
a = (F + D)/m - 9.81; % [m/s^2]


% state derivatives
dydt = [P0_dot; r; -m_dot; v; a];


end % function rocketode