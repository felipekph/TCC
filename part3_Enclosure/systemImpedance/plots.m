clear all; clc; close all;
%% Path and loading

addpath('Dados/');

data = load('medicao_SISTEM_1_18-Feb-2022_whiteNoise_60s.mat');

Hf = 3.6/abs(data.Hf(find(data.freqh==2))) .* data.Hf;

%% Plot

figure('Name', 'Função de transferência')
semilogx(data.freqh, abs(Hf), ...
    'LineWidth', 1.0);  grid on; hold on
xlabel('Frequência [Hz]')
ylabel('Impedância [\Omega]'); title("Curva de Impedância do Sistema")
xlim([20 20000])
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'});
xlim([20 20000])
ylim([3 12]); yticks([3 4.5 6 7.5 9 10.5 12]);
yticklabels({'3,00', '4,50', '6,00', '7,50', '9,00', '10,50', '12,00'})
% print(gcf, '-dpng', '-r600', '../../Figuras/impedancia_Sistema.png')

figure('Name', 'Função de transferência')
semilogx(data.freqh, atan2d(imag(Hf), real(Hf)), ...
    'LineWidth', 1.0);  grid on; hold on
xlabel('Frequência [Hz]');
ylabel('Fase [deg]');
title("Fase do Sistema");
xlim([20 20000])
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'});
xlim([20 20000])
% print(gcf, '-dpng', '-r600', '../../Figuras/fase_Sistema.png')
