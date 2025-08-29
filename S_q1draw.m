clc;clear;
param = makeParam();
tspan = [0 100];
k_zn_a = 10000;k_zn_b = 0;
y0 = [0; 0; 0; 0];
opts = odeset('RelTol',1e-6,'AbsTol',1e-9);
[t, y] = ode45(@(t,y) F_ode(t,y,param,k_zn_a,k_zn_b), tspan, y0, opts);

xf = y(:,1);   vf = y(:,2);
xz = y(:,3);   vz = y(:,4);

% 画四幅图
figure;

subplot(2,2,1)
plot(t,xf,'b-')
ylabel('x_f  (m)','Rotation',0);
xlabel('t (s)');
title('浮子位移关于时间的函数图像'); grid on

subplot(2,2,2)
plot(t,vf,'b-')
ylabel('v_f  (m/s)','Rotation',0);
xlabel('t (s)');
title('浮子速度关于时间的函数图像'); grid on

subplot(2,2,3)
plot(t,xz,'r-')
ylabel('x_z  (m)','Rotation',0); 
xlabel('t (s)');
title('振子位移关于时间的函数图像'); grid on

subplot(2,2,4)
plot(t,vz,'r-')
ylabel('v_z  (m/s)','Rotation',0); 
xlabel('t (s)');
title('振子速度关于时间的函数图像'); grid on