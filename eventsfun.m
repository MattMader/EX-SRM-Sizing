function [value,isterminal,direction] = eventsfun(~,y)

h = y(4); % [m] altitude
v = y(5); % [m/s] velocity

value(1) = v; % value == 0 when velocity == 0
value(2) = max(0,h + 10); % value == 0 when altitude == -10

isterminal = [1, 1]; % stop the simulation
direction = [-1, -1]; % must be decreasing

end