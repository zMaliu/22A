param = makeParam();

F_pto = param.k*(x_f-x_z)+param.q1.B33*(v_f-v_z);
a_f = (param.q1.f*cos(param.q1.omega*t)-param.q1.A33 *a_f-param.q1.B33*v_f-param.rhogSw -F_pto)/param.m1;
a_z = (param.m2*g+F_pto)/param.m2;
