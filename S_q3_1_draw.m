clc;clear;
param = makeParam();
tspan = 0:0.05:150;

k_zhi = 10000;
k_xuan = 1000;
y0 = [0; 0; 0; 0; 0; 0; 0; 0];
opts = odeset('RelTol',1e-6,'AbsTol',1e-9);
[t, y] = ode45(@(t,y) F_ode_theta(t, y, param, k_zhi, k_xuan), tspan, y0, opts);
xf = y(:,1);   
vf = y(:,2);
xz = y(:,3);   
vz = y(:,4);
theta_xf = y(:,5);
theta_vf = y(:,6);
theta_xz = y(:,7);
theta_vz = y(:,8);

% 合成一张图，四幅子图，每幅子图里画两条曲线
figure;

% 1) 垂荡位移
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

% 3) 纵摇位移
subplot(2,2,3)
plot(t, theta_xf,  'b-',  'LineWidth',1.2); hold on;
plot(t, theta_xz,  'r-', 'LineWidth',1.2);
ylabel('位移  (m)');
xlabel('时间 (s)');
title('纵摇运动浮子和振子的位移', 'FontSize', 21);
legend('浮子','振子');
grid on

% 4) 纵摇速度
subplot(2,2,4)
plot(t, theta_vf,  'b-',  'LineWidth',1.2); hold on;
plot(t, theta_vz,  'r-', 'LineWidth',1.2);
ylabel('速度  (m/s)');
xlabel('时间 (s)');
title('纵摇运动浮子和振子的速度', 'FontSize', 21);
legend('浮子','振子');
grid on