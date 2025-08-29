clc;clear;
param = makeParam();
T = 1/param.q.B;
tspan = 0:0.5:400;

k_zn_b = 0;
y0 = [0; 0; 0; 0];
opts = odeset('RelTol',1e-6,'AbsTol',1e-9);

k_zn_a_vec = 35000:100:40000;
P_avg_vec = zeros(size(k_zn_a_vec));

for i = 1:numel(k_zn_a_vec)
    k_zn_a = k_zn_a_vec(i);          % 当前值
    [t, y] = ode45(@(t,y) F_ode(t,y,param,k_zn_a,k_zn_b), ...
                   tspan, y0, opts); % 直接算
    P_avg_vec(i) = F_outputE(t, y, param, k_zn_a, k_zn_b); % 直接算
end
% 找到最大值及其对应的索引
[~, idx_max] = max(P_avg_vec);

% 取出对应 k_zn_a
k_zn_a_max = k_zn_a_vec(idx_max);

% 显示结果
fprintf('平均输出功率 最大值 = %.6g，对应的 比例系数 = %.6g\n', ...
        P_avg_vec(idx_max), k_zn_a_max);
%{
figure;
plot(k_zn_a_vec, P_avg_vec, 'LineWidth', 1.5);
xlabel('k_{zn,a}');
ylabel('P_{avg}');
title('P_{avg} vs k_{zn,a}');
grid on;
%}
