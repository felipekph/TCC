clear all; clc;
%%

auditorio = load('Dados\respostasCombinadas\respostaCombinada_auditorio.mat');
auditorio_smooth = load('Dados\respostasCombinadas\respostaCombinada_auditorio_smooth.mat');
camara = load('Dados\respostasCombinadas\respostaCombinada_camara.mat');
camara_smooth = load('Dados\respostasCombinadas\respostaCombinada_camara_smooth.mat');

%%

figure('Name', 'Resposta')
semilogx(auditorio_smooth.resposta_combinada_smooth.freqVector, ...
    20*log10(abs(auditorio_smooth.resposta_combinada_smooth.freqData))); grid on; hold on;
semilogx(camara_smooth.resposta_combinada_smooth.freqVector, ...
    20*log10(abs(camara_smooth.resposta_combinada_smooth.freqData))); grid on; hold on;
legend('Auditório Wilson Aita', 'Câmara Reverberante', ...
    'Location', 'southeast', 'FontSize', 10)
xlabel('Frequência [Hz]'), ylabel('Magnitude [dB ref. 1]');
title({'Comparação das respostas combinadas do sistema', 'com smooth de 1/24 por oitava'})
xticks([20 100 1000 10000]), xticklabels({'20', '100', '1000', '10000'})
xlim([20 20000])
% print(gcf, '-dpng', '-r300', 'Figuras\respostaCombinada_COMPARACAO.png')

%% campo livre

campo_aberto = load('..\TCC_Processamento_Part4\Dados\18_fevereiro\woofer\woofer_comProtetor.mat');

out = itaAudio(campo_aberto.Recording(:, 1)*campo_aberto.sens_mic, 51200, 'time');
in = itaAudio(campo_aberto.Recording(:, 2)*10, 51200, 'time');

frf = ita_divide_spk(out, in, 'mode', 'linear');

% normalização em 138,9 para comparações
f_norm = 138.9;

% Encontra os índices onde está a freq de junção
idx_campo_aberto = frf.freq2index(f_norm);

% Fator de normalização
norm_factor_campo_aberto = frf.freq2value(f_norm);

% Normalização
campo_aberto_norm = frf/norm_factor_campo_aberto;

campo_aberto_smooth = ita_smooth(campo_aberto_norm, 'LogFreqOctave1', 1/24, 'Abs');

%% plot

figure('Name', 'Resposta')
semilogx(campo_aberto_smooth.freqVector, 20*log10(abs(campo_aberto_smooth.freqData))); grid on; hold on;
semilogx(auditorio_smooth.resposta_combinada_smooth.freqVector, ...
    20*log10(abs(auditorio_smooth.resposta_combinada_smooth.freqData)));
semilogx(camara_smooth.resposta_combinada_smooth.freqVector, ...
    20*log10(abs(camara_smooth.resposta_combinada_smooth.freqData)));
legend('Campo Aberto', 'Auditório Wilson Aita', ...
    'Câmara Reverberante', 'Location', 'southeast', 'FontSize', 10)
xlabel('Frequência [Hz]'), ylabel('Magnitude [dB ref. 1]');
title({'Comparação das respostas do sistema', 'com smooth de 1/24 por oitava'})
xticks([20 100 1000 10000]), xticklabels({'20', '100', '1000', '10000'})
xlim([20 20000])
print(gcf, '-dpng', '-r300', 'Figuras\respostas_COMPARACAO.png')