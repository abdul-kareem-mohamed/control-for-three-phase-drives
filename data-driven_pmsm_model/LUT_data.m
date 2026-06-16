% 1. Define uniform grid vectors for the new Flux inputs
psi_d_vec = linspace(min(psi_d), max(psi_d), 50);
psi_q_vec = linspace(min(psi_q), max(psi_q), 50);
[Psi_d_inv_grid, Psi_q_inv_grid] = meshgrid(psi_d_vec, psi_q_vec);

% 2. Invert the maps using scattered interpolation
Id_LUT_data = griddata(psi_d, psi_q, id_mean, Psi_d_inv_grid, Psi_q_inv_grid, 'natural');
Iq_LUT_data = griddata(psi_d, psi_q, iq_mean, Psi_d_inv_grid, Psi_q_inv_grid, 'natural');

% Handle any NaN values at the extrapolation edges by replacing with 0 or nearest neighbor
Id_LUT_data(isnan(Id_LUT_data)) = 0; 
Iq_LUT_data(isnan(Iq_LUT_data)) = 0;

% Read the generated CSV
transient_data = readtable('virtual_transient_voltages.csv');

% Extract columns into arrays
t_array = transient_data.time;
ud_array = transient_data.ud;
uq_array = transient_data.uq;

% Format exactly as Simulink requires for the 'From Workspace' block
% Create an [N x 2] matrix for each signal
ud_sim_input = [t_array, ud_array];
uq_sim_input = [t_array, uq_array];