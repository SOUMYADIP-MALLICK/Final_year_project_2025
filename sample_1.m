% Define real and imaginary impedance values (ensure 70 values each)
real_impedance = [NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, 92042.7109375, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, 114182.9375, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN];

imag_impedance = [NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, 130520.1328125, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, 129939.828125, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN];
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



