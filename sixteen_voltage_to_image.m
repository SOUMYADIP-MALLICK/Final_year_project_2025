run E:\eidors\eidors-v3.11-ng\eidors\startup.m

format long g
N = 400;
temp = typecast(reshape([randi([0 (2^8-1)], 6, N, 'uint8'); randi([0 (2^5-1)], 1, N); zeros(1, N,'uint8')],[],1),'uint64')
iwant = double(temp) / flintmax;
iwant(iwant == 0) = 1

module_inverse = mk_common_model('c2c2',16);
image = calc_jacobian_bkgnd(module_inverse);
voltage_homogeneous = fwd_solve(image);
reconstruction= inv_solve(module_inverse, voltage_homogeneous,iwant);
show_fem(reconstruction,[1,0,0])




