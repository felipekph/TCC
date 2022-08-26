clear all; clc; close all;
%% Load e clear

addpath('codigos_auxiliares\');

%% Ref: Closed-Box Loudspeaker Systems Part I: Analysis | Section 6


% Falante na caixa e para a medição com o ruído branco
semMassa_caixa = load('../Dados/ar_livre/medicao_LIVRE_alinhamento_sistema_1_31-Jan-2022_whiteNoise_60s.mat');
comMassa_caixa = load('../Dados/caixa/medicao_CAIXA_alinhamento_sistema_1_31-Jan-2022_whiteNoise_60s.mat');

% Dados calibrados
re = 3.2;

calib_semMassa = re/(abs(semMassa_caixa.Hf(find(semMassa_caixa.freqh == 2)))); % Valor medido no terminal sobre o valor obtido em 2 Hz
calib_comMassa = re/(abs(comMassa_caixa.Hf(find(comMassa_caixa.freqh == 2))));

impedance_semMassa = calib_semMassa.*semMassa_caixa.Hf; % Correção para obtenção da impedância
impedance_comMassa = calib_comMassa.*comMassa_caixa.Hf;

%% Densidade e velocidade

Temp = 26.60;
Hum = 0.42;
% Pa = 100800; % Not sure it is correct

[c, rho0] = ita_constants({'c', 'rho_0'}, 'T', Temp, 'phi', Hum);

%% Procura pela frequência de ressonância e valor de impedância associado
% Para os vetores com dois dados, a posição 1 é ar livre e 2 na caixa

[fs, idx_fs] = find_fs(impedance_semMassa, semMassa_caixa.freqh, 2);
[fc, idx_fc] = find_fs(impedance_comMassa, comMassa_caixa.freqh, 2);

rs = [abs(impedance_semMassa(idx_fs)) abs(impedance_comMassa(idx_fc))]; % Resistência da bobina na freq. de ressonância [Ω]
rc = [rs(1)/re rs(2)/re]; % Razão entre a magnitude da imp. na ressonância e a resistencia DC

r0 = [sqrt(re * rs(1)) sqrt(re * rs(2))]; % Valor de resistência para encontrar as frequências F1 e F2;

f1_semMassa = interp1(abs(impedance_semMassa(1:idx_fs)), semMassa_caixa.freqh(find(1):idx_fs), r0(1));
f2_semMassa = interp1(abs(impedance_semMassa(idx_fs:find(semMassa_caixa.freqh==300))), semMassa_caixa.freqh(idx_fs:find(semMassa_caixa.freqh==300)), r0(1));

f1_comMassa = interp1(abs(impedance_comMassa(1:idx_fc)), comMassa_caixa.freqh(find(1):idx_fc), r0(2));
f2_comMassa = interp1(abs(impedance_comMassa(idx_fc:find(comMassa_caixa.freqh==300))), comMassa_caixa.freqh(idx_fc:find(comMassa_caixa.freqh==300)), r0(2));

%% Cálculos

Qms = (fs * sqrt(rc(1))) / (f2_semMassa - f1_semMassa);
Qes = Qms / (rc(1) - 1);
Qts = (Qms * Qes) / (Qms + Qes);

Qmc = (fc * sqrt(rc(2))) / (f2_comMassa - f1_comMassa);
Qec = Qmc / (rc(2) - 1);
Qtc = (Qmc * Qec) / (Qmc + Qec);

alpha = (fc * Qec)/(fs * Qes) - 1;

Vab = 0.0207;
Vat = alpha/(alpha + 1) * Vab;