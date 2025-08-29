function param = makeParam()

% 1. 物理常量
param.g   = 9.8;       % m/s^2
param.rho = 1025;      % kg/m^3

% 2. 浮子几何
param.m1          = 4866.0;    % kg
param.R           = 1.0;       % m  浮子底半径（圆柱半径）
param.H_cyl       = 3.0;       % m  圆柱高度
param.H_cone      = 0.8;       % m  圆锥高度
param.D           = 2*param.R; % m  圆柱外径
param.Sw          = pi*param.R^2;     % m^2  水线面积
param.rhogSw      = param.rho*param.g*param.Sw; % N/m  静水恢复系数

% 3. 振子
param.m2          = 2433.0;    % kg
param.r2          = 0.5;       % m  振子半径
param.h2          = 0.5;       % m  振子高度

% 4. PTO 弹簧
param.k  = 80000.0;    % N/m  直线弹簧刚度
param.kt = 250000.0;   % N·m  扭转弹簧刚度
param.L0 = 0.5;        % m    弹簧原长（垂向）

% 5. 静水恢复力矩系数
param.C44 = 8890.7;    % N·m  纵摇静水恢复力矩系数

% 6. 按问题号分频插值
% ——— 问题 1 ———
param.q1.omega = 1.4005;
param.q1.A33   = 1335.535;
param.q1.B33   = 656.3616;
param.q1.f     = 6250;
param.q1.A55   = 6779.315;   % kg·m^2
param.q1.B55   = 151.4388;
param.q1.L     = 1230;

% ——— 问题 2 ———
param.q2.omega = 2.2143;
param.q2.A33   = 1165.992;
param.q2.B33   = 167.8395;
param.q2.f     = 4890;
param.q2.A55   = 7131.29;
param.q2.B55   = 2992.724;
param.q2.L     = 2560;

% ——— 问题 3 ———
param.q3.omega = 1.7152;
param.q3.A33   = 1028.876;
param.q3.B33   = 683.4558;
param.q3.f     = 3640;
param.q3.A55   = 7001.914;
param.q3.B55   = 654.3383;
param.q3.L     = 1690;

% ——— 问题 4 ———
param.q4.omega = 1.9806;
param.q4.A33   = 1091.099;
param.q4.B33   = 528.5018;
param.q4.f     = 1760;
param.q4.A55   = 7142.493;
param.q4.B55   = 1655.909;
param.q4.L     = 2140;

end