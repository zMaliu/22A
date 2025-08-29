clc; clear;
param = makeParam();
T = 1/param.q2.B;
tspan = T:0.1:40*T;
y0 = [0; 0; 0; 0];
opts = odeset('RelTol',1e-6,'AbsTol',1e-9);

k_zn_b_vec = 0:0.01:1;
k_zn_a = 45000;         
P_vec      = zeros(size(k_zn_b_vec));   

for k = 1:numel(k_zn_b_vec)
    k_zn_b = k_zn_b_vec(k);
    [t, y] = ode45(@(t,y) F_ode(t,y,param,k_zn_a,k_zn_b), tspan, y0, opts);
    P_vec(k) = F_outputE(t, y, param, k_zn_a, k_zn_b);   % 标量
end

% 画图
figure;
plot(k_zn_b_vec, P_vec, 'k');
xlabel('k_{zn,a}');
ylabel('P_{avg}');
grid on;