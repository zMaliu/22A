clc;clear;
param = makeParam();
tspan = [0 100];

k_zn_b = 0;
k_zn_a = 10000;
k_zn_a_theta = 1000;
y0 = [0; 0; 0; 0];
opts = odeset('RelTol',1e-6,'AbsTol',1e-9);
[t, y] = ode45(@(t,y) F_ode(t,y,param,k_zn_a,k_zn_b), tspan, y0, opts);
[t_theta, y_theta] = ode45(@(t_theta,y_theta) F_ode_theta(t_theta,y_theta,param,k_zn_a_theta), tspan, y0, opts);

xf = y(:,1);   
vf = y(:,2);
xz = y(:,3);   
vz = y(:,4);

theta_xf = y_theta(:,1);
theta_vf = y_theta(:,2);
theta_xz = y_theta(:,3);
theta_vz = y_theta(:,4);

% 1. 目标时间点
T = 1/param.q.B;
t_req = 0 : 0.2 : 40*T;         

% 2. 对四个变量分别插值
xf_req = interp1(t, xf, t_req, 'linear', 'extrap');
vf_req = interp1(t, vf, t_req, 'linear', 'extrap');
xz_req = interp1(t, xz, t_req, 'linear', 'extrap');
vz_req = interp1(t, vz, t_req, 'linear', 'extrap');

t_round  = round(t_req, 4);
xf_round = round(xf_req, 4);
vf_round = round(vf_req, 4);
xz_round = round(xz_req, 4);
vz_round = round(vz_req, 4);

% 把结果写成 5 列，顺序就是 时间 浮子位移 浮子速度 振子位移 振子速度
T = table(t_req.', xf_req.', vf_req.', xz_req.', vz_req.', ...
          'VariableNames', {'t','xf','vf','xz','vz'});