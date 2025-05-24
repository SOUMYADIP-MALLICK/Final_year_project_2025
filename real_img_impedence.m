% Define real and imaginary impedance values (ensure 70 values each)
real_impedance = [42434.71484375, NaN, NaN, NaN, NaN, 422.0600280761719, 48652.4765625, 50921.66015625, NaN, NaN, 48652.4765625, 50921.66015625, NaN, NaN, 4067.727783203125, 26369.486328125, 26369.486328125, NaN, NaN, 32589.6015625, 32589.6015625, 26369.486328125, 26369.486328125, NaN, NaN, 31076.0859375, 32589.6015625, 20319.95703125, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, 466.5262451171875, 18728.765625, 18728.765625, NaN, NaN, 24935.19140625, 24935.19140625, 12229.400390625, 12899.853515625, NaN, NaN, 18728.765625, 18728.765625, NaN, NaN, 24935.19140625, 24935.19140625, 12229.400390625, 12899.853515625, NaN, NaN, 10165.54296875, 48652.4765625, 53075.4296875, NaN, NaN, 53910.29296875, 53910.29296875, 46417.54296875, 44977.890625, NaN, NaN, 42491.453125, 42491.453125, 48652.4765625, 47741.3671875, NaN, NaN, 53910.29296875, 53910.29296875, 46417.54296875, 46417.54296875, NaN, NaN, 41497.30078125, 41497.30078125, 8341.2841796875, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, 1332.297119140625];

imag_impedance = [736.78759765625, NaN, NaN, NaN, NaN, -147.47219848632812, -1269.62109375, 884.145263671875, NaN, NaN, -1269.62109375, 884.145263671875, NaN, NaN, -23512.69140625, 3461.210693359375, 3461.210693359375, NaN, NaN, 1753.0594482421875, 1753.0594482421875, 3461.210693359375, 3461.210693359375, NaN, NaN, 3615.011962890625, 1753.0594482421875, 1313.8880615234375, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, -1002.1340942382812, 856.1658325195312, 856.1658325195312, NaN, NaN, -1218.1328125, -1218.1328125, 1429.1669921875, 675.5438842773438, NaN, NaN, 856.1658325195312, 856.1658325195312, NaN, NaN, -1218.1328125, -1218.1328125, 1429.1669921875, 675.5438842773438, NaN, NaN, 736.8280029296875, -1269.62109375, -1385.0411376953125, NaN, NaN, -2486.3310546875, -2486.3310546875, -8986.6416015625, -6855.7109375, NaN, NaN, -11756.2119140625, -11756.2119140625, -1269.62109375, -5599.25244140625, NaN, NaN, -2486.3310546875, -2486.3310546875, -8986.6416015625, -8986.6416015625, NaN, NaN, -9851.3212890625, -9851.3212890625, -32368.544921875, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, -9518.9765625];


% Ensure impedance values are column vectors
real_impedance = real_impedance(:);
imag_impedance = imag_impedance(:);

% Expected measurement count based on EIT setup
expected_meas_count = 208;

% Adjust real_impedance length
if length(real_impedance) < expected_meas_count
    real_impedance = [real_impedance; zeros(expected_meas_count - length(real_impedance), 1)];
elseif length(real_impedance) > expected_meas_count
    real_impedance = real_impedance(1:expected_meas_count);
end

% Adjust imag_impedance length
if length(imag_impedance) < expected_meas_count
    imag_impedance = [imag_impedance; zeros(expected_meas_count - length(imag_impedance), 1)];
elseif length(imag_impedance) > expected_meas_count
    imag_impedance = imag_impedance(1:expected_meas_count);
end



% Replace NaN values with zeros
real_impedance(isnan(real_impedance)) = 0;
imag_impedance(isnan(imag_impedance)) = 0;

% Combine real and imaginary parts into a complex impedance measurement
impedance_measurements = real_impedance + 1i * imag_impedance;

% Ensure impedance_measurements is a column vector
impedance_measurements = impedance_measurements(:);

% Create EIT model with 16 electrodes
module_inverse = mk_common_model('c2c2', 16);

% Define stimulation pattern (Adjacent Stimulation)
stim = mk_stim_patterns(16, 1, '{ad}', '{ad}', {}, 1);
module_inverse.fwd_model.stimulation = stim;

% Compute background jacobian and homogeneous voltage
image = calc_jacobian_bkgnd(module_inverse);
voltage_homogeneous = fwd_solve(image);

% Perform inverse solve (reconstruction)
reconstruction = inv_solve(module_inverse, voltage_homogeneous, impedance_measurements);

% Ignore NaN values in reconstruction
reconstruction.elem_data(isnan(reconstruction.elem_data)) = 0;

% Display the reconstructed image
show_fem(reconstruction, [1,0,0]);



