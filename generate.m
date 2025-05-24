% Define voltage measurements (70 values)
voltage_module = [
NaN, NaN, NaN, NaN, NaN, 388.28928876067044, NaN, NaN, NaN, NaN, NaN, 190376.22546159013, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN, NaN];
% Remove NaN values and ensure column vector format
voltage_module = voltage_module(~isnan(voltage_module))';
% Transpose (') to ensure column vector if needed

% Create EIT model with 16 electrodes
module_inverse = mk_common_model('c2c2', 16);

% Define stimulation pattern (Adjacent Stimulation)
stim = mk_stim_patterns(16, 1, '{ad}', '{ad}', {}, 1);
module_inverse.fwd_model.stimulation = stim;

% Compute background jacobian and homogeneous voltage
image = calc_jacobian_bkgnd(module_inverse);
voltage_homogeneous = fwd_solve(image);

% Get the expected number of voltage measurements
expected_meas_count = size(voltage_homogeneous.meas, 1);

% Ensure voltage_module matches expected measurement count
if length(voltage_module) ~= expected_meas_count
    warning('Mismatch: voltage_module has %d values, expected %d', length(voltage_module), expected_meas_count);

    % Adjust the size to match the expected measurement count
    if length(voltage_module) < expected_meas_count
        voltage_module = [voltage_module; zeros(expected_meas_count - length(voltage_module), 1)];
    else
        voltage_module = voltage_module(1:expected_meas_count);
    end
end

% Perform inverse solve (reconstruction)
reconstruction = inv_solve(module_inverse, voltage_homogeneous, voltage_module);

% Display the reconstructed image
show_fem(reconstruction, [1,0,0]);

