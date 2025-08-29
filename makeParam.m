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

param.q.B = 2.2143;	
param.q.C = 1165.992;
param.q.D = 7131.29;
param.q.E = 167.8395;
param.q.F = 2992.724;   
param.q.G = 4890;
param.q.H = 2560;

end