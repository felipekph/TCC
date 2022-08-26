clear all; clc; close all;
%% Load e clear

addpath('codigos_auxiliares\');

%% Ref: Closed-Box Loudspeaker Systems Part I: Analysis | Section 6


% Falante na caixa e para a medição com o ruído branco
ar_livre = load('../Dados/ar_livre/medicao_LIVRE_alinhamento_sistema_1_31-Jan-2022_whiteNoise_60s.mat');
caixa = load('../Dados/caixa/medicao_CAIXA_alinhamento_sistema_1_31-Jan-2022_whiteNoise_60s.mat');

% Dados calibrados
re = 3.2;

calib_ar = re/(abs(ar_livre.Hf(find(ar_livre.freqh == 2)))); % Valor medido no terminal sobre o valor obtido em 2 Hz
calib_caixa = re/(abs(caixa.Hf(find(caixa.freqh == 2))));

impedance_ar = calib_ar.*ar_livre.Hf; % Correção para obtenção da impedância
impedance_caixa = calib_caixa.*caixa.Hf;

%% Plot curvas de impedância

figure('Name', 'Curva de impedancia')
semilogx(ar_livre.freqh, 3.2./(abs(ar_livre.Hf(find(ar_livre.freqh==2)))).*abs(ar_livre.Hf));  grid on; hold on
semilogx(caixa.freqh, 3.2./(abs(caixa.Hf(find(caixa.freqh==2)))).*abs(caixa.Hf));  grid on; hold on
xlabel('Frequência [Hz]', 'FontSize', 12)
ylabel('Impedância [\Omega]', 'FontSize', 12)
title('Curvas de impedância para o alto-falante ao ar livre e na caixa', 'FontSize', 12)
legend('Woofer - Ar Livre', 'Woofer - Caixa', 'Location', 'southeast')
xlim([20 20000])
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'})
% print(gcf, '-dpng', '-r300', '..\Figuras\curvas_arLivre&Caixa.png')


%% Densidade e velocidade

Temp = 25.79;
Hum = 0.39;
% Pa = 100800; % Not sure it is correct

[c, rho0] = ita_constants({'c', 'rho_0'}, 'T', Temp, 'phi', Hum);

%% Procura pela frequência de ressonância e valor de impedância associado
% Para os vetores com dois dados, a posição 1 é ar livre e 2 na caixa

[fs, idx_fs] = find_fs(impedance_ar, ar_livre.freqh, 2);
[fc, idx_fc] = find_fs(impedance_caixa, caixa.freqh, 2);

rs = [abs(impedance_ar(idx_fs)) abs(impedance_caixa(idx_fc))]; % Resistência da bobina na freq. de ressonância [Ω]
rc = [rs(1)/re rs(2)/re]; % Razão entre a magnitude da imp. na ressonância e a resistencia DC

r0 = [re*sqrt(rc(1)) re*sqrt(rc(2))]; % Valor de resistência para encontrar as frequências F1 e F2;

f1_ar = interp1(abs(impedance_ar(1:idx_fs)), ar_livre.freqh(find(1):idx_fs), r0(1));
f2_ar = interp1(abs(impedance_ar(idx_fs:find(ar_livre.freqh==300))), ar_livre.freqh(idx_fs:find(ar_livre.freqh==300)), r0(1));

f1_caixa = interp1(abs(impedance_caixa(1:idx_fc)), caixa.freqh(find(1):idx_fc), r0(2));
f2_caixa = interp1(abs(impedance_caixa(idx_fc:find(caixa.freqh==300))), caixa.freqh(idx_fc:find(caixa.freqh==300)), r0(2));

%% Cálculos

Qms = (fs * sqrt(rc(1))) / (f2_ar - f1_ar);
Qes = Qms / (rc(1) - 1);
Qts = Qms / rc(1);

Qmc = (fc * sqrt(rc(2))) / (f2_caixa - f1_caixa);
Qec = Qmc / (rc(2) - 1);
Qtc = Qmc / rc(2);

alpha = (fc * Qec)/(fs * Qes) - 1;

Vab = 0.0205;
Vat = alpha/(alpha + 1) * Vab;