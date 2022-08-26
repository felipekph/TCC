clear all; clc; close all;
%%

addpath('LTSpice\');

% Dados medidos
x_sem = load('Dados/sem_falante/sweep/medicao_crossover_FRF_1_26-Jan-2022_sweep_60s.mat');
x_com = load('Dados/com_falante/sweep/medicao_crossover_FRF_1_26-Jan-2022_sweep_60s.mat');

% Dados simulados LTSpice
ltspice_sem = load('Dados/ltspice/ltspice_tccOriginal_sweep_semFalante.mat');
ltspice_com = load('Dados/ltspice/ltspice_tcc_comFalante.mat');
ltspice_piorCaso = load('Dados/ltspice/ltspice_tcc_piorCaso.mat');

%%

% Medido sem falante
LPF_sem = x_sem.Hf_LPF;
HPF_sem = x_sem.Hf_HPF;
freq = x_sem.freqh;

overall_response_sem = LPF_sem + HPF_sem;

% Simulado sem falante
LPF_lt_sem = ltspice_sem.woofer_norm;
HPF_lt_sem = ltspice_sem.tweeter_norm;
freq_lt = ltspice_sem.freq;

overall_response_lt_sem = LPF_lt_sem + HPF_lt_sem;

% SOMENTE SE QUISER VER ALGO, IGNORAR
% LPF_ita = itaAudio(LPF, 51200, 'freq');
% LPF_smooth = ita_smooth(LPF_ita,'LogFreqOctave1',1,'Abs');
% overall_response_smooth = LPF_smooth.freqData + HPF;
%%

% Medido com falante
LPF_com = x_com.Hf_LPF;
HPF_com = x_com.Hf_HPF;

% fc_LPF =
% fc_HPF =

overall_response_com = LPF_com + HPF_com;

% Simulado com falante representado por resistor
LPF_lt_com = ltspice_com.woofer./ltspice_com.input;
HPF_lt_com = ltspice_com.tw./ltspice_com.input;
freq_lt = ltspice_com.freq;

overall_response_lt_com = (real(LPF_lt_com) + real(HPF_lt_com)) + ...
    1i.*(imag(LPF_lt_com) + (-1 .* imag(HPF_lt_com)));

%% Plots 

% SITUAÇÃO SEM FALANTE

figure('Name', 'Função de transferência')
semilogx(freq, 20*log10(abs(LPF_sem)), 'LineWidth', 2); grid on; hold on
semilogx(freq, 20*log10(abs(HPF_sem)), 'LineWidth', 2);
semilogx(freq_lt, 20*log10(abs(LPF_lt_sem)), '--', 'LineWidth', 2);
semilogx(freq_lt, 20*log10(abs(HPF_lt_sem)), '--', 'LineWidth', 2);
% semilogx(freq, 20*log10(abs(overall_response_sem)), '--', 'LineWidth', 1.5);
title('Resposta em Frequência do Crossover (sem falante conectado)')
xlabel('Frequência [Hz]')
ylabel('Função de Transferência [dB]')
legend('LPF', 'HPF', 'LPF simulado', 'HPF simulado', 'Location', 'northwest')
xlim([20 20000])
ylim([-80 80])
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'});
% print(gcf, '-dpng', '-r300', 'Figuras/resposta_medido&simulado_semFalante.png')

figure('Name', 'Função de transferência')
semilogx(freq, 20*log10(abs(overall_response_sem)), 'LineWidth', 2); grid on; hold on;
semilogx(freq_lt, 20*log10(abs(overall_response_lt_sem)), '--', 'LineWidth', 2);
title('Resposta em Frequência do Crossover (sem falante conectado)')
xlabel('Frequência [Hz]')
ylabel('Função de Transferência [dB]')
legend('Resposta conjunta', 'Resposta conjunta simulada', 'location', 'northwest')
xlim([20 20000])
% ylim([-20 80])
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'});
% print(gcf, '-dpng', '-r300', 'Figuras/respostaConjunta_medido&simulado_semFalante.png')

%%

% SITUAÇÃO COM FALANTE

figure('Name', 'Função de transferência')
semilogx(freq, 20*log10(abs(LPF_com)), 'LineWidth', 2);  grid on; hold on
semilogx(freq, 20*log10(abs(HPF_com)), 'LineWidth', 2);
semilogx(freq_lt, 20*log10(abs(LPF_lt_com)), '--', 'LineWidth', 2);  grid on; hold on
semilogx(freq_lt, 20*log10(abs(HPF_lt_com)), '--', 'LineWidth', 2);
title('Resposta em Frequência do Crossover (com falante conectado)')
xlabel('Frequência [Hz]')
ylabel('Função de Transferência [dB]')
legend('LPF', 'HPF', 'LPF simulado', 'HPF simulado', 'Location', 'southwest')
xlim([20 20000])
ylim([-30 5])
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'});
% print(gcf, '-dpng', '-r300', 'Figuras/resposta_medido&simulado_comFalante.png')

figure('Name', 'Função de transferência')
semilogx(freq, 20*log10(abs(overall_response_com)), 'LineWidth', 2); grid on; hold on;
semilogx(freq_lt, 20*log10(abs(overall_response_lt_com)), '--', 'LineWidth', 2);
title('Resposta em Frequência do Crossover (com falante conectado)')
xlabel('Frequência [Hz]')
ylabel('Função de Transferência [dB]')
legend('Resposta conjunta', 'Resposta conjunta simulada', 'location', 'northwest')
xlim([20 20000])
ylim([-10 10])
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'});
% print(gcf, '-dpng', '-r300', 'Figuras/respostaConjunta_medido&simulado_comFalante.png')

%% PLOT situação pior caso e projetado

figure('Name', 'Função de transferência')
semilogx(freq_lt, 20*log10(abs(LPF_lt_com)), 'LineWidth', 2);  grid on; hold on
semilogx(freq_lt, 20*log10(abs(ltspice_piorCaso.woofer)), '--', 'LineWidth', 2);
title('Resposta em Frequência do Crossover (comparação com pior caso)')
xlabel('Frequência [Hz]')
ylabel('Função de Transferência [dB]')
legend('LPF | Original', 'LPF | Pior caso', 'Location', 'southwest')
xlim([20 20000])
ylim([-30 5])
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'});
% print(gcf, '-dpng', '-r300', 'Figuras/comparacao_piorCaso.png')

%% PLOT FC

LPF_impFc = LPF_com(1:find(freq == 20000));
HPF_impFc = HPF_com(1:find(freq == 20000));

LPF_fc = freq(find(abs(LPF_impFc) == max(abs(LPF_impFc))));

%% Cálculo redução L-Pad

% Foi tomado uma média dos valores entre 4 kHz e 20 kHz para definir a
% redução efetiva do atenuador L-Pad

lowFreq = find(freq == 4000);
highFreq = find(freq == 20000);

R_lpad = mean(20*log10(abs(HPF_impFc(lowFreq:highFreq))));



