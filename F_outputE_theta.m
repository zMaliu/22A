function P_avg = F_outputE_theta(t, y, param, k_zhi, k_xuan)  
    xf = y(:,1); vf = y(:,2);  % 浮子位移和速度
    xz = y(:,3); vz = y(:,4);  % 振子位移和速度
    v_rel = vf - vz;          % 相对速度
    x_rel = xf - xz;          % 相对位移

    theta_xf = y(:,1);
    theta_vf = y(:,2);
    theta_xz = y(:,3);
    theta_vz = y(:,4);
    theta_v_rel = theta_vf - theta_vz;          % 相对角速度
    theta_x_rel = theta_xf - theta_xz;          % 相对角位移
    
    % 计算PTO力
    F_pto_zhi = param.k .* x_rel + k_zhi  .* v_rel;
    F_pto_xuan = param.k .* theta_x_rel + k_xuan  .* theta_v_rel;
    
    % 计算瞬时功率并求平均
    if (t(end) - t(1)) < eps
        P_avg = 0;  % 避免除以零
    else
        P_avg_zhi = trapz(t, F_pto_zhi .* v_rel) / (t(end) - t(1));
        P_avg_xuan = trapz(t, F_pto_xuan .* theta_v_rel) / (t(end) - t(1));
        P_avg = P_avg_zhi+P_avg_xuan;
    end
end
