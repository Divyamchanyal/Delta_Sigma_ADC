%% Delta-Sigma Modulator: Sampling Capacitor Calculation for Thermal Noise
clear; clc; close all;

%% ========== USER PARAMETERS ==========
order       = 3;            % DSM order (not needed for Cs but kept for completeness)
OSR         = 128;          % Oversampling ratio
Target_SNR  = 130;          % Target ADC SNR in dB
Vref        = 1.0;          % Reference voltage
Fs          = 2e3 * 128;    % Sampling frequency (example)
T_kelvin    = 300;          % Operating temperature (Kelvin)

%% ========== IDEAL SNR CHECK ==========
% (Optional — only used to compare quantization-only SQNR)
opt = 1;
H_ntf = synthesizeNTF(order, OSR, opt);
sqnr_ideal = predictSNR(H_ntf, OSR, -3);

fprintf('Ideal SQNR (Quantization Only): %.2f dB\n', sqnr_ideal);

%% ========== THERMAL NOISE CALCULATION ==========
k_b = 1.380649e-23;       % Boltzmann constant

% Full-scale sine RMS power
P_signal = 0.5 * (Vref^2);

% Target noise power
P_noise_target = P_signal / (10^(Target_SNR/10));

% Required sampling capacitor for thermal noise limit
Cs = (k_b * T_kelvin) / P_noise_target;

%% ========== OUTPUT ==========
fprintf('\n========== RESULTS ==========\n');
fprintf('Target SNR:            %.1f dB\n', Target_SNR);
fprintf('Oversampling Ratio:    %d\n', OSR);
fprintf('Sampling Freq (Fs):    %.2f kHz\n', Fs/1e3);
fprintf('Required Cs:           %.3f pF\n', Cs * 1e12);
fprintf('============================\n');
