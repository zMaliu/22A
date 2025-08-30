function dydt = F_ode_theta(t, y, param,k_zhi,k_xuan)
    xf = y(1);  
    vf = y(2);
    xz = y(3);  
    vz = y(4);
    theta_xf = y(5);
    theta_vf = y(6);
    theta_xz = y(7);
    theta_vz = y(8);

    % 先计算纵摇运动的情况
    % 浮子和振子的惯性质量
    I_f1 = 2*pi*param.rho_f*param.R*((param.R^2)*param.H_cyl/3 + (param.H_cyl^3)/12);
    I_f2 = 2*pi*param.rho_f*sqrt(1+(param.R^2/param.H_cone^2))*((param.R^2)*param.H_cone/20 + param.R*param.H_cone^3/12);
    I_f = I_f1 + I_f2;
    I_z = (param.m2*(param.r2)^2)/4 + (param.m2*(param.h2)^2)/12 + param.m2*(theta_xz)^2;

    % 计算PTO力
    F_pto_theta = param.k*(theta_xf - theta_xz) + k_xuan*(theta_vf - theta_vz);

    % 计算两个加速度
    RHS_f_theta = param.q.H*cos(param.q.B*t) ...
            - param.q.F*theta_vf ...
            - param.rhogSw *theta_xf ...
            - F_pto_theta;

    theta_af = RHS_f_theta / (I_f + param.q.D);   
    theta_az = F_pto_theta / I_z;

    % 计算PTO力
    F_pto = param.k*(xf - xz) + k_zhi*(vf - vz);

    % 计算两个加速度
    RHS_f = param.q.G*cos(param.q.B*t)*abs(cos(theta_xf)) ...
            - param.q.E*vf ...
            - param.rhogSw *xf ...
            - F_pto;

    af = RHS_f / (param.m1 + param.q.C);   
    az = F_pto / param.m2;

    % 输出导数
    dydt = [vf;     
            af;     
            vz;     
            az;
            theta_vf;
            theta_af;
            theta_vz;
            theta_az];    
end