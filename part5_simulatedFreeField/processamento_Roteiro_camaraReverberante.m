%% Load

calib = load('Dados\17_fevereiro\camara_reverberante\calibracao\inicio\calibrador.mat');
sens = rms(calib.Recording);

% Near-field
load("Dados\17_fevereiro\camara_reverberante\woofer\nf\nf.mat");
nf.Recording(:, 1) = nf.Recording(:, 1);

figure('Name', 'NF no tempo')
plot(nf.t, nf.Recording(:, 1)) % verificar se está em Pa ou V

% Far-field
ff = load("Dados\17_fevereiro\camara_reverberante\woofer\ff\ff.mat");
ff.Recording(:, 1) = ff.Recording(:, 1);

figure('Name', 'FF no tempo')
plot(ff.t, ff.Recording(:, 1)) % verificar se está em Pa ou V

% Mic
load('Dados/microfone/mic4942.mat');

%% Obtenção H(jw) = Y(jw)/X(jw)

% itaAudio para a medição de campo próximo e campo distante (Y(jw))
campo_proximo = itaAudio(nf.Recording(:, 1), 51200, 'time');
campo_distante = itaAudio(ff.Recording(:, 1), 51200, 'time');

% itaAudio para as medições de tensão para cada caso (X(jw))
excitation_nf = itaAudio(nf.Recording(:, 2)*10, 51200, 'time');
excitation_ff = itaAudio(ff.Recording(:, 2)*10, 51200, 'time');

% Obtenção de H(jw)
campo_proximo_frf = ita_divide_spk(campo_proximo, excitation_nf, 'mode', 'linear');
campo_distante_frf = ita_divide_spk(campo_distante, excitation_ff, 'mode', 'linear');

% FRF
figure('Name', 'Resposta')
semilogx(campo_distante_frf.freqVector, 20*log10(abs(campo_distante_frf.freqData))); grid on; hold on;
legend('FRF', 'Location', 'southwest')
xlabel('Frequência [Hz]'), ylabel('Magnitude [dB ref. 1]');
title('FRF da medição de campo distante na Câmara Reverberante')
xticks([20 100 1000 10000]), xticklabels({'20', '100', '1000', '10000'})
xlim([20 20000]); 
% print(gcf, '-dpng', '-r300', 'Figuras\camara_campoDistante_FRF.png')

% campo_distante_dB = 20*log10(abs(campo_distante_frf.freqData)*rms(ff.Recording(:,2))*10/2e-5);

% ETC
% campo_distante_frf.plot_time_dB;
% xlim([0 0.012]); ylim([-50 -20])
% campo_proximo_frf.plot_time_dB;
% xlim([0 0.013])

%% Janelamento (campo distante)
% Desloca som direto para t=0
direct_sound_idx = find(campo_distante_frf.timeData == max(campo_distante_frf.timeData));
time_arrival = campo_distante_frf.timeVector(direct_sound_idx);

new_timeVector = campo_distante_frf.timeVector - time_arrival;

figure('Name', 'Impulso original')
plot(campo_distante_frf.timeVector, 20*log10(abs(campo_distante_frf.timeData))); grid on;
xlim([0.000 0.012]); ylim([-100 -30]); 
title({'Resposta ao impulso', '(Energy Time Curve - ETC)'})
xlabel('Tempo [s]'), ylabel('Magnitude [dB ref. 1]')
%print(gcf, '-dpng', '-r300', 'Figuras\respostaImpulso_camara_original.png')

figure('Name', 'Impulso deslocado')
plot(new_timeVector, 20*log10(abs(campo_distante_frf.timeData))); grid on;
xlim([new_timeVector(1) 0.012]); ylim([-100 -30]); 
title({'Resposta ao impulso com som direto em t=0s', '(Energy Time Curve - ETC)'})
xlabel('Tempo [s]'), ylabel('Magnitude [dB ref. 1]')
%print(gcf, '-dpng', '-r300', 'Figuras\respostaImpulso_camara_deslocada.png')

slope = 0.05;

leftStart = 0.0023;
leftStop = leftStart*(1 + slope);

rightStop = 0.0023+0.0063;
rightStart = rightStop*(1 - slope);

timeInterval = [leftStop, leftStart, rightStart, rightStop];

cutFreq = 1/(rightStop - leftStart);

% Aplicação da janela

campo_distante_janelado = ita_time_window(campo_distante_frf, timeInterval, @hann, 'time');

% campo_distante_janelado.plot_freq

figure('Name', 'Resposta')
semilogx(campo_distante_frf.freqVector, 20*log10(abs(campo_distante_frf.freqData))); grid on; hold on;
semilogx(campo_distante_janelado.freqVector, 20*log10(abs(campo_distante_janelado.freqData)), '--', 'LineWidth', 2.5); grid on; hold on;
legend('FRF original', 'FRF janelada', 'Location', 'southwest')
xlabel('Frequência [Hz]'), ylabel('Magnitude [dB ref. 1]');
title({'Comparação da FRF sem janelamento com a FRF janelada', 'para a medição de campo distante'})
xticks([20 100 1000 10000]), xticklabels({'20', '100', '1000', '10000'})
xlim([20 20000]); 
% print(gcf, '-dpng', '-r300', 'Figuras\FRF_sem&comJanela_camara_comparativo.png')

figure('Name', 'Resposta')
semilogx(campo_distante_janelado.freqVector, 20*log10(abs(campo_distante_janelado.freqData))); grid on; hold on;
% semilogx(campo_proximo_norm.freqVector, 20*log10(abs(resposta_combinada.freqData)));
legend('Resposta de campo distante janelada', 'Location', 'southwest')
xlabel('Frequência [Hz]'), ylabel('Magnitude [dB ref. 1]');
xticks([20 100 1000 10000]), xticklabels({'20', '100', '1000', '10000'})
xlim([20 20000]); 

figure('Name', 'Resposta')
semilogx(campo_distante_janelado.freqVector, 20*log10(abs(campo_distante_janelado.freqData))); grid on; hold on;
semilogx(campo_proximo_frf.freqVector, 20*log10(abs(campo_proximo_frf.freqData)))
legend('Resposta de campo distante janelada')
xlabel('Frequência [Hz]'), ylabel('Magnitude [dB ref. 1]');
xticks([20 100 1000 10000]), xticklabels({'20', '100', '1000', '10000'})
xlim([20 20000]); 


%%

f_merge = 138.9;

% Encontra os índices onde está a freq de junção
idx_campo_proximo = campo_proximo_frf.freq2index(f_merge);
idx_campo_distante = campo_distante_janelado.freq2index(f_merge);

% Fator de normalização
norm_factor_campo_proximo = campo_proximo_frf.freq2value(f_merge);
norm_factor_campo_distante = campo_distante_janelado.freq2value(f_merge);

% Normalização
campo_proximo_norm = campo_proximo_frf/norm_factor_campo_proximo;
campo_distante_norm = campo_distante_janelado/norm_factor_campo_distante;

figure('Name', 'Resposta')
semilogx(campo_proximo_norm.freqVector, 20*log10(abs(campo_proximo_norm.freqData))); grid on; hold on;
semilogx(campo_distante_norm.freqVector, 20*log10(abs(campo_distante_norm.freqData)));
legend('Campo próximo normalizado', 'Campo distante normalizado', 'Location', 'southwest')
xlabel('Frequência [Hz]'), ylabel('Magnitude [dB ref. 1]');
title({'Resposta de campo próximo e de campo distante', ...
    'normalizados em f_{merge}= 138,90 Hz'})
xticks([20 100 1000 10000]), xticklabels({'20', '100', '1000', '10000'})
xlim([20 20000]); ylim([-40 10])
% print(gcf, '-dpng', '-r300', 'Figuras\camara_campoProximo&Distante_normalizados.png')

% Resposta combinada
resposta_combinada = [campo_proximo_norm.freqData(1:idx_campo_proximo) ;...
    campo_distante_norm.freqData(idx_campo_proximo+1:end)];

resposta_combinada = itaAudio(resposta_combinada, 51200, 'freq');

resposta_combinada_smooth = ita_smooth(resposta_combinada, 'LogFreqOctave1', 1/24, 'Abs');

figure('Name', 'Resposta')
semilogx(campo_proximo_norm.freqVector, 20*log10(abs(resposta_combinada.freqData))); grid on;
legend('Resposta completa do sistema', 'Location', 'southwest')
xlabel('Frequência [Hz]'), ylabel('Magnitude [dB ref. 1]');
title('Resposta combinada do sistema')
xticks([20 100 1000 10000]), xticklabels({'20', '100', '1000', '10000'})
xlim([20 20000])
% print(gcf, '-dpng', '-r300', 'Figuras\respostaCombinada_camara.png')

figure('Name', 'Resposta')
semilogx(campo_proximo_norm.freqVector, 20*log10(abs(resposta_combinada_smooth.freqData))); grid on; hold on;
legend('Resposta combinada do sistema (com smooth)', 'Location', 'southwest')
xlabel('Frequência [Hz]'), ylabel('Magnitude [dB ref. 1]');
title({'Curva de resposta em frequência combinada do sistema', 'com smooth de 1/24 por oitava'})
xticks([20 100 1000 10000]), xticklabels({'20', '100', '1000', '10000'})
xlim([20 20000])
% print(gcf, '-dpng', '-r300', 'Figuras\respostaCombinada_camara_smooth.png')

%% dr e 
d = 1.000;
h = 1.500;

dr = 2 * sqrt((d/2)^2 + h^2);
T = (dr - d)/343;
delta_f = 1/T;