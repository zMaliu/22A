% 先粗扫（步长放大 10 倍）
clc;clear;
param = makeParam();
T = 1/param.q.B;
tspan = 0:0.5:400;

k_zn_b = 0;
y0 = [0; 0; 0; 0];
opts = odeset('RelTol',1e-6,'AbsTol',1e-9);
kza_coarse = 99600:100:99700;          
kzb_coarse = 0.40:0.01:0.42;            

P_coarse = zeros(numel(kza_coarse), numel(kzb_coarse));

% 如果装了并行工具箱，把下面 for 换成 parfor
for i = 1:numel(kza_coarse)
    for j = 1:numel(kzb_coarse)
        [t,y] = ode45(@(t,y)F_ode(t,y,param,kza_coarse(i),kzb_coarse(j)), ...
                      tspan, y0, opts);
        P_coarse(i,j) = F_outputE(t,y,param,kza_coarse(i),kzb_coarse(j));
    end
end

[~,idx]   = max(P_coarse(:));
[i0,j0]   = ind2sub(size(P_coarse),idx);

step_a = kza_coarse(2)-kza_coarse(1);
step_b = kzb_coarse(2)-kzb_coarse(1);

kza_next = max(kza_coarse(i0)-step_a, kza_coarse(1)) : step_a/2 : ...
           min(kza_coarse(i0)+step_a, kza_coarse(end));
kzb_next = max(kzb_coarse(j0)-step_b, kzb_coarse(1)) : step_b/2 : ...
           min(kzb_coarse(j0)+step_b, kzb_coarse(end));

fprintf('下一步缩小区间：\n');
fprintf('  k_zn_a ∈ [%.0f, %.0f]  步长 100 → %d 个点\n', ...
        kza_next(1), kza_next(end), numel(kza_next));
fprintf('  k_zn_b ∈ [%.2f, %.2f]  步长 0.01 → %d 个点\n', ...
        kzb_next(1), kzb_next(end), numel(kzb_next));

P_fine = zeros(numel(kza_next), numel(kzb_next));

% 如果装了并行工具箱，把 for 换成 parfor
for i = 1:numel(kza_next)
    for j = 1:numel(kzb_next)
        [t,y] = ode45(@(t,y)F_ode(t,y,param,kza_next(i),kzb_next(j)), ...
                      tspan, y0, opts);
        P_fine(i,j) = F_outputE(t,y,param,kza_next(i),kzb_next(j));
    end
end

%% 6) 找到最大值及对应参数
[P_max, idx] = max(P_fine(:));
[i_fine, j_fine] = ind2sub(size(P_fine), idx);

k_zn_a_opt = kza_next(i_fine);
k_zn_b_opt = kzb_next(j_fine);

%% 7) 输出最终结果
fprintf('\n=== 最终结果 ===\n');
fprintf('平均输出功率 最大值 = %.6g\n', P_max);
fprintf('对应 比例系数 = %.0f\n', k_zn_a_opt);
fprintf('对应 幂指数 = %.2f\n', k_zn_b_opt);