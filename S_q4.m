clc;clear;
param = makeParam();
tspan = 0:0.05:150;

k_zhi = 60000;
k_xuan = 98000;
y0 = [0; 0; 0; 0; 0; 0; 0; 0];
opts = odeset('RelTol',1e-6,'AbsTol',1e-9);
[t, y] = ode45(@(t,y) F_ode_theta(t, y, param, k_zhi, k_xuan), tspan, y0, opts);
P_avg = F_outputE_theta(t, y, param, k_zhi, k_xuan);