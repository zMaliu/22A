function dydt = F_ode_theta(t, y, param, k_zhi, k_xuan)

    x_f      = y(1);   v_f      = y(2);
    x_z      = y(3);   v_z      = y(4);
    theta_f  = y(5);   omega_f  = y(6);
    theta_z  = y(7);   omega_z  = y(8);

    % PTO（线性）
    F_pto_h   = param.k  * (x_f - x_z)           + k_zhi  * (v_f - v_z);          % heave 力
    Tau_pto_p = param.kt * (theta_f - theta_z)   + k_xuan * (omega_f - omega_z);   % pitch 力矩

    RHS_f = param.q.G * cos(param.q.B * t) ...
          - param.q.E * v_f ...
          - param.rhogSw * x_f ...
          - F_pto_h;
    a_f  = RHS_f / (param.m1 + param.q.C);

    a_z  = F_pto_h / param.m2;

    % Pitch 子系统（小角度线性化模型）
    I_f1 = 2*pi*param.rho_f*param.R * ((param.R^2) * param.H_cyl/3 + (param.H_cyl^3)/12);
    I_f2 = 2*pi*param.rho_f*sqrt(1 + (param.R^2/param.H_cone^2)) * ((param.R^2) * param.H_cone/20 + param.R * param.H_cone^3/12);
    I_f  = I_f1 + I_f2;

    % 内部转子等效转动惯量（常值）
    I_z  = (param.m2 * (param.r2^2))/4 + (param.m2 * (param.h2^2))/12;

    % 线性化恢复力矩与阻尼、波浪力矩（单位保持为 N·m）
    K_theta = param.C44;                 % 静水恢复力矩系数 [N·m/rad]
    B_theta = param.q.F;                 % 经验/拟合的转动阻尼 [N·m·s/rad]
    M_wave  = param.q.H * cos(param.q.B * t);   % 波浪激励力矩 [N·m]

    RHS_theta_f = M_wave ...
                - B_theta * omega_f ...
                - K_theta * theta_f ...
                - Tau_pto_p;

    alpha_f = RHS_theta_f / (I_f + param.q.D);  % 加入附加转动惯量 D
    alpha_z =  Tau_pto_p / I_z;

    % 输出导数
    dydt = [ v_f;         % dx_f/dt
             a_f;         % dv_f/dt
             v_z;         % dx_z/dt
             a_z;         % dv_z/dt
             omega_f;     % dtheta_f/dt
             alpha_f;     % domega_f/dt
             omega_z;     % dtheta_z/dt
             alpha_z ];   % domega_z/dt
end