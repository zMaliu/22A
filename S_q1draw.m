clc;clear;
param = makeParam();
tspan = [0 200];
k_zn_a = 10000;k_zn_b = 0.5;
y0 = [0; 0; 0; 0];
opts = odeset('RelTol',1e-6,'AbsTol',1e-9);
[t, y] = ode45(@(t,y) F_ode(t,y,param,k_zn_a,k_zn_b), tspan, y0, opts);

xf = y(:,1);   vf = y(:,2);
xz = y(:,3);   vz = y(:,4);

% 画四幅图
figure;

subplot(2,2,1)
plot(t, xf,  'b-',  'LineWidth',1.2); hold on;
plot(t, xz,  'r-', 'LineWidth',1.2);
ylabel('位移 (m)');
xlabel('时间 (s)');
title('垂荡运动浮子和振子的位移', 'FontSize', 21);
legend('浮子','振子');
grid on

% 2) 垂荡速度
subplot(2,2,2)
plot(t, vf,  'b-',  'LineWidth',1.2); hold on;
plot(t, vz,  'r-', 'LineWidth',1.2);
ylabel('速度  (m/s)');
xlabel('时间 (s)');
title('垂荡运动浮子和振子的速度', 'FontSize', 21);
legend('浮子','振子');
grid on