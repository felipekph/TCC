clear all; clc; close all;
%%

addpath('Dados\18_fevereiro\');
addpath('codigos_auxiliares\');
load("mic4189.mat");
%% Escolha o arquivo a ser processado e criado seu .wav

[file, path] = uigetfile();
data = load(append(path,file));

% Criação .wav
Fs = 51200;
sens_mic = 0.4561;
deltaf = 1; % resolucao do eixo de frequencias, em Hz (deta f)
Nfft = (1/deltaf)*Fs; % numero de pontos da FFT
text = sprintf('%s.wav', file(1:end-4));
audiowrite(append(path, text), sens_mic .* data.Recording(:, 1), Fs);

%% Processing using VLSM

weighting = 'flat'; % 'A'; 'C', 'flat
bandtype = 'third'; % oct, third
filename = append(path,text);
Transdutor = 'mic'; % mic, acc - microfone ou acelerômetro
Ref = 2e-5; % Pa
dt = 1; % FAST(0.125 s) ou SLOW(1 s)
% %% correcao do mic 4189-A21 free field para difuso (salas)
% random = load('C:\Users\user\Desktop\mic2689639_random_ok.mat');
fxx = linspace(0, Fs/2, Nfft/2+1);
ajuste = 1; % 0 ou 1
corr_random = pchip([0;mic4189(:, 1);30000],[0;mic4189(:, 2);-15],fxx);
% %%
[f_terco, Pxxb_mic, fxx, Pxx_mic] = Level_vslm2(sens_mic, weighting, bandtype, filename, Fs, Ref, Nfft, Transdutor, dt);
% 
%nivel em banda estreita
Lp_est = ajuste .* corr_random+10*log10(Pxx_mic./(Ref.^2));

%% Plot

semilogx(fxx, Lp_est)
xlabel('Frequência [Hz]')
ylabel('NPS [dB] - ref.: 20\muPa'); grid; hold on
ylim([min(Lp_est)-5 max(Lp_est)+5])
legend('mic. 1 - ponderação Z', 'Location', 'southwest')
xlim([20 20000])
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'})
title(sprintf('Calibração no início da cadeia de medições'))