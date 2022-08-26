clear all; clc; close all
%%

addpath("Dados");
addpath("codigos_auxiliares\");

%% load data

load("Dados\17_fevereiro\camara_reverberante\woofer\nf\nf.mat"); % [V]
calib = load("Dados\17_fevereiro\camara_reverberante\calibracao\inicio\calibrador.mat");
load("Dados\microfone\mic4942.mat");

sens = rms(calib.Recording(:, 1));

% cria .wav para VLSM
audiowrite('Dados\17_fevereiro\camara_reverberante\woofer\nf\nf.wav', nf.Recording(:, 1), nf.Fs);

%% obtain db spl frequency response

weighting = 'flat'; % 'A'; 'C', 'flat
bandtype = 'third'; % oct, third
filename = 'Dados\17_fevereiro\camara_reverberante\woofer\nf\nf.wav';
Transdutor = 'mic'; % mic, acc - microfone ou acelerômetro
Ref = 2e-5; % Pa
dt = 1; % FAST(0.125 s) ou SLOW(1 s)
% %% correcao do mic 4189-A21 free field para difuso (salas)
% random = load('C:\Users\user\Desktop\mic2689639_random_ok.mat');
fxx = linspace(0, nf.Fs/2, nf.Fs/2+1);
ajuste = 1; % 0 ou 1
corr_random = pchip([0;mic4942(:, 1);30000],[0;mic4942(:, 2);-15],fxx);
% %%
[f_terco, Pxxb_mic, fxx, Pxx_mic] = Level_vslm2(sens, weighting, bandtype, filename, nf.Nfft, Ref, nf.Fs, Transdutor, dt);
% 
%nivel em banda estreita
Lp_est = ajuste .* corr_random+10*log10(Pxx_mic./(Ref.^2));

%% Obtenção de dB SPL para o método de deconvolução
% supoe-se um sistema linear e portanto Y(jw) = (|X(jw)| * Vrms)/ref;

% correção mic
corr_random = pchip([0;mic4942(:, 1);30000],[0;mic4942(:, 2);-15]);

%% plot só NF

semilogx(fxx, Lp_est); grid on; hold on;
xlabel('Frequência [Hz]'), ylabel('Nível de Pressão Sonora [dB re. 20 \muPa]');
title('Resposta de campo próximo');
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'});
xlim([20 20000]); 
print(gcf, '-dpng', '-r300', 'Figuras\camara\Woofer_NearField_response.png')
%% tensão e corrente

figure('Name', 'Sinal de tensão do amplificador')
plot(nf.t, nf.Recording(:, 2) * 10); grid on; %saída monitor [0.1 V/V]
title('Sinal de tensão do amplificador');
xlabel('Tempo [s]'); ylabel('Tensão [V]');
vrms_text = sprintf("%.3f", rms(nf.Recording(:, 2)*10)); vrms_text = strrep(vrms_text, '.',',');
text = sprintf('V_{RMS} = %s V', vrms_text);
legend(text, 'Location', 'southeast')
arruma_fig('% 4.0f','% 2.2f')
print(gcf, '-dpng', '-r300', 'Figuras\camara\Woofer_NearField_ampVoltage.png')

figure('Name', 'Sinal de corrente do amplificador')
plot(nf.t, nf.Recording(:, 3) * 10); grid on; %saída corrente [0.1V/A]
title('Sinal de corrente do amplificador');
xlabel('Tempo [s]'); ylabel('Corrente [A]');
legend(text, 'Location', 'northeast')
irms_text = sprintf('%.3f', rms(nf.Recording(:, 3)*10)); irms_text = strrep(irms_text, '.',',');
text = sprintf('I_{RMS} = %s A', irms_text);
legend(text, 'Location', 'southwest')
arruma_fig('% 4.0f','% 2.2f')
print(gcf, '-dpng', '-r300', 'Figuras\camara\Woofer_NearField_ampCurrent.png')