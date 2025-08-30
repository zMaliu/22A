function dydt = F_ode_theta(t, y, param,k_zn_a)
    % y(1)=x_f , y(2)=v_f , y(3)=x_z , y(4)=v_z
    x_f = y(1);  v_f = y(2);
    x_z = y(3);  v_z = y(4);

    % 浮子和振子的惯性质量
    I_f1 = 2*pi*param.rho_f*param.R*((param.R^2)*param.H_cyl/3 + (param.H_cyl^3)/12);
    I_f2 = 2*pi*param.rho_f*sqrt(1+(param.R^2/param.H_cone^2))*((param.R^2)*param.H_cone/20 + param.R*param.H_cone^3/12);
    I_f = I_f1 + I_f2;
    I_z = (param.m2*(param.r2)^2)/4 + (param.m2*(param.h2)^2)/12 + param.m2*(x_z)^2;

    % 1. 计算PTO力
    F_pto = param.k*(x_f - x_z) + k_zn_a*(v_f - v_z);

    % 2. 计算两个加速度
    RHS_f = param.q.H*cos(param.q.B*t) ...
            - param.q.F*v_f ...
            - param.rhogSw *x_f ...
            - F_pto;

    a_f = RHS_f / (I_f + param.q.D);   

    a_z = (param.m2*param.g + F_pto) / I_z;

    % 3. 输出导数
    dydt = [v_f;     % dx_f/dt
            a_f;     % dv_f/dt
            v_z;     % dx_z/dt
            a_z];    % dv_z/dt
end