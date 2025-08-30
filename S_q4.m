
%  只统计阻尼做功（弹簧平均功为0），并剔除前若干周期的过渡段
% -先做小规模粗网格搜索，再在最优点附近细化
clc; clear;
param = makeParam();
omega = param.q.B;           
T     = 2*pi/omega;          

N_total = 80;                % 总周期数
N_skip  = 30;                % 丢弃前 N_skip 个周期以去过渡

tspan = [0, N_total*T];
y0    = zeros(8,1);
opts  = odeset('RelTol',1e-6,'AbsTol',1e-9);

% 阻尼系数（粗网格）——控制在可计算规模
kza_coarse = linspace(55000, 65000, 21);    % 直线阻尼（垂荡）
kzb_coarse = linspace(90000, 100000, 21);    % 旋转阻尼（纵摇）

P_coarse = -inf(numel(kza_coarse), numel(kzb_coarse));

for i = 1:numel(kza_coarse)
    for j = 1:numel(kzb_coarse)
        k_zn_a = kza_coarse(i);
        k_zn_b = kzb_coarse(j);
        try
            [t,y] = ode45(@(t,y)F_ode_theta(t,y,param,k_zn_a,k_zn_b), tspan, y0, opts);
            % 只统计阻尼功，并在稳态区间内平均（函数内部会剔除前 N_skip 个周期）
            P_coarse(i,j) = F_outputE_theta(t,y,param,k_zn_a,k_zn_b,'skip_cycles',N_skip);
        catch
            P_coarse(i,j) = -inf; 
        end
    end
end

% 定位粗网格最优点并构造细化窗口
[~,idx] = max(P_coarse(:));
[i0,j0] = ind2sub(size(P_coarse),idx);

step_a = (numel(kza_coarse)>1) * (kza_coarse(2)-kza_coarse(1));
step_b = (numel(kzb_coarse)>1) * (kzb_coarse(2)-kzb_coarse(1));
if step_a==0, step_a=1e4; end
if step_b==0, step_b=1e4; end

kza_next = max(kza_coarse(i0)-step_a, kza_coarse(1)) : step_a/2 : ...
           min(kza_coarse(i0)+step_a, kza_coarse(end));
kzb_next = max(kzb_coarse(j0)-step_b, kzb_coarse(1)) : step_b/2 : ...
           min(kzb_coarse(j0)+step_b, kzb_coarse(end));

fprintf('粗网格完成。进入细化：\n');
fprintf('  k_zn_a ∈ [%.0f, %.0f]，步长 %.0f → %d 个点\n', ...
        kza_next(1), kza_next(end), step_a/2, numel(kza_next));
fprintf('  k_zn_b ∈ [%.0f, %.0f]，步长 %.0f → %d 个点\n', ...
        kzb_next(1), kzb_next(end), step_b/2, numel(kzb_next));

P_fine = -inf(numel(kza_next), numel(kzb_next));
for i = 1:numel(kza_next)
    for j = 1:numel(kzb_next)
        k_zn_a = kza_next(i);
        k_zn_b = kzb_next(j);
        try
            [t,y] = ode45(@(t,y)F_ode_theta(t,y,param,k_zn_a,k_zn_b), tspan, y0, opts);
            P_fine(i,j) = F_outputE_theta(t,y,param,k_zn_a,k_zn_b,'skip_cycles',N_skip);
        catch
            P_fine(i,j) = -inf; 
        end
    end
end

% 细化最优结果
[P_max, idx] = max(P_fine(:));
[i_fine, j_fine] = ind2sub(size(P_fine), idx);

k_zn_a_opt = kza_next(i_fine);
k_zn_b_opt = kzb_next(j_fine);

fprintf('\n=== 最终结果（两路发电功率之和）===\n');
fprintf('平均输出功率 最大值 = %.6g\n', P_max);
fprintf('对应 直线阻尼 = %.0f\n', k_zn_a_opt);
fprintf('对应 旋转阻尼 = %.0f\n', k_zn_b_opt);

