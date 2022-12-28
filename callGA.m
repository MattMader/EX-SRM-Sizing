%% Clear Workspace
clear
close all
clc;

%% Setup Workspace
format long
load rocket.mat

%% Setup Optimization

% lower bounds
vlb = [0.05, 0.01, 0.1, 1, 0.0001];

% upper bounds
vub = [0.20, 0.10, 0.50, 8, 0.001];

% bits
% vbits = [7, 6, 8, 3, 7];
vbits = [10,10,10,3,10];

% string length
l = 4*sum(vbits);

% poptulation size
N_pop = 4*l;

% mutation rate
P = (l + 1)/(2*N_pop*l);

% default options
% opts = goptions([2,0.9,0,0,0,0,0,0,0,0,0,0,0,5]);
opts = goptions([]);

% w = warning('off','all');
s = tic;
[x_star,phi_star,stats,feval,fgen,lgen,lfit]= GA550('GAfunc',[],opts,vlb,vub,vbits,rocket);
toc(s)

%%


x_star
f = objfun(x_star,rocket)
g = consfun(x_star,rocket)


%%

[t,P0,s,m,h,v,a,q] = sim_rocket(x_star,rocket);

%%

% [~,aa,~,~] = atmosisa(h);

plot(t,q)


