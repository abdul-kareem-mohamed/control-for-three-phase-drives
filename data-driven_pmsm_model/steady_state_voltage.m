% -------------------------------------------------------------------------
% Script: steady_state_voltage.m
% Purpose: Task 4 - Determine current combinations and calculate expected
%          steady-state voltages for PMSM characterization.
% -------------------------------------------------------------------------

clear; clc;

%% 1. Nameplate Data and Machine Parameters
% Constant parameters from the motor nameplate
I_nom = 4.6;      % Nominal current (A)
U_nom = 165;      % Nominal voltage (V)
n_nom = 4050;     % Nominal speed (min^-1)
P_nom = 1000;     % Nominal power (W)
p = 4;            % Pole pairs

% Parameters to be updated from previous measurements
% NOTE: Update R_s with the value you measured in Task 1 with the Fluke multimeter.
R_s = 1.0;        % Placeholder for Stator resistance (Ohms)

% NOTE: Because the exact inductances are the goal of this exercise, 
% use constant placeholder estimates here for the feed-forward calculation.
L_d = 0.005;      % Placeholder for d-axis inductance (H)
L_q = 0.005;      % Placeholder for q-axis inductance (H)

% Estimate permanent magnet flux linkage (psi_pm) from nominal data.
% Alternatively, calculate this exactly using your induced voltage measurement from Task 2.
omega_nom_el = 2 * pi * (n_nom / 60) * p;
psi_pm = (U_nom * sqrt(2/3)) / omega_nom_el; 

%% 2. Operating Point Setup
% Select a fixed speed safely below nominal speed (e.g., 1000 min^-1 as used in Task 2)
n_meas = 400; 
omega_el = 2 * pi * (n_meas / 60) * p; % Electrical angular velocity (rad/s)

%% 3. Current Combinations Vectors (id, iq)
% Seven discrete steps to capture baseline, pure d-axis, cross-coupling, and pure q-axis.
% Steps are kept small to avoid large transients.
id_mean = [ 0, -2, -4, -3, -2,  0,  0]; % d-axis current command (A)
iq_mean = [ 0,  0,  0,  2,  4,  4,  2]; % q-axis current command (A)

% Safety Check: Ensure no combination exceeds the maximum current circle (I_nom)
I_mag = sqrt(id_mean.^2 + iq_mean.^2);
if any(I_mag > I_nom)
    warning('Safety Violation: One or more current combinations exceed the nominal current of 4.6 A!');
else
    disp('Safety Check Passed: All current vectors are within the maximum current circle.');
end

%% 4. Steady-State Voltage Calculation
% Pre-allocate voltage arrays for speed
ud_mean = zeros(1, length(id_mean));
uq_mean = zeros(1, length(iq_mean));

% Calculate necessary steady-state voltage values for each operating point
for k = 1:length(id_mean)
    ud_mean(k) = R_s * id_mean(k) - omega_el * L_q * iq_mean(k);
    uq_mean(k) = R_s * iq_mean(k) + omega_el * L_d * id_mean(k) + omega_el * psi_pm;
end

%% 5. Display Output for Simulink / State Machine
fprintf('\n--- Operating Point Setup ---\n');
fprintf('Fixed Speed: %.0f min^-1\n', n_meas);
fprintf('Electrical Freq: %.2f rad/s\n\n', omega_el);

disp('--- Command Vectors for Simulink Workspace ---');
disp('id_mean array (A):'); 
disp(id_mean);

disp('i_q array (A):'); 
disp(iq_mean);

disp('ud_mean array (V):'); 
disp(round(ud_mean, 3));

disp('uq_mean array (V):'); 
disp(round(uq_mean, 3));