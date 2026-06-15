% ----
% ---------------------------------------------------------------------
% Task 7 - Calculate and Visualize Flux Linkage Maps
% -------------------------------------------------------------------------

% 1. Define Machine Parameters
R_s = 1.0;        % Stator resistance (Ohms) - update with measured value
p = 4;            % Pole pairs
n_meas = 400;     % Measurement speed (min^-1)

% Calculate electrical angular velocity (rad/s)
omega_el = n_meas * (2 * pi / 60) * p;

% -------------------------------------------------------------------------
% 2. Load or Extract Mean Values
% (Assuming id_mean, iq_mean, ud_mean, uq_mean are already in the workspace 
% from the first part of the provided script or our virtual dataset).
%
% For demonstration, these are placeholder mean vectors based on the 
% 7 operating points we defined earlier:
% id_mean = [0, -2, -4, -3, -2, 0, 0];
% iq_mean = [0, 0, 0, 2, 4, 4, 2];
% ud_mean = [...]; 
% uq_mean = [...];
% -------------------------------------------------------------------------

% 3. Calculate Flux Linkages based on rearranged steady-state equations
psi_d = (uq_mean - R_s .* iq_mean) ./ omega_el;
psi_q = (R_s .* id_mean - ud_mean) ./ omega_el;

% 4. Create an Interpolation Grid
% Define the resolution of your lookup table (e.g., 50x50 points)
id_vec = linspace(min(id_mean), max(id_mean), 50);
iq_vec = linspace(min(iq_mean), max(iq_mean), 50);

% Generate the 2D grid for the axes
[Id_grid, Iq_grid] = meshgrid(id_vec, iq_vec);

% 5. Interpolate the Scattered Data
% 'natural' or 'cubic' interpolation handles non-linear magnetic saturation well
Psi_d_grid = griddata(id_mean, iq_mean, psi_d, Id_grid, Iq_grid, 'natural');
Psi_q_grid = griddata(id_mean, iq_mean, psi_q, Id_grid, Iq_grid, 'natural');

% 6. Visualization (for the required screenshot)
figure('Name', 'Flux Linkage Maps', 'Position', [100, 100, 1000, 400]);

% Plot d-axis flux linkage
subplot(1, 2, 1);
surf(Id_grid, Iq_grid, Psi_d_grid);
title('d-axis Flux Linkage \psi_d(i_d, i_q)');
xlabel('i_d (A)');
ylabel('i_q (A)');
zlabel('\psi_d (Vs)');
colorbar;
shading interp; % Smooths the color mapping
grid on;
view(135, 30); % Adjust viewing angle

% Plot q-axis flux linkage
subplot(1, 2, 2);
surf(Id_grid, Iq_grid, Psi_q_grid);
title('q-axis Flux Linkage \psi_q(i_d, i_q)');
xlabel('i_d (A)');
ylabel('i_q (A)');
zlabel('\psi_q (Vs)');
colorbar;
shading interp;
grid on;
view(135, 30);

sgtitle('Task 7: Interpolated PMSM Flux Linkage Maps');

% -------------------------------------------------------------------------
% Task 8 - Calculate Apparent and Differential Inductances
% -------------------------------------------------------------------------
% Prerequisite: This script assumes that Id_grid, Iq_grid, Psi_d_grid, 
% Psi_q_grid, id_vec, and iq_vec are already loaded in the workspace 
% from the Task 7 interpolation script.

%% 1. Calculate Apparent Inductances (L_app = psi / i)
% We use element-wise division (./) across the grids.

% d-axis Apparent Inductance
L_d_app = Psi_d_grid ./ Id_grid;

% Handle division by zero at i_d = 0 to prevent 'Inf' in our matrices
L_d_app(Id_grid == 0) = NaN; 

% q-axis Apparent Inductance
L_q_app = Psi_q_grid ./ Iq_grid;

% Handle division by zero at i_q = 0
L_q_app(Iq_grid == 0) = NaN;

%% 2. Calculate Differential Inductances (Finite Differences: L = d(psi) / di)
% MATLAB's 'gradient' function uses central finite differences for interior 
% points and single-sided differences for the edges of the grid.

% Calculate the uniform step sizes from your 1D vectors
di_d = id_vec(2) - id_vec(1);
di_q = iq_vec(2) - iq_vec(1);

% Compute derivatives for the d-axis flux linkage map
% The gradient function returns the derivative with respect to columns (i_d)
% first, then rows (i_q).
[L_d_diff, L_dq_cross] = gradient(Psi_d_grid, di_d, di_q);

% Compute derivatives for the q-axis flux linkage map
[L_qd_cross, L_q_diff] = gradient(Psi_q_grid, di_d, di_q);

%% 3. Visualization for Verification
figure('Name', 'Inductance Maps', 'Position', [100, 100, 1200, 800]);

% Plot d-axis Apparent Inductance
subplot(2, 2, 1);
surf(Id_grid, Iq_grid, L_d_app);
title('Apparent Inductance L_{d,app}');
xlabel('i_d (A)'); ylabel('i_q (A)'); zlabel('Inductance (H)');
shading interp; colorbar; view(135, 30);

% Plot q-axis Apparent Inductance
subplot(2, 2, 2);
surf(Id_grid, Iq_grid, L_q_app);
title('Apparent Inductance L_{q,app}');
xlabel('i_d (A)'); ylabel('i_q (A)'); zlabel('Inductance (H)');
shading interp; colorbar; view(135, 30);

% Plot d-axis Differential Inductance
subplot(2, 2, 3);
surf(Id_grid, Iq_grid, L_d_diff);
title('Differential Inductance L_d');
xlabel('i_d (A)'); ylabel('i_q (A)'); zlabel('Inductance (H)');
shading interp; colorbar; view(135, 30);

% Plot q-axis Differential Inductance
subplot(2, 2, 4);
surf(Id_grid, Iq_grid, L_q_diff);
title('Differential Inductance L_q');
xlabel('i_d (A)'); ylabel('i_q (A)'); zlabel('Inductance (H)');
shading interp; colorbar; view(135, 30);

sgtitle('Task 8: Apparent vs. Differential Inductance Maps');