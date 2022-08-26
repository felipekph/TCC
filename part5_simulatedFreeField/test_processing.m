clear all; close all; clc
%%
addpath("Dados");
addpath(genpath("codigos_auxiliares"));

%% Carregamento de dados

ff = load("Dados\17_fevereiro\auditorio\woofer\ff\ff.mat"); % Far-field data
calib = load("Dados\17_fevereiro\auditorio\calibracao\inicio\calibracao_V.mat"); % Calibration at 1 kHz
load("Dados\microfone\mic4942.mat"); % Mic frequency correction

ff.Recording(:, 1) = (ff.Recording(:, 1)/ff.sens_mic);


%% FFT e deconvolução para obtenção da resposta ao impulso

nSamples = length(ff.Recording(:, 1));

[recordingSpectra, ~, freqVector, recordingRawSpectra] = ssFFT(ff.Recording(:, 1), ff.Fs,...
    'amp_mode', 'complex', 'nfft', nSamples*3);

[sweepSpectra, ~, ~, sweepRawSpectra] = ssFFT(ff.Recording(:, 2)*10, ff.Fs,...
    'amp_mode', 'complex', 'nfft', nSamples*3);

% deconvolução
FRF = recordingSpectra./sweepSpectra; % H(jw) = Y(jw) / X(jw)

% Fazendo a suposição de que é um sistema linear teria y(jw) = x(jw) (tensão rms) * h(jw) (resposta ao impulso)
% FRF_dB = 20*log10(rms(ff.Recording(:,2)*10).*abs(FRF)/2e-5); 

FRF_dB = 20*log10(abs(FRF)*rms(ff.Recording(:,2)*10)/2e-5);

%% mic corr

corr_random = pchip([0;mic4942(:, 1);30000],[0;mic4942(:, 2);-15],freqVector); % interpolação da correção do mic 
FRF_dB = FRF_dB + corr_random'; % faz a correção

% Plot
figure()
semilogx(freqVector, FRF_dB);
ylabel('Magnitude em dB [ref. 1]'), xlabel('Frequência [Hz]')
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'})
xlim([20 20000]);
title('Resposta em frequência da medição de campo distante')
grid on;

%% IR

FRF_raw = recordingRawSpectra./(sweepRawSpectra); % com frequências negativas e positivas

impulseResponse = ifft(FRF_raw); 
ir_timeVector = (0:length(impulseResponse)-1)./ff.Fs; % vetor de tempo

% set signal arrival at t = 0s;
pk_idx = find(impulseResponse == max(impulseResponse)); % acha onde ocorre som direto

% % extra
% c = ita_constants({'c'}, 'medium', 'air', 'T', 29.0, 'phi', .4);
% d_estimative = c.value * ir_timeVector(pk_idx);

% Plot ETC
figure()
plot(ir_timeVector, 20*log10(abs(impulseResponse)));
xlim([0 .01]); ylim([-60 0])
title('ETC');
ylabel('Magnitude [dB ref. 1]');
xlabel('Tempo [s]');
grid on;

% Plot ETC with pk at 0
figure()
plot(ir_timeVector - ir_timeVector(pk_idx), 20*log10(abs(impulseResponse./max(impulseResponse))));
xlim([(ir_timeVector(1) - ir_timeVector(pk_idx)) .01]); ylim([-60 0])
title('ETC');
ylabel('Magnitude [dB ref. 1]');
xlabel('Tempo [s]');
grid on;

%% Windowing IR

% Configuração da janela
windowSize = 16; % em samples (valores menores geram fades mais rápidos)
inicioJanela = 0; % em segundos
fimJanela = 0.0085; % em segundos

% Frequência de corte da janela
cutFreq = 1/(fimJanela - inicioJanela);

% Aplicação da janela usando a função de apoio 'easyWindow'
[irJanelada, janela] = easyWindow(impulseResponse, [inicioJanela fimJanela],...
    'windowSize', windowSize, 'samplingRate', 51200);

% window power correction factor
% corr_window = nSamples .* (sum(janela.^2))./(sum(janela).^2);

% window hanning correction
% corr_window = sqrt(8/3);

% window correction
% corr_window = 1/sum(janela)

% Espectro do sinal janelado
[FRF_janelada, ~, freqVec2] = ssFFT(irJanelada/sum(janela), ff.Fs,...
    'amp_mode', 'complex', 'nfft', nSamples);


% ETC normalizada da nova resposta ao impulso com a janela aplicada
figure()
plot(ir_timeVector, 20*log10(abs(irJanelada)/max(abs(irJanelada)))); hold on
plot(ir_timeVector, 20*log10(janela), 'linewidth', 2);
legend('ETC', 'Janela');
title('ETC normalizada e janelada');
ylabel('Magnitude [dB ref. 1]');
xlabel('Tempo [s]');
grid on;

%% Plot da resposta sem janelamento e com janelamento
figure()
semilogx(freqVector, 20*log10(rms(ff.Recording(:,2)*10).*abs(FRF)/2e-5)); grid on; hold on
semilogx(freqVec2, 20*log10(rms(ff.Recording(:,2)*10).*abs(FRF_janelada)/2e-5), 'LineWidth', 2);
legend('FRF medida', 'FRF janelada', 'location', 'south');
ylabel('Magnitude em dB [ref. 1]')
xlabel('Frequência [Hz]')
xlim([20 20e3]); xticks([20 100 1000 10000])
xticklabels({'20', '100', '1000', '10000'})
title('Magnitude normalizada da resposta em frequência (com e sem janelamento)')
grid on;

% semilogx(freqVector, 20*log10(abs(FRF)./max(abs(FRF(idx1)))), '--', 'LineWidth', 1.5); hold on;
% semilogx(freqVec2, 20*log10(abs(FRF_janelada)./max(abs(FRF_janelada(idx1)))), 'LineWidth', 2);
% legend('FRF medida', 'FRF janelada', 'location', 'south');
% ylabel('Magnitude em dB [ref. 1]')
% xlabel('Frequência [Hz]')
% xlim([20, 20e3]); xticks([20 100 1000 10000])
% xticklabels({'20', '100', '1000', '10000'})
% title('Magnitude normalizada da resposta em frequência (com e sem janelamento)')
% grid on;
