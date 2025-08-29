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

% 6. 根据"4Q_param"对应填充不同问题的参数
param.q1.B = 1.4005;
param.q1.C = 1335.535;
param.q1.D = 6779.315;
param.q1.E = 656.3616;
param.q1.F = 151.4388;   % kg·m^2
param.q1.G = 6250;
param.q1.H = 1230;


end