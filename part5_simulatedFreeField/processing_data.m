clear all; clc; close all;
%% process data

calib_inicio = load("Dados\17_fevereiro\auditorio\calibracao\inicio\calibracao.mat");

calib_sens = rms(calib_inicio.Recording(:,1));

data_nf = load("Dados\17_fevereiro\auditorio\woofer\nf\nf.mat");
data_ff = load("Dados\17_fevereiro\auditorio\woofer\ff\ff.mat");

%% 

% c0 = ita_constants({'c'}, 'medium', 'air', 'T', 29.1, 'phi', .4);
%% fix raw data amplitude to calib sensitivity

data_nf.Recording(:, 1) = calib_sens/data_nf.sens_mic .* data_nf.Recording(:, 1);
data_ff.Recording(:, 1) = calib_sens/data_ff.sens_mic .* data_ff.Recording(:, 1);

%% impulse response for ff and ETC

[recordingSpectra, ~, freqVector, recordingRawSpectra] = ssFFT(data_ff.Recording(:, 1), 51200,...
    'amp_mode', 'complex', 'nfft', length(data_ff.Recording(:, 1)));

[sweepSpectra, ~, ~, sweepRawSpectra] = ssFFT(data_ff.Recording(:, 2), 51200,...
    'amp_mode', 'complex', 'nfft', length(data_ff.Recording(:, 1)));

ir_freq = recordingSpectra ./ sweepSpectra;

figure('Name', 'Impulse response')
semilogx(freqVector, 20*log10(abs(ir_freq)));
xlabel('Frequência [Hz]'), ylabel('Magnitude [dB]');
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'})
xlim([20 20000])

%% ETC

ir_time = ifft(ir_freq);
ir_time_dB = 20*log10(abs(ir_time));
ir_timeVector = (0:length(ir_time)-1)/data_ff.Fs;

% Direct sound and first reflection arrival time at microphone

[idx_time, ~] = find(ir_time_dB == max(ir_time_dB));
[idx_first_reflection, ~] = find(ir_time_dB == max(ir_time_dB(idx_time+20:idx_time+500)));
text = sprintf('Direct sound arrival time occurs at: %.5f ms\nFirst reflection at: %.5f ms', ...
    ir_timeVector(idx_time), ir_timeVector(idx_first_reflection));
disp(text);

ir_timeVector = ir_timeVector - ir_timeVector(idx_time);

plot(ir_timeVector.*1000, ir_time_dB);
title('Energy Time Curve');
ylabel('Magnitude [dB]');
xlabel('Tempo [ms]');
xlim([-.5 15]); ylim([-80 max(ir_time_dB)+5])
grid on;

