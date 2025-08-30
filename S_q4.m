clc; clear; 
% ==============================================================
% 第四题主脚本 S_q4.m
% 目的：
%  - 完成除“目标函数”之外的整体求解框架：
%    1) 参数初始化与海况选择
%    2) 数据/搜索区间预处理
%    3) 算法框架（粗网格 -> 局部细化）
%    4) 结果输出（打印/保存），并为后续添加目标函数预留接口
%
% 说明：
%  - 目标函数接口：power = q4_objective(k_zn_a, k_zn_b)
%    该函数应返回给定阻尼参数下的平均输出功率（单位：W）。
%    你可以在本文件底部完善 q4_objective 的实现（目前仅为占位）。
%  - 本脚本通过全局上下文 Q4_CTX 向目标函数传递仿真所需的环境信息
%    （例如：param、海况、时间窗、初值、求解器精度、计算模式等）。
% ==============================================================

%% 1) 参数初始化与海况选择
param = makeParam();                       

% 时域仿真与稳态设置
T = 2*pi/param.q.B;                             % 基本周期（秒）
N_period_total = 40;                           
N_period_skip  = 10;                           % 丢弃前若干周期用于稳态（与目标函数保持一致）
tspan = [0, N_period_total*T];
y0    = [0; 0; 0; 0];                          % 初始状态（依据模型定义）
opts  = odeset('RelTol',1e-6,'AbsTol',1e-9);   % 求解器精度

% 计算模式：'heave'（垂荡，仅用 F_ode）| 'pitch'（纵摇，仅用 F_ode_theta）| 'coupled'（如实现耦合）
MODE = 'couple';

%% 2) 数据/搜索区间预处理
% 阻尼系数搜索范围（粗网格）
coarse.k_zn_a = linspace(0, 1e5, 21);          % 比例系数（N·s/m），可按需求调整
coarse.k_zn_b = linspace(0, 1.0, 11);          % 幂指数（无量纲）

% 局部细化设置（在粗网格最优点附近细化搜索）
refine.window_scale_a = 0.5;                   % 细化窗口宽度系数（相对 coarse 步长）
refine.window_scale_b = 0.5;
refine.grid_density   = 11;                    % 细化网格密度（每维）

% 输出/保存设置
save_dir   = pwd;                               % 保存路径（当前目录）
save_mat   = fullfile(save_dir, 'q4_results.mat');
save_csv   = fullfile(save_dir, 'q4_results.csv');

%% 3) 全局上下文（传递给目标函数）
% 使用全局变量便于保持“目标函数仅需两个输入”的接口形式
% 目标函数内部可通过 global 访问 Q4_CTX。

clear global Q4_CTX
global Q4_CTX
Q4_CTX = struct();
Q4_CTX.param          = param;
Q4_CTX.MODE           = MODE;
Q4_CTX.tspan          = tspan;
Q4_CTX.y0             = y0;
Q4_CTX.opts           = opts;
Q4_CTX.T_period       = T;
Q4_CTX.N_period_skip  = N_period_skip;
Q4_CTX.N_period_total = N_period_total;

%% 4) 算法框架搭建：粗网格 -> 局部细化
% 注意：目标函数尚未实现时，可将 do_run 设为 false 以避免执行

do_run = false;   % 实现 q4_objective 后改为 true 运行

if do_run
    % ---- 4.1 粗网格搜索 ----
    [KZA, KZB] = meshgrid(coarse.k_zn_a, coarse.k_zn_b);
    P_grid = nan(size(KZA));

    for i = 1:numel(KZA)
        a = KZA(i); b = KZB(i);
        try
            P_grid(i) = q4_objective(a, b);   %#ok<*NASGU>
        catch ME
            P_grid(i) = NaN;  % 目标函数未实现或出错时记录 NaN
            warning('[Coarse] a=%.3g, b=%.3g 计算失败：%s', a, b, ME.message);
        end
    end

    % 找到粗网格最优
    [P_max_coarse, idx_max] = max(P_grid(:));
    a_star_coarse = KZA(idx_max);
    b_star_coarse = KZB(idx_max);

    % ---- 4.2 构造细化网格 ----
    % 以粗网格步长为基准，在最优点附近开窗
    step_a = (coarse.k_zn_a(2) - coarse.k_zn_a(1));
    step_b = (coarse.k_zn_b(2) - coarse.k_zn_b(1));

    half_win_a = max(step_a * refine.window_scale_a, eps);
    half_win_b = max(step_b * refine.window_scale_b, eps);

    a_min = max(a_star_coarse - half_win_a, min(coarse.k_zn_a));
    a_max = min(a_star_coarse + half_win_a, max(coarse.k_zn_a));
    b_min = max(b_star_coarse - half_win_b, min(coarse.k_zn_b));
    b_max = min(b_star_coarse + half_win_b, max(coarse.k_zn_b));

    kza_ref = linspace(a_min, a_max, refine.grid_density);
    kzb_ref = linspace(b_min, b_max, refine.grid_density);

    [KZA_ref, KZB_ref] = meshgrid(kza_ref, kzb_ref);
    P_ref = nan(size(KZA_ref));

    for i = 1:numel(KZA_ref)
        a = KZA_ref(i); b = KZB_ref(i);
        try
            P_ref(i) = q4_objective(a, b);
        catch ME
            P_ref(i) = NaN;
            warning('[Refine] a=%.3g, b=%.3g 计算失败：%s', a, b, ME.message);
        end
    end

    % 细化最优
    [P_max_ref, idx_ref] = max(P_ref(:));
    a_star = KZA_ref(idx_ref);
    b_star = KZB_ref(idx_ref);

    %% 5) 结果输出处理（打印/保存）
    fprintf('\n===== 第四题优化结果（%s, 海况=%s） =====\n', Q4_CTX.MODE, SEA_ID);
    fprintf('粗网格最优：a = %.3f, b = %.3f, P = %.6g W\n', a_star_coarse, b_star_coarse, P_max_coarse);
    fprintf('细化后最优：a = %.3f, b = %.3f, P = %.6g W\n', a_star, b_star, P_max_ref);

    % 保存到 MAT 文件
    results = struct();
    results.SEA_ID         = SEA_ID;
    results.MODE           = Q4_CTX.MODE;
    results.coarse.KZA     = KZA;
    results.coarse.KZB     = KZB;
    results.coarse.P_grid  = P_grid;
    results.coarse.max_a   = a_star_coarse;
    results.coarse.max_b   = b_star_coarse;
    results.coarse.P_max   = P_max_coarse;

    results.refined.KZA    = KZA_ref;
    results.refined.KZB    = KZB_ref;
    results.refined.P_grid = P_ref;
    results.refined.max_a  = a_star;
    results.refined.max_b  = b_star;
    results.refined.P_max  = P_max_ref;

    results.param          = Q4_CTX.param; %#ok<STRNU>
    results.tspan          = Q4_CTX.tspan;
    results.N_period_total = Q4_CTX.N_period_total;
    results.N_period_skip  = Q4_CTX.N_period_skip;

    save(save_mat, '-struct', 'results');
    fprintf('结果已保存至 MAT 文件：%s\n', save_mat);

    % 另存为 CSV（仅粗网格数据，便于报告作图）
    T_out = table(KZA(:), KZB(:), P_grid(:), ...
                  'VariableNames', {'k_zn_a','k_zn_b','P_avg'});
    try
        writetable(T_out, save_csv);
        fprintf('粗网格结果已导出为 CSV：%s\n', save_csv);
    catch ME
        warning('CSV 导出失败：%s（可忽略）', ME.message);
    end
end

%% ============== 目标函数占位（请在此处实现） ===================
% 说明：
% - 该函数必须仅接受两个输入（k_zn_a, k_zn_b），并返回一个标量功率（W）。
% - 仿真所需的上下文（参数/时间窗/初值/模式等）通过全局结构 Q4_CTX 提供。
% - 建议实现时：
%   1) 根据 Q4_CTX.MODE 选择使用 F_ode（垂荡）或 F_ode_theta（纵摇）等模型；
%   2) 运行 ODE，计算时域阻尼做功的稳态平均（参考 F_outputE 的实现方式，或自定义功率计算以匹配第四题目标）；
%   3) 建议在积分平均时剔除前 N_period_skip 个周期；
%   4) 注意单位与物理一致性（仅阻尼做功，弹簧平均功≈0）。
function P_avg = q4_objective(k_zn_a, k_zn_b)
    %#ok<INUSD>
    % TODO: 实现目标函数（输入：k_zn_a, k_zn_b；输出：平均功率 P_avg）
    % 你可以参考 test.m 与 F_outputE.m 的写法：
    % - 使用 ode45(@(t,y) F_ode(...), ...) 或 F_ode_theta 进行时域仿真；
    % - 使用阻尼功率进行平均（剔除过渡段），返回标量 P_avg。

    error('q4_objective 尚未实现：请在 S_q4.m 底部补充该函数的具体仿真与功率计算。');
end

%% ================== 工具函数（本地） ==========================
function q_lib = load_q_library()
    % 从 4Q_param.m 加载四组海况参数（q1~q4）到结构体 q_lib
    % 由于 4Q_param.m 为脚本，这里在函数工作区执行并捕获变量。
    q_lib = struct();
    ws = struct();
    try
        % 在局部工作区执行脚本，获得变量 param（含 q1..q4）
        run('4Q_param.m'); %#ok<RUN>
        if exist('param','var') && isstruct(param) && isfield(param,'q1')
            ws = param; %#ok<NASGU>
        end
        clear param
    catch
        % 若加载失败，则返回空，后续按 makeParam 中的默认 q 使用
    end

    if exist('ws','var') && isstruct(ws) && isfield(ws,'q1')
        q_lib = ws;
    else
        % 最简降级：什么都不做，调用方将沿用 makeParam 内置的 param.q
        q_lib = struct();
    end
end

function param = set_sea_state(param, q_lib, sea_id)
    % 将选定海况写入 param.q（若 q_lib 不可用，则保持原值不变）
    if ~isstruct(q_lib) || isempty(fieldnames(q_lib))
        % 无外部库：沿用 makeParam 内置参数
        return;
    end

    if ischar(sea_id) || isstring(sea_id)
        key = char(sea_id);
    else
        key = sprintf('q%d', sea_id);
    end

    if isfield(q_lib, key)
        param.q = q_lib.(key);
    else
        warning('未找到海况 %s，沿用 makeParam 的默认 param.q。', key);
    end
end