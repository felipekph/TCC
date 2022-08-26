clear all; clc; close all;
%% Load 

addpath(genpath('codigos_auxiliares\'));

% Lembrar que a sensibilidade do microfone é em torno de 0,0490 mV
% Ajuda a saber quando é V e quando é Pa nos plots no dominio do tempo

calib = load('Dados\17_fevereiro\auditorio\calibracao\inicio\calibracao_Pa.mat'); % [Pa]
ff = load('Dados\17_fevereiro\auditorio\woofer\ff\ff.mat'); % [Pa]
nf = load('Dados\17_fevereiro\auditorio\woofer\nf\nf.mat'); % [Pa]
nf.Recording(:, 1) = nf.Recording(:, 1) * nf.sens_mic;
load('mic4942.mat'); % Curva de correção do microfone (B&K Type 4942, theta=0)

measurement = ff.Recording(:, 1); % Pa
voltage = ff.Recording(:, 2) * 10; % V
current = ff.Recording(:, 3) * 10; % A

%% FFT

nSamples = length(measurement);

[nfSpectra, ~, freqVector, nfRaw] = ssFFT(nf.Recording(:, 1)*nf.sens_mic, nf.Fs,...
    'amp_mode', 'complex', 'nfft', length(nf.Recording(:, 1))*3);

[nf_sweepSpectra, ~, freqVector, nfSweepRaw] = ssFFT(nf.Recording(:, 2)*10, ff.Fs,...
    'amp_mode', 'complex', 'nfft', length(nf.Recording(:, 2))*3);

[ffSpectra, ~, freqVector, ffRaw] = ssFFT(ff.Recording(:, 1), ff.Fs,...
    'amp_mode', 'complex', 'nfft', length(ff.Recording(:, 1))*3);

[ff_sweepSpectra, ~, freqVector, ffSweepRaw] = ssFFT(ff.Recording(:, 2)*10, ff.Fs,...
    'amp_mode', 'complex', 'nfft', length(ff.Recording(:, 2))*3);

nf_ir = nfSpectra./nf_sweepSpectra;
ff_ir = ffSpectra./ff_sweepSpectra;

%% Mic correction and rms voltage

corr_random = pchip([0;mic4942(:, 1);30000],[0;mic4942(:, 2);-15],freqVector)'; % interpolação da correção do mic
nf_rms = rms(nf.Recording(:, 2)*10);
ff_rms = rms(ff.Recording(:, 2)*10);

measurement_dB = 20*log10(abs(nfSpectra)) + corr_random;
semilogx(freqVector, measurement_dB); grid on; hold on;
measurement_dB = 20*log10(abs(ffSpectra)) + corr_random;
semilogx(freqVector, measurement_dB);
measurement_dB = 20*log10(nf_rms .* abs(nf_ir)) + corr_random;
semilogx(freqVector, measurement_dB);
measurement_dB = 20*log10(ff_rms .* abs(ff_ir)) + corr_random;
semilogx(freqVector, measurement_dB);
legend('Near field', 'Far field', 'NF IR', 'FF IR')
xlim([20 20000])

%% ETC

nfFRF_raw = nfRaw./(nfSweepRaw); % com frequências negativas e positivas
ffFRF_raw = ffRaw./(ffSweepRaw);

nfIR = ifft(nfFRF_raw); 
ffIR = ifft(ffFRF_raw);
ir_timeVector = (0:length(nfIR)-1)./nf.Fs; % vetor de tempo

figure('Name', 'Near-field ETC')
plot(ir_timeVector, 20*log10(abs(nfIR)));
xlim([0 .01]); ylim([-60 0])
title('ETC');
ylabel('Magnitude [dB ref. 1]');
xlabel('Tempo [s]');
grid on;

figure('Name', 'Far-field ETC')
plot(ir_timeVector, 20*log10(abs(ffIR)));
xlim([0 .01]); ylim([-60 0])
title('ETC');
ylabel('Magnitude [dB ref. 1]');
xlabel('Tempo [s]');
grid on;
