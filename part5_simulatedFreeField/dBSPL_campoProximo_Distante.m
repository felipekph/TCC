clear all; clc;
%% Load

calib = load('Dados\17_fevereiro\camara_reverberante\calibracao\inicio\calibrador.mat');
sens = rms(calib.Recording);

% Near-field
load("Dados\17_fevereiro\camara_reverberante\woofer\nf\nf.mat");
nf.Recording(:, 1) = nf.Recording(:, 1)/sens;

figure('Name', 'NF no tempo')
plot(nf.t, nf.Recording(:, 1)) % verificar se está em Pa ou V

% Far-field
ff = load("Dados\17_fevereiro\camara_reverberante\woofer\ff\ff.mat");
ff.Recording(:, 1) = ff.Recording(:, 1)/sens;

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

%% Obtenção de dB SPL para o método de deconvolução
% supoe-se um sistema linear e portanto Y(jw) = (|X(jw)| * Vrms)/ref;

% correção mic 4942
corr_random = pchip([0;mic4942(:, 1);30000],[0;mic4942(:, 2);-15], campo_proximo_frf.freqVector);

% tensão RMS enviada ao sistema para a medição de cmapo próximo e distante
nf_Vrms = rms(nf.Recording(:, 2)*10);
ff_Vrms = rms(ff.Recording(:, 2)*10);

% respostas em dB SPL
nf_dBSPL = 20*log10((abs(campo_proximo_frf.freqData) * nf_Vrms) / 2e-5) + corr_random;
ff_dBSPL = 20*log10((abs(campo_distante_frf.freqData) * ff_Vrms) / 2e-5) + corr_random;

resposta_distante = ita_smooth(itaAudio(ff_dBSPL, 51200, 'freq'), 'LogFreqOctave1', 1/24, 'Abs');

% plot near-field DBSPL
figure('Name', 'Resposta')
semilogx(campo_proximo_frf.freqVector, nf_dBSPL); grid on; hold on;
legend('Campo próximo', 'Location', 'southwest'); title('Resposta de campo próximo')
xlabel('Frequência [Hz]'), ylabel('Nível de Pressão Sonora [dB re. 20 \muPa]');
xticks([20 100 1000 10000]), xticklabels({'20', '100', '1000', '10000'})
xlim([20 20000]); ylim([20 100])
print(gcf, '-dpng', '-r300', 'Figuras\camara_campoProximo_FRF_dBSPL.png')

% plot far field DBSPL
figure('Name', 'Resposta')
semilogx(campo_distante_frf.freqVector, ff_dBSPL); grid on; hold on;
legend('Campo distante', 'Location', 'southwest'); title('Resposta de campo distante')
xlabel('Frequência [Hz]'), ylabel('Nível de Pressão Sonora [dB re. 20 \muPa]');
xticks([20 100 1000 10000]), xticklabels({'20', '100', '1000', '10000'})
xlim([20 20000]); ylim([20 110])
print(gcf, '-dpng', '-r300', 'Figuras\camara_campoDistante_FRF_dBSPL.png')