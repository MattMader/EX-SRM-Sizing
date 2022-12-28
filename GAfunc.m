function phi = GAfunc(x,rocket)

% objective function
f = objfun(x,rocket);

% constraint function
g = consfun(x,rocket);

% coefficients
C = ones(size(g));
C(4) = 50;
C(6) = 25;

% exterior-point method
P = 0;
for j = 1:length(g)
    P = P + C(j)*max(g(j),0);
end

% psuedo-objective function
phi = f + P;

end % function GAfunc