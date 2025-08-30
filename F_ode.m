function dydt = F_ode(t, y, param,k_zn_a,k_zn_b)
    % y(1)=x_f , y(2)=v_f , y(3)=x_z , y(4)=v_z
    x_f = y(1);  v_f = y(2);
    x_z = y(3);  v_z = y(4);

    % 1. 计算PTO力
    F_pto = param.k*(x_f - x_z) + k_zn_a*(abs(v_f - v_z)^k_zn_b)*(v_f - v_z);

    % 2. 计算两个加速度
    RHS_f = param.q.G*cos(param.q.B*t) ...
            - param.q.E*v_f ...
            - param.rhogSw *x_f ...
            - F_pto;

    a_f = RHS_f / (param.m1 + param.q.C);   
    a_z = F_pto / param.m2;

    % 3. 输出导数
    dydt = [v_f;     % dx_f/dt
            a_f;     % dv_f/dt
            v_z;     % dx_z/dt
            a_z];    % dv_z/dt
end