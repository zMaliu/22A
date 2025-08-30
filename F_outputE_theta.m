function P_avg = F_outputE_theta(t, y, param, k_zhi, k_xuan, varargin)
    % 解析可选参数
    p = inputParser; p.FunctionName = 'F_outputE_theta';
    addParameter(p, 'skip_cycles', 0, @(x)isnumeric(x) && isscalar(x) && x>=0);
    parse(p, varargin{:});
    N_skip = p.Results.skip_cycles;

    % 基于角频率计算周期
    omega = param.q.B;               % rad/s
    if omega <= 0
        error('param.q.B (omega) must be positive.');
    end
    T = 2*pi/omega;                  % s

    % 剔除前 N_skip 个周期
    t0 = N_skip * T;
    idx = find(t >= t0);
    if numel(idx) < 2
        P_avg = 0; return;
    end
    ts = t(idx);
    ys = y(idx, :);

    % 仅统计阻尼做功：
    dt = ts(end) - ts(1);
    if dt <= 0
        P_avg = 0; return;
    end

    P_h = 0; P_p = 0;

    % heave 部分（需要至少 4 列状态：x_f, v_f, x_z, v_z）
    if size(ys,2) >= 4
        v_f = ys(:,2); v_z = ys(:,4);
        v_rel = v_f - v_z;
        P_h = trapz(ts, k_zhi * (v_rel.^2)) / dt;
    end

    % pitch 部分（需要至少 8 列状态：theta_f, omega_f, theta_z, omega_z）
    if size(ys,2) >= 8
        omega_f = ys(:,6); omega_z = ys(:,8);
        omega_rel = omega_f - omega_z;
        P_p = trapz(ts, k_xuan * (omega_rel.^2)) / dt;
    end

    P_avg = P_h + P_p;
end
