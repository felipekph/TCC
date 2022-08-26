%%
clear all; close all;
%% Carrega e calcula a sensibilidade do microfone pela calibração do início das medições

calib_inicio = load("Dados\18_fevereiro\calibracao\calibracao_inicio.mat");

%% Carregamento de arquivos

load("Dados\18_fevereiro\woofer\woofer_comProtetor.mat");
load("mic4189.mat");
addpath("codigos_auxiliares\");

%% 
Recording(:, 1) = sens_mic .* Recording(:, 1);

% pega a sensibilidade da calibração em 1kHz
sens_mic = rms(calib_inicio.Recording);

out = itaAudio(Recording(:, 1)/sens_mic, 51200, 'time');
in = itaAudio(Recording(:, 2)*10, 51200, 'time');

frf = ita_divide_spk(out, in, 'mode', 'linear');
% audiowrite("frf.wav", frf.timeData, 51200);

% audiowrite("Dados\18_fevereiro\centro_geometrico\centroGeo_semProtetor.wav", Recording(:, 1), Fs);

%% Processamento

weighting = 'flat'; % 'A'; 'C', 'flat
bandtype = 'third'; % oct, third
filename = 'woofer_comProtetor.wav';
Transdutor = 'mic'; % mic, acc - microfone ou acelerômetro
Ref = 2e-5; % Pa
dt = 1; % FAST(0.125 s) ou SLOW(1 s)
% %% correcao do mic 4189-A21 free field para difuso (salas)
% random = load('C:\Users\user\Desktop\mic2689639_random_ok.mat');
fxx = linspace(0, Fs/2, Fs/2+1);
ajuste = 1; % 0 ou 1
corr_random = pchip([0;mic4189(:, 1);30000],[0;mic4189(:, 2);-15],fxx);
% %%
[f_terco, Pxxb_mic, fxx, Pxx_mic] = Level_vslm2(sens_mic, weighting, bandtype, filename, Fs, Ref, Fs, Transdutor, dt);
% 
%nivel em banda estreita
Lp_est = ajuste .* corr_random+10*log10(Pxx_mic./(Ref.^2));

%% Plot

% Plot
figure('Name', 'Sinal de tensão do microfone')
plot(t, Recording(:, 1)); grid on;
title('Sinal de tensão do microfone (centro geométrico - sem protetor)');
xlabel('Tempo [s]'); ylabel('Tensão [V]');
arruma_fig('% 4.0f','% 2.2f')
% print(gcf, '-dpng', '-r600', 'Figuras\centroGeo_mic_voltage_semProtetor.png')

figure('Name', 'Sinal no domínio da frequência')
semilogx(fxx, Lp_est);
xlabel('Frequência [Hz]')
ylabel('Nível de Pressão Sonora [dB re. 20 \muPa]'); grid; hold on
title(sprintf('Medição no eixo do Woofer (com protetor)'))
legend('Woofer (com protetor)', 'Location', 'southwest')
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'}) 
xlim([20 20000]); ylim([30 90])
% yticklabels({'30' '40', '50', '60', '70', '80', '85'})
grid on;
arruma_fig('% 4.0f','% 2.0f')
% print(gcf, '-dpng', '-r600', 'Figuras\woofer_mic_frequencia_comProtetor.png')

%% Plot amplificador
figure('Name', 'Sinal de tensão do amplificador')
plot(t, Recording(:, 2) * 10); grid on; %saída monitor [0.1 V/V]
title('Sinal de tensão do amplificador (centro geométrico - sem protetor)');
xlabel('Tempo [s]'); ylabel('Tensão [V]');
vrms_text = sprintf("%.3f", rms(Recording(:, 2)*10)); vrms_text = strrep(vrms_text, '.',',');
text = sprintf('V_{RMS} = %s V', vrms_text);
legend(text, 'Location', 'northeast')
arruma_fig('% 4.0f','% 2.2f')
% print(gcf, '-dpng', '-r600', 'Figuras\centroGeo_amp_voltage_semProtetor.png')

figure('Name', 'Sinal de corrente do amplificador')
plot(t, Recording(:, 3) * 10); grid on; %saída corrente [0.1V/A]
title('Sinal de corrente do amplificador (centro geométrico - sem protetor)');
xlabel('Tempo [s]'); ylabel('Tensão [A]');
legend(text, 'Location', 'northeast')
irms_text = sprintf('%.3f', rms(Recording(:, 3)*10)); irms_text = strrep(irms_text, '.',',');
text = sprintf('I_{RMS} = %s A', irms_text);
legend(text, 'Location', 'southwest')
arruma_fig('% 4.0f','% 2.2f')
% print(gcf, '-dpng', '-r600', 'Figuras\centroGeo_amp_corrente_semProtetor.png')

%% Sinal deconvoluido H(jw) campo aberto

% correção mic
corr_random = pchip([0;mic4189(:, 1);30000],[0;mic4189(:, 2);-15],frf.freqVector);

% tensão RMS enviada ao sistema
v_rms = rms(Recording(:,2)*10);

frf_dBSPL = 20*log10((abs(frf.freqData).*v_rms)./2e-5) + corr_random;

figure('Name', 'Sinal no domínio da frequência')
semilogx(frf.freqVector, 20*log10((abs(frf.freqData).*v_rms)./2e-5));
xlabel('Frequência [Hz]')
ylabel('Nível de Pressão Sonora [dB re. 20 \muPa]'); grid; hold on
title(sprintf('Medição no eixo do Woofer (com protetor)'))
legend('Woofer (com protetor)', 'Location', 'southwest')
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'}); 
xlim([20 20000]); grid on; ylim([30 90])
arruma_fig('% 4.0f','% 2.0f')
% print(gcf, '-dpng', '-r300', 'Figuras\woofer_hjw_freq_comProtetor.png')

%% comparacao

figure('Name', 'Sinal no domínio da frequência')
semilogx(fxx, Lp_est); grid on; hold on;
semilogx(frf.freqVector, 20*log10((abs(frf.freqData).*v_rms)./2e-5));
xlabel('Frequência [Hz]')
ylabel('Nível de Pressão Sonora [dB re. 20 \muPa]'); grid; hold on
title({'Comparação entre o sinal medido e o sinal deconvoluido', 'para a medição em campo aberto no eixo do Woofer'})
legend('Sinal medido', 'Sinal deconvoluido', 'Location', 'southwest')
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'}); 
xlim([20 20000]); grid on; ylim([30 90])
arruma_fig('% 4.0f','% 2.0f')
% print(gcf, '-dpng', '-r300', 'Figuras\woofer_comparacao.png')

%% teste

% dB_azul_novo = pchip(fxx, Lp_est, frf.freqVector);
% teste = dB_azul_novo - frf_dBSPL;
% 
% figure('Name', 'Sinal no domínio da frequência')
% semilogx(frf.freqVector, teste); grid on; hold on;
% xlabel('Frequência [Hz]')
% ylabel('Nível de Pressão Sonora [dB re. 20 \muPa]'); grid; hold on
% title({'Comparação entre o sinal medido e o sinal deconvoluido', 'para a medição em campo aberto no eixo do Woofer'})
% legend('Sinal medido', 'Sinal deconvoluido', 'Location', 'southwest')
% xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'}); 
% xlim([20 20000]); grid on; 
% arruma_fig('% 4.0f','% 2.0f')