clear all; clc; close all;
%% Load e clear

%% Ref: Closed-Box Loudspeaker Systems Part I: Analysis | Section 6

% Falante ao ar livre e para a medição com o ruído branco
% load('../Dados/ar_livre/')
% 
% ar_livre.Hf = Hf;
% ar_livre.freq = freqh;
% ar_livre.coe = coe;

% Falante na caixa e para a medição com o ruído branco
load('../Dados/caixa/medicao_CAIXA_alinhamento_sistema_5_31-Jan-2022_whiteNoise_60s.mat')

caixa.Hf = Hf;
caixa.freq = freqh;
caixa.coe = coe;

clearvars -except caixa

%% Densidade e velocidade
Temp = 25.79;
Hum = 0.39;
Pa = 100800;


[c, rho0] = ita_constants({'c', 'rho_0'}, 'T', Temp, 'phi', Hum, 'p', Pa);


clearvars -except c rho0 caixa

%% Procura pela frequência de ressonância e valor de impedância associado
% Para o falante dentro da caixa

re = 3.2;

% Procura o índice onde ocorre o pico de ressonância
idx_fc = find(caixa.Hf == max(caixa.Hf(1:find(caixa.freq == 300)))); % Posição da frequência de ressonância

% Valor de correção para a curva. Este é a razão entre o valor medido de
% resistência no terminal do alto-falante sobre o que é medido pela NI,
% porém, neste caso é usado para a NI o valor de resistência em 2 Hz.
calib = re/(abs(caixa.Hf(find(caixa.freq == 2)))); % Valor medido no terminal sobre o valor obtido em 2 Hz

% Correção nos valores de original.Hf, assim, obtem-se a impedância de fato
% Para os vetores de impedância e frequência, usou-se então os valores de 1
% Hz até 20 kHz apenas.
impedance = calib.*caixa.Hf(1:find(caixa.freq == 20000)); % Correção para obtenção da impedância
caixa.freq = caixa.freq(1:find(caixa.freq == 20000));

% Frequência de ressonância 'fs'
% Resistência\Impedância na frequência de ressonância 'rs'
fc = caixa.freq(idx_fc); % Frequência de ressonância na caixa[Hz]
rs = abs(impedance(idx_fc)); % Resistência da bobina na freq. de ressonância [Ω]

rc = rs/re; % Razão entre a magnitude da imp. na ressonância e a resistencia DC


%% 

rn = min(abs(impedance(idx_fc:end))); % Valor mínimo de resistência após a freq. de ressonância [Ω]

if rn > 4 & rn < 8
   rn = 8; 
else
   rn = 4;
end

r0 = re*sqrt(rc); % Valor de resistência para encontrar as frequências F1 e F2;

f1 = interp1(abs(impedance(1:idx_fc)), caixa.freq(find(1):idx_fc), r0); % F1 pelo método geométrico
f2 = interp1(abs(impedance(idx_fc:find(caixa.freq==300))), caixa.freq(idx_fc:find(caixa.freq==300)), r0); % F2 pelo método geométrico

%% Cálculos

Qmc = (fc * sqrt(rc)) / (f2 - f1);
Qec = Qmc / (rc - 1);
Qtco = Qmc / rc;

%% Plots e print


% text = sprintf(['Re = %.2f [Ohm];\nRs = %.2f [Ohm];\nR_0 = %.2f [Ohm];\n' ...
%     'Fs = %.2f [Hz];\nf1 = %.2f [Hz];\nf2 = %.2f [Hz];\nMms = %.2f [g];\n' ...
%     'Cms = %.2f [um/N];\nRms = %.2f [kg/s];\nQms = %.2f [-];\nQes = %.2f [-];\n' ...
%     'Qts = %.2f [-];\nSd = %.2f [cm^2];\nVas = %.2f [L];\nn0 = %.2f [%%];\n' ...
%     'Bl = %.2f [N/A].'], re, rs, r0, fs, f1, f2, Mms*1000, ...
%     Cms*10^6, Rms, Qms, Qes, Qts, Sd*10000, Vas*1000, n0, Bl);
% 
% disp(text)

% Plot para ajudar a ver se os valores fazem sentido
% yyaxis left
% semilogx(original.freq, abs(impedance)); grid on; hold on
% ylabel('Curva de Impedância [\Omega]', 'FontSize', 12)
% yyaxis right
% semilogx(original.freq, rad2deg(atan(imag(original.Hf(1:find(original.freq == 20000)))./real(original.Hf(1:find(original.freq == 20000))))))
% ylabel('Fase [\circ]', 'FontSize', 12)
% xlim([1 20000])
% 
% % yyaxis left
% % semilogx(tweeter.freq(1:find(tweeter.freq == 20000)), (3.2/abs(tweeter.Hf(find(tweeter.freq == 2)))).*abs(tweeter.Hf(1:find(tweeter.freq == 20000)))); grid on; hold on
% % ylabel('Curva de Impedância [\Omega]', 'FontSize', 12)
% % yyaxis right
% % semilogx(tweeter.freq(1:find(tweeter.freq == 20000)), rad2deg(atan(imag(tweeter.Hf(1:find(tweeter.freq == 20000)))./real(tweeter.Hf(1:find(tweeter.freq == 20000))))))
% % ylabel('Fase [\circ]', 'FontSize', 12)
% % xlim([1 20000])
% 
% % Plot
% % calib2 = re/(abs(metodo_massa.Hf(find(metodo_massa.freq ==2))));
% % semilogx(metodo_massa.freq, abs(calib2.*metodo_massa.Hf));
% % xlim([1 20000])