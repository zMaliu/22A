m_f = 4866;
m_z = 2433;
f = 6250;
w = 1.4005;
m = 1335.535;
k_xing = 656.3616;
rho = 1025;
g = 9.8;
s = pi;
k_t = 80000;
k_zn = 10000;

F_pto = k_t*(x_f-x_z)+k_zn(v_f-v_z);
a_f = (f*cos(w*t)-m*a_f-k_xing*v_f-rho*g*s*x_f-F_pto)/m_f;
a_z = (m_z*g+F_pto)/m_z;
