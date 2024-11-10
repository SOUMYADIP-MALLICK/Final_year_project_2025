voltage_module =[
0.26
0.19
0.18
0.26
0.48

0.09
0.06
0.06
0.11
0.48

0.26
0.10
0.05
0.06
0.26

0.19
0.09
0.10
0.06
0.19

0.19
0.05
0.10
0.09
0.20

0.49
0.12
0.06
0.09
0.20

0.27
0.07
0.05
0.10
0.29

0.49
0.26
0.20
0.21
0.30];



module_inverse = mk_common_model('c2c2',8);
image = calc_jacobian_bkgnd(module_inverse);
voltage_homogeneous = fwd_solve(image);


reconstruction= inv_solve(module_inverse, voltage_homogeneous,voltage_module);
show_fem(reconstruction,[1,0,0])

