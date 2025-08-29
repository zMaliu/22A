clc; clear;
param = makeParam();
T=1/(param.q2.B);
tspan = [0 40*(1/param.q2.B)]; 
y0 = [0; 0; 0; 0];
opts = odeset('RelTol',1e-6,'AbsTol',1e-9);

% 生成阻尼系数网格
k_zn_a_range = linspace(0, 100000, 20);  % 阻尼系数a范围
k_zn_b_range = linspace(0, 1, 20);       % 阻尼系数b范围
[K_zn_a, K_zn_b] = meshgrid(k_zn_a_range, k_zn_b_range);

% 计算每个参数组合的输出功率
P_avg_grid = zeros(size(K_zn_a));
for i = 1:numel(K_zn_a)
    [t, y] = ode45(@(t,y) F_ode(t,y,param,K_zn_a(i),K_zn_b(i)), tspan, y0, opts);
    P_avg_grid(i) = F_outputE(t, y, param, K_zn_a(i), K_zn_b(i));
end

% 绘制三维曲面图
figure('Position', [100, 100, 1200, 500]);

% 子图1：三维曲面
subplot(1,2,1);
surf(K_zn_a, K_zn_b, P_avg_grid, 'EdgeColor', 'none');
hold on;

% 绘制最大功率点
[max_power, max_idx] = max(P_avg_grid(:));
[max_a, max_b] = ind2sub(size(P_avg_grid), max_idx);
plot3(K_zn_a(max_idx), K_zn_b(max_idx), max_power, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

xlabel('阻尼系数 k_{zn,a} (N·s/m)');
ylabel('阻尼系数指数 k_{zn,b}');
zlabel('平均输出功率 P_{avg} (W)');
title('三维功率曲面：阻尼系数 vs 输出功率', 'FontSize', 14);
colorbar;
grid on;
view(45, 30);

% 子图2：xy平面投影（等高线图）
subplot(1,2,2);
contourf(K_zn_a, K_zn_b, P_avg_grid, 20, 'LineColor', 'none');
hold on;

% 标记最大功率点
plot(K_zn_a(max_idx), K_zn_b(max_idx), 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');

% 添加功率值标注
text(K_zn_a(max_idx), K_zn_b(max_idx), sprintf('Max: %.1f W', max_power), ...
     'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', ...
     'FontSize', 10, 'FontWeight', 'bold', 'Color', 'red');

xlabel('阻尼系数 k_{zn,a} (N·s/m)');
ylabel('阻尼系数指数 k_{zn,b}');
title('功率等高线图（xy平面投影）', 'FontSize', 14);
colorbar;
grid on;

% 添加优化结果信息
fprintf('最优阻尼参数：k_zn_a = %.0f, k_zn_b = %.3f\n', K_zn_a(max_idx), K_zn_b(max_idx));
fprintf('最大平均输出功率：%.1f W\n', max_power);