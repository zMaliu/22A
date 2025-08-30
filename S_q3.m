clc;clear;
param = makeParam();
tspan = 0:0.05:150;

k_zn_b = 0;
k_zn_a = 10000;
k_zn_a_theta = 1000;
y0 = [0; 0; 0; 0];
opts = odeset('RelTol',1e-6,'AbsTol',1e-9);
[t, y] = ode45(@(t,y) F_ode(t,y,param,k_zn_a,k_zn_b), tspan, y0, opts);
[t, y_theta] = ode45(@(t,y_theta) F_ode_theta(t,y_theta,param,k_zn_a_theta), tspan, y0, opts);

xf = y(:,1);   
vf = y(:,2);
xz = y(:,3);   
vz = y(:,4);

theta_xf = y_theta(:,1);
theta_vf = y_theta(:,2);
theta_xz = y_theta(:,3);
theta_vz = y_theta(:,4);

T = 1/param.q.B;
% t_req = 0 : 0.2 : 40*T;  
t_req = 0 : 10 : 100; 

xf_req = interp1(t, xf, t_req, 'linear', 'extrap');
vf_req = interp1(t, vf, t_req, 'linear', 'extrap');
xz_req = interp1(t, xz, t_req, 'linear', 'extrap');
vz_req = interp1(t, vz, t_req, 'linear', 'extrap');
theta_xf_req = interp1(t, theta_xf, t_req, 'linear', 'extrap');
theta_vf_req = interp1(t, theta_vf, t_req, 'linear', 'extrap');
theta_xz_req = interp1(t, theta_xz, t_req, 'linear', 'extrap');
theta_vz_req = interp1(t, theta_vz, t_req, 'linear', 'extrap');

t_round  = round(t_req, 4);
xf_round = round(xf_req, 4);
vf_round = round(vf_req, 4);
xz_round = round(xz_req, 4);
vz_round = round(vz_req, 4);
theta_xf_round = round(theta_xf_req, 4);
theta_vf_round = round(theta_vf_req, 4);
theta_xz_round = round(theta_xz_req, 4);
theta_vz_round = round(theta_vz_req, 4);

% 把结果写成 5 列，顺序就是 时间 浮子位移 浮子速度 振子位移 振子速度
T = table(t_req.', xf_req.', vf_req.', theta_xf_round.', theta_vf_round.', ...
                    xz_req.', vz_req.', theta_xz_round.', theta_vz_round.',...
          'VariableNames', {'时间','f垂荡位移','f垂荡速度','f纵摇角位移 ','f纵摇角速度 ','z垂荡位移','z垂荡速度','z纵摇角位移 ','z纵摇角速度 '});
% writetable(T, 'result3.xlsx');
writetable(T, 'result300.xlsx');