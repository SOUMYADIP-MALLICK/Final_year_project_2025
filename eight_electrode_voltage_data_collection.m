% Generate 115 random voltage values between 0 and 1
voltage_module = [0, 2647.8405080172874, 2511.9114712398455, 2320.8874846029444, NaN, 2819.262190723348, NaN, NaN, 2794.610508570098, 0, 2967.8691314294233, 2517.8611405674183, NaN, 3225.3438044729864, NaN, NaN, 2511.9114712398455, 2813.002375648528, 0, 2502.0229996763255, NaN, 2661.8387960765663, NaN, NaN, 2120.095113895079, 2208.713288302289, 2104.1005187800147, 0, NaN, 2434.606129808555, NaN, NaN, NaN, NaN, NaN, NaN, 0, NaN, NaN, NaN, 2779.041529828363, 3023.397234787525, 3064.4565423458052, 2604.8426948785864, NaN, 0, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, 0, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, 0];
% Convert voltage_module from 1x64 to 64x1
voltage_module = voltage_module(:);

voltage_module(isnan(voltage_module)) = 0;

% Create the model for 16 electrodes
module_inverse = mk_common_model('c2c2', 8);  % Adjusted to 16 electrodes

% Calculate the Jacobian for the background model
image = calc_jacobian_bkgnd(module_inverse);

% Perform the forward solve with the homogeneous model
voltage_homogeneous = fwd_solve(image);

% Perform the inverse solve with the voltage measurements
reconstruction = inv_solve(module_inverse, voltage_homogeneous, voltage_module);

% Show the reconstructed FEM with a color map
show_fem(reconstruction, [1, 0, 0]);  % Adjust color as needed



