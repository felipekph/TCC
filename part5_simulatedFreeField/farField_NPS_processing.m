clear all; clc; close all
%%

addpath("Dados");
addpath("codigos_auxiliares\");

%% load data

load("Dados\17_fevereiro\camara_reverberante\tweeter\ff\ff.mat"); % [V]
calib = load("Dados\17_fevereiro\camara_reverberante\calibracao\inicio\calibrador.mat");
load("Dados\microfone\mic4942.mat");

sens = rms(calib.Recording(:, 1));

% cria .wav para VLSM
audiowrite('Dados\17_fevereiro\camara_reverberante\tweeter\ff\ff.wav', Recording(:, 1), Fs);

%% obtain db spl frequency response

weighting = 'flat'; % 'A'; 'C', 'flat
bandtype = 'third'; % oct, third
filename = 'Dados\17_fevereiro\camara_reverberante\tweeter\ff\ff.wav';
Transdutor = 'mic'; % mic, acc - microfone ou acelerômetro
Ref = 2e-5; % Pa
dt = 1; % FAST(0.125 s) ou SLOW(1 s)
% %% correcao do mic 4189-A21 free field para difuso (salas)
% random = load('C:\Users\user\Desktop\mic2689639_random_ok.mat');
fxx = linspace(0, Fs/2, Fs/2+1);
ajuste = 1; % 0 ou 1
corr_random = pchip([0;mic4942(:, 1);30000],[0;mic4942(:, 2);-15],fxx);
% %%
[f_terco, Pxxb_mic, fxx, Pxx_mic] = Level_vslm2(sens, weighting, bandtype, filename, Nfft, Ref, Fs, Transdutor, dt);
% 
%nivel em banda estreita
Lp_est = ajuste .* corr_random+10*log10(Pxx_mic./(Ref.^2));

%% we could search for 

c = 343; % speed of sound
dc = 0.35; % maximum linear dimension

f_max = c / (2*pi*dc); % a - driver radius in meters 

%% plot só NF

semilogx(fxx, Lp_est); grid on; hold on;
xlabel('Frequência [Hz]'), ylabel('Nível de Pressão Sonora [dB re. 20 \muPa]');
title('Resposta de campo distante');
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'});
xlim([20 20000]); 
print(gcf, '-dpng', '-r300', 'Figuras\camara\Tweeter_FarField_NPSresponse.png')
%% tensão e corrente

figure('Name', 'Sinal de tensão do amplificador')
plot(t, Recording(:, 2) * 10); grid on; %saída monitor [0.1 V/V]
title('Sinal de tensão do amplificador');
xlabel('Tempo [s]'); ylabel('Tensão [V]');
vrms_text = sprintf("%.3f", rms(Recording(:, 2)*10)); vrms_text = strrep(vrms_text, '.',',');
text = sprintf('V_{RMS} = %s V', vrms_text);
legend(text, 'Location', 'southeast')
arruma_fig('% 4.0f','% 2.2f')
print(gcf, '-dpng', '-r300', 'Figuras\camara\Tweeter_FarField_ampVoltage.png')

figure('Name', 'Sinal de corrente do amplificador')
plot(t, Recording(:, 3) * 10); grid on; %saída corrente [0.1V/A]
title('Sinal de corrente do amplificador');
xlabel('Tempo [s]'); ylabel('Corrente [A]');
legend(text, 'Location', 'northeast')
irms_text = sprintf('%.3f', rms(Recording(:, 3)*10)); irms_text = strrep(irms_text, '.',',');
text = sprintf('I_{RMS} = %s A', irms_text);
legend(text, 'Location', 'southwest')
arruma_fig('% 4.0f','% 2.2f')
print(gcf, '-dpng', '-r300', 'Figuras\camara\Tweeter_FarField_ampCurrent.png')

%% plot NF e NF ajustado

% semilogx(fxx, Lp_est); grid on; hold on;
% semilogx(fxx, Lp_est_1m, '--'); grid on; hold on;
% xlabel('Frequência [Hz]'), ylabel('Nível de Pressão Sonora [dB re. 20 \muPa]');
% title('Resposta de campo próximo');
% legend('NF', 'NF to FF 1m')
% xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'});
% xlim([20 20000]); 