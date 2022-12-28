function f = objfun(x,rocket)

% unpack design variables
D = x(1); % [m] grain outer diameter
d = x(2); % [m] grain inner diameter
L = x(3); % [m] total grain length

% unpack required rocket parameters
rho_p = rocket.rho_p; % [kg/m^3] propellant solid density

% mass of propellant
f = rho_p*pi/4*(D^2-d^2)*L; % [kg]

end