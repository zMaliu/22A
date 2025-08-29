function P_avg = F_outputE(t, y, param, k_zn_a, k_zn_b)
    % 计算平均输出功率
    % 输入 t 时间列向量, y=[z1 v1 z2 v2], param 结构体, k_zn_a, k_zn_b 阻尼参数
    % 输出 P_avg 平均功率 (W)
    
    z1 = y(:,1); v1 = y(:,2);  % 浮子位移和速度
    z2 = y(:,3); v2 = y(:,4);  % 振子位移和速度
    v_rel = v2 - v1;          % 相对速度
    z_rel = z2 - z1;          % 相对位移
    
    % 计算PTO力（包含线性弹簧和非线性阻尼）
    F_pto = param.k * z_rel + k_zn_a * (abs(v_rel).^k_zn_b) .* v_rel;
    
    % 计算瞬时功率并求平均
    if (t(end) - t(1)) < eps
        P_avg = 0;  % 避免除以零
    else
        P_avg = trapz(t, F_pto .* v_rel) / (t(end) - t(1));
    end
end
