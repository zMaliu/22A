clc;clear;
figure('Position', [100, 100, 1600, 800]);

% ========== S_q4_1 函数可视化（垂荡运动） =========
% 3D曲线图
subplot(2, 2, 1);

% 1) 计算数据
param = makeParam();
tspan = [0 100];
k_zn_b = 0;
y0 = [0; 0; 0; 0];
opts = odeset('RelTol',1e-6,'AbsTol',1e-9);

% 垂荡运动参数扫描
k_zn_a_vec = 0:1000:50000;
P_avg_vec = zeros(size(k_zn_a_vec));

for i = 1:numel(k_zn_a_vec)
    [t, y] = ode45(@(t,y) F_ode(t,y,param,k_zn_a_vec(i),k_zn_b), tspan, y0, opts);
    P_avg_vec(i) = F_outputE(t, y, param, k_zn_a_vec(i), k_zn_b);
end

% 2) 找到最优
[~, idx_max] = max(P_avg_vec);
k_zn_a_max = k_zn_a_vec(idx_max);
P_max = P_avg_vec(idx_max);

% 3) 绘制：只保留"功率曲线"和"红色最优点"进入图例
plot3(k_zn_a_vec, zeros(size(k_zn_a_vec)), P_avg_vec, ...
      'Color', [0 0.447 0.741], 'LineWidth', 3, 'HandleVisibility', 'on');  % 蓝色曲线

hold on;
plot3(k_zn_a_max, 0, P_max, ...
      'ro', 'MarkerSize', 10, ...
      'MarkerFaceColor', [0.85 0.325 0.098], ...
      'MarkerEdgeColor', [0.635 0.078 0.184], ...
      'LineWidth', 2, 'HandleVisibility', 'on');  % 红色最优标记

% 4) 高亮竖线（不进入图例）
for k = 1:5:length(k_zn_a_vec)
    plot3([k_zn_a_vec(k) k_zn_a_vec(k)], [0 0], [0 P_avg_vec(k)], ...
          'Color', [0.301 0.745 0.933 0.4], 'LineWidth', 1.2, ...
          'HandleVisibility', 'off');  % 隐藏图例
end

% 5) 视图与标签
grid on; view(45, 30);
xlabel('比例系数 k_{zn,a}');
ylabel('幂指数 k_{zn,b}');
zlabel('平均输出功率 P_{avg} (W)');
legend('功率曲线', '最优参数点', 'Location', 'best');

% ========== S_q4_2 函数可视化（纵摇运动） ==========
% 3D曲面图
subplot(2, 2, 3);

% 重新计算纵摇运动数据
kza_coarse = 500:100:2000;
kzb_coarse = 0:0.1:1;
P_coarse = zeros(numel(kza_coarse), numel(kzb_coarse));

for i = 1:numel(kza_coarse)
    for j = 1:numel(kzb_coarse)
        [t, y] = ode45(@(t,y) F_ode(t,y,param,kza_coarse(i),kzb_coarse(j)), tspan, y0, opts);
        P_coarse(i,j) = F_outputE(t, y, param, kza_coarse(i), kzb_coarse(j));
    end
end

[~, idx] = max(P_coarse(:));
[i0, j0] = ind2sub(size(P_coarse), idx);

step_a = kza_coarse(2) - kza_coarse(1);
step_b = kzb_coarse(2) - kzb_coarse(1);

kza_next = max(kza_coarse(i0)-step_a, kza_coarse(1)) : step_a/2 : min(kza_coarse(i0)+step_a, kza_coarse(end));
kzb_next = max(kzb_coarse(j0)-step_b, kzb_coarse(1)) : step_b/2 : min(kzb_coarse(j0)+step_b, kzb_coarse(end));

P_fine = zeros(numel(kza_next), numel(kzb_next));

for i = 1:numel(kza_next)
    for j = 1:numel(kzb_next)
        [t, y] = ode45(@(t,y) F_ode(t,y,param,kza_next(i),kzb_next(j)), tspan, y0, opts);
        P_fine(i,j) = F_outputE(t, y, param, kza_next(i), kzb_next(j));
    end
end

[P_max, idx] = max(P_fine(:));
[i_fine, j_fine] = ind2sub(size(P_fine), idx);
k_zn_a_opt = kza_next(i_fine);
k_zn_b_opt = kzb_next(j_fine);

% 增加网格密度提高平滑度
kza_fine = linspace(min(kza_coarse), max(kza_coarse), 50);
kzb_fine = linspace(min(kzb_coarse), max(kzb_coarse), 50);
[kza_mesh_fine, kzb_mesh_fine] = meshgrid(kza_fine, kzb_fine);

% 使用插值获得更平滑的曲面
P_mesh_fine = interp2(kza_coarse, kzb_coarse, P_coarse', kza_mesh_fine, kzb_mesh_fine, 'spline');

surf(kza_mesh_fine, kzb_mesh_fine, P_mesh_fine, 'EdgeColor', 'none', 'FaceAlpha', 0.9);
hold on;
plot3(k_zn_a_opt, k_zn_b_opt, P_max, 'ro', 'MarkerSize', 12, 'MarkerFaceColor', 'r', 'LineWidth', 2);

colormap jet;
shading interp;  % 使用插值着色进一步提高平滑度
colorbar;
grid on;
view(45, 30);  % 调整视角
xlabel('比例系数 k_{zn,a}');
ylabel('幂指数 k_{zn,b}');
zlabel('平均输出功率 P_{avg} (W)');
legend('功率曲面', '最优参数点', 'Location', 'best');

% S_q4_2 等高线图
subplot(2, 2, 4);

% 绘制二维等高线图
contourf(kza_mesh_fine, kzb_mesh_fine, P_mesh_fine, 20, 'LineColor', 'none');
hold on;

% 标记最大值点
plot(k_zn_a_opt, k_zn_b_opt, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'LineWidth', 2);

% 设置图形属性
colormap jet;
colorbar;
grid on;
xlabel('比例系数 k_{zn,a}');
ylabel('幂指数 k_{zn,b}');
legend('功率等高线', '最优参数点', 'Location', 'best');

% 添加网格和美化
set(gcf, 'Color', 'w');

% 显示优化结果信息
fprintf('\n=== 第四问可视化结果信息 ===\n');
fprintf('S_q4_1 垂荡运动最优参数: k_{zn,a} = %.0f, P_{avg} = %.6g W\n', k_zn_a_max, P_avg_vec(idx_max));
fprintf('S_q4_2 纵摇运动最优参数: k_{zn,a} = %.0f, k_{zn,b} = %.2f, P_{avg} = %.6g W\n', ...
        k_zn_a_opt, k_zn_b_opt, P_max);