function g = consfun(x,rocket)

% unpack design variables
D = x(1); % [m] grain outer diameter
d = x(2); % [m] grain inner diameter
L = x(3); % [m] total grain length
A_star = x(5); % [m^2] nozzle throat area


% simulate the rocket + motor
[~,P0,~,~,h,~,a,q] = sim_rocket(x,rocket);


% initialize contraints
g = zeros(7,1);


% grain D/d constraint
g(1) = 1 - D/d; % [1]


% grain L/D constraint
g(2) = (L/D)/8 - 1; % [1]


% port-to-throat ratio contraint
g(3) = 1 - pi*d^2/(8*A_star); % [1]


% target apogee constraint
g(4) = abs(max(h) - 3048)/30 - 1; % [1]


% max acceleration constraint
g(5) = max(abs(a))/10 - 1; % [1]


% max dynamic pressure constraint
g(6) = max(q)/30 - 1; % [1]


% max chamber pressure constraint
g(7) = max(P0)/60 - 1; % [1]


end