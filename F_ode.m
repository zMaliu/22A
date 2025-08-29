function dydt = F_ode(t, y, param)
    % y(1)=x_f , y(2)=v_f , y(3)=x_z , y(4)=v_z
    x_f = y(1);  v_f = y(2);
    x_z = y(3);  v_z = y(4);

    % 1. 计算PTO力
    F_pto = param.k*(x_f - x_z) + param.q1.B33*(v_f - v_z);

    % 2. 计算两个加速度
    RHS_f = param.q1.f*cos(param.q1.omega*t) ...
            - param.q1.B33*v_f ...
            - param.rhogSw *x_f ...
            - F_pto;

    a_f = RHS_f / (param.m1 + param.q1.A33);   

    a_z = (param.m2*param.g + F_pto) / param.m2;

    % 3. 输出导数
    dydt = [v_f;     % dx_f/dt
            a_f;     % dv_f/dt
            v_z;     % dx_z/dt
            a_z];    % dv_z/dt
end