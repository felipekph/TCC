clear all; clc; close all

%% a) load e plot

load('falante_original\ruido_branco\Hf.mat');

re = 6.3;
calib = 6.3/abs(Hf(find(freqh == 2)));
Hf_original = Hf;
impedance_original = calib.*abs(Hf);

% Plots

ticks = [10 100 1000 5000 10000 20000];
label = {'10', '100', '1k', '5k', '10k', '20k'};

yyaxis left
semilogx(freqh, impedance_original); grid on; hold on
ylabel('Curva de Impedância [\Omega]', 'FontSize', 12)
xlabel('Frequência [Hz]', 'FontSize', 12)
yyaxis right
semilogx(freqh, rad2deg(atan(imag(Hf_original)./real(Hf_original))));
ylabel('Fase [\circ]', 'FontSize', 12)
legend('Impedância', 'Fase', 'FontSize', 10)
title('Curva de impedância e fase original', 'FontSize', 12)
xticks(ticks);
xticklabels(label);
xlim([1 20000])
% print(gcf, '-dpng', '-r600', 'ORIGINAL_impedancia_e_fase.png')

figure('Name', 'Curva de impedância')
semilogx(freqh, impedance_original); grid on;
ylabel('Curva de Impedância [\Omega]', 'FontSize', 12)
xlabel('Frequência [Hz]', 'FontSize', 12)
xticks(ticks);
xticklabels(label);
xlim([1 20000])
title('Curva de impedância original', 'FontSize', 12)
% print(gcf, '-dpng', '-r600', 'ORIGINAL_impedancia.png')

figure('Name', 'Fase')
semilogx(freqh, rad2deg(atan(imag(Hf_original)./real(Hf_original)))); grid on;
ylabel('Fase [\circ]', 'FontSize', 12)
xlabel('Frequência [Hz]', 'FontSize', 12)
title('Fase original', 'FontSize', 12)
xticks(ticks);
xticklabels(label);
xlim([1 20000])
% print(gcf, '-dpng', '-r600', 'ORIGINAL_fase.png')

%% b) load e plots

load('metodo_massa\ruido_branco\Hf.mat');

re = 6.3;
Hf_massa = Hf;
calib = 6.3/abs(Hf(find(freqh == 2)));
impedance_massa = calib.*abs(Hf);

% Plots

ticks = [10 100 1000 5000 10000 20000];
label = {'10', '100', '1k', '5k', '10k', '20k'};

yyaxis left
semilogx(freqh, impedance_massa); grid on; hold on
ylabel('Curva de Impedância [\Omega]', 'FontSize', 12)
xlabel('Frequência [Hz]', 'FontSize', 12)
yyaxis right
semilogx(freqh, rad2deg(atan(imag(Hf)./real(Hf))));
ylabel('Fase [\circ]', 'FontSize', 12)
legend('Impedância', 'Fase', 'FontSize', 10)
title('Curva de impedância e fase pelo método da massa', 'FontSize', 12)
xticks(ticks);
xticklabels(label);
xlim([1 20000])
% print(gcf, '-dpng', '-r600', 'MASSA_impedancia_e_fase.png')

figure('Name', 'Curva de impedância')
semilogx(freqh, impedance_massa); grid on;
ylabel('Curva de Impedância [\Omega]', 'FontSize', 12)
xlabel('Frequência [Hz]', 'FontSize', 12)
title('Curva de impedância pelo método da massa', 'FontSize', 12)
xticks(ticks);
xticklabels(label);
xlim([1 20000])
% print(gcf, '-dpng', '-r600', 'MASSA_impedancia.png')

figure('Name', 'Fase')
semilogx(freqh, rad2deg(atan(imag(Hf)./real(Hf)))); grid on;
ylabel('Fase [\circ]', 'FontSize', 12)
xlabel('Frequência [Hz]', 'FontSize', 12)
title('Fase pelo método da massa', 'FontSize', 12)
xticks(ticks);
xticklabels(label);
xlim([1 20000])
% print(gcf, '-dpng', '-r600', 'MASSA_fase.png')

%% c) load e plots

load('metodo_compliancia\ruido_branco\Hf.mat');

re = 6.3;
Hf_comp = Hf;
calib = 6.3/abs(Hf(find(freqh == 2)));
impedance_comp = calib.*abs(Hf);

% Plots

ticks = [10 100 1000 5000 10000 20000];
label = {'10', '100', '1k', '5k', '10k', '20k'};

yyaxis left
semilogx(freqh, impedance_comp); grid on; hold on
ylabel('Curva de Impedância [\Omega]', 'FontSize', 12)
xlabel('Frequência [Hz]', 'FontSize', 12)
yyaxis right
semilogx(freqh, rad2deg(atan(imag(Hf)./real(Hf))));
ylabel('Fase [\circ]', 'FontSize', 12)
legend('Impedância', 'Fase', 'FontSize', 10)
title('Curva de impedância e fase pelo método da compliância', 'FontSize', 12)
xticks(ticks);
xticklabels(label);
xlim([1 20000])
% print(gcf, '-dpng', '-r600', 'COMPLIANCIA_impedancia_e_fase.png')

figure('Name', 'Curva de impedância')
semilogx(freqh, impedance_comp); grid on;
ylabel('Curva de Impedância [\Omega]', 'FontSize', 12)
xlabel('Frequência [Hz]', 'FontSize', 12)
title('Curva de impedância pelo método da compliância', 'FontSize', 12)
xticks(ticks);
xticklabels(label);
xlim([1 20000])
% print(gcf, '-dpng', '-r600', 'COMPLIANCIA_impedancia.png')

figure('Name', 'Fase')
semilogx(freqh, rad2deg(atan(imag(Hf)./real(Hf)))); grid on;
ylabel('Fase [\circ]', 'FontSize', 12)
xlabel('Frequência [Hz]', 'FontSize', 12)
title('Fase pelo método da compliância', 'FontSize', 12)
xticks(ticks);
xticklabels(label);
xlim([1 20000])
% print(gcf, '-dpng', '-r600', 'COMPLIANCIA_fase.png')

%% d) Primeira parte

% Carregamento e correção para obtenção da curva de impedância experimental
% Z_exp

% Cálculo da indutância
Le_f = abs(sqrt((abs(CI_woofer_med).^2 - re^2)))./(2*pi.*freq);

% Interpolação e extrapolação usando polyfit (thanks Mr. Paulo!!)
[a,b] = find(freq == 1000); % regressao linear de 1kHz até 20kHz
ff = freq(a:end); % frequências de 1kHz ate 20kHz
LL = Le_f(a:end);
p = polyfit(ff,LL,10); % Retorna os coeficientes do polinômio de 10o grau
Le = polyval(p,freq); % Gera a curva usando os coeficientes "p" 

% Plots e save da figura
figure('Name', 'Indutância')
semilogx(freq, 10^3.*Le_f); hold on; grid on;
semilogx(freq, 10^3.*Le);
ticks = [10 100 1000 5000 10000 20000];
label = {'10', '100', '1k', '5k', '10k', '20k'};
xticks(ticks);
xticklabels(label);
title('Indutância da bobina', 'FontSize', 12);
xlabel('Frequência [Hz]', 'FontSize', 12);
ylabel('Indutância [mH]', 'FontSize', 12);
legend('Experimental', 'Polyfit')
xlim([1 20000]);
ylim([0 6]);
% print(gcf, '-dpng', '-r600', 'indutancia_exp_e_extrapolada.png')

%% d) Segunda parte

w = 2*pi.*freq;

% Numerador foi divido em três partes para facilitar
num_1 = 1 + j .* w.* ((Bl^2)/re + Rms + Le/(re*Cms)) .*Cms;
num_2 = -w.^2 .* (Mms + (Rms.*Le)/re) .* Cms;
num_3 = -j .* w.^3 .* Cms .* Mms .* (Le./re);

% Denominador
den = 1 + j .* w .* Rms .* Cms - w.^2 .* Cms .* Mms;

% Equação analítica para a impedância
Zw = re .* (num_1 + num_2 + num_3) ./ (den);

yyaxis left
semilogx(freq, abs(Zw)); grid on; hold on
ylabel('Curva de Impedância [\Omega]', 'FontSize', 12)
xlabel('Frequência [Hz]', 'FontSize', 12)
yyaxis right
semilogx(freq, rad2deg(atan(imag(Zw)./real(Zw))));
ylabel('Fase [\circ]', 'FontSize', 12)
legend('Impedância', 'Fase', 'FontSize', 10)
title('Curva de impedância e fase analítica', 'FontSize', 12)
xticks(ticks);
xticklabels(label);
xlim([1 20000])
% print(gcf, '-dpng', '-r600', 'ANALITICA_impedancia_e_fase.png')

figure('Name', 'Curva de impedância')
semilogx(freq, abs(CI_woofer_med)); grid on; hold on;
semilogx(freq, abs(Zw), '--', 'LineWidth', 1.5);
ylabel('Curva de Impedância [\Omega]', 'FontSize', 12)
xlabel('Frequência [Hz]', 'FontSize', 12)
title('Curva de impedância analítica', 'FontSize', 12)
ticks = [10 100 1000 5000 10000 20000];
label = {'10', '100', '1k', '5k', '10k', '20k'};
xticks(ticks);
xticklabels(label);
legend('Experimental', 'Analítica')
xlim([1 20000])
% print(gcf, '-dpng', '-r600', 'impedancia_ANALITICA_e_EXPERIMENTAL.png')

figure('Name', 'Fase')
semilogx(freq, rad2deg(atan(imag(Hf)./real(Hf)))); grid on; hold on;
semilogx(freqh, rad2deg(atan(imag(Zw)./real(Zw))), '--', 'LineWidth', 1.5);
ylabel('Fase [\circ]', 'FontSize', 12)
xlabel('Frequência [Hz]', 'FontSize', 12)
title('Fase experimental e analítica', 'FontSize', 12)
ticks = [10 100 1000 5000 10000 20000];
label = {'10', '100', '1k', '5k', '10k', '20k'};
xticks(ticks);
xticklabels(label);
legend('Experimental', 'Analítica')
xlim([1 20000])
% print(gcf, '-dpng', '-r600', 'fase_ANALITICA_e_EXPERIMENTAL.png')

%% Plotagem 1, 2 e 3

% a) e b)

ticks = [10 100 1000 5000 10000 20000];
label = {'10', '100', '1k', '5k', '10k', '20k'};

figure('Name', 'Curva de impedância')
semilogx(freqh, impedance_original); hold on; grid on;
semilogx(freqh, impedance_massa, '--', 'LineWidth', 1.5);
ylabel('Curva de Impedância [\Omega]', 'FontSize', 12)
xlabel('Frequência [Hz]', 'FontSize', 12)
title('Curva de impedância original e pelo método da massa', 'FontSize', 12)
xticks(ticks);
xticklabels(label);
xlim([1 20000])
legend('Original', 'Método da massa', 'FontSize', 10)
% print(gcf, '-dpng', '-r600', 'ORIGINAL_E_MASSA_impedancia.png')

figure('Name', 'Fase')
semilogx(freqh, rad2deg(atan(imag(Hf_original)./real(Hf_original)))); hold on; grid on;
semilogx(freqh, rad2deg(atan(imag(Hf_massa)./real(Hf_massa))), '--', 'LineWidth', 1.5);
ylabel('Fase [\circ]', 'FontSize', 12)
xlabel('Frequência [Hz]', 'FontSize', 12)
title('Fase original e pelo método da massa', 'FontSize', 12)
legend('Original', 'Método da massa', 'FontSize', 10);
xticks(ticks);
xticklabels(label);
xlim([1 20000])
% print(gcf, '-dpng', '-r600', 'ORIGINAL_E_MASSA_fase.png')

% a) e c)

figure('Name', 'Curva de impedância')
semilogx(freqh, impedance_original); hold on; grid on;
semilogx(freqh, impedance_comp, '--', 'LineWidth', 1.5);
ylabel('Curva de Impedância [\Omega]', 'FontSize', 12)
xlabel('Frequência [Hz]', 'FontSize', 12)
title('Curva de impedância original e pelo método da compliância', 'FontSize', 12)
legend('Original', 'Método da compliância', 'FontSize', 10)
xticks(ticks);
xticklabels(label);
xlim([1 20000])
% print(gcf, '-dpng', '-r600', 'ORIGINAL_E_COMPLIANCIA_impedancia.png')

figure('Name', 'Fase')
semilogx(freqh, rad2deg(atan(imag(Hf_original)./real(Hf_original)))); hold on; grid on;
semilogx(freqh, rad2deg(atan(imag(Hf_comp)./real(Hf_comp))), '--', 'LineWidth', 1.5);
ylabel('Fase [\circ]', 'FontSize', 12)
xlabel('Frequência [Hz]', 'FontSize', 12)
title('Fase original e pelo método da compliância', 'FontSize', 12)
legend('Original', 'Método da compliância', 'FontSize', 10);
xticks(ticks);
xticklabels(label);
xlim([1 20000])
% print(gcf, '-dpng', '-r600', 'ORIGINAL_E_COMPLIANCIA_fase.png')
