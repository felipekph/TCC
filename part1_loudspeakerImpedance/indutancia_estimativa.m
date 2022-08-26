clear all; clc; close all
%% Load e clear

% Falante sem adição de massa e para a medição com o ruído branco
load('falante_original\ruido_branco\Hf.mat')
load('falante_original\ruido_branco\coe.mat')

original.Hf = Hf;
original.freq = freqh;
original.coe = coe;

%% 

re = 6.3; % Resistência DC medida no terminal do alto-falante, Re [Ω]

% Valor de correção para a curva. Este é a razão entre o valor medido de
% resistência no terminal do alto-falante sobre o que é medido pela NI,
% porém, neste caso é usado para a NI o valor de resistência em 2 Hz.
calib = re/(abs(original.Hf(find(original.freq == 2)))); % Valor medido no terminal sobre o valor obtido em 2 Hz

% Correção nos valores de original.Hf, assim, obtem-se a impedância de fato
% Para os vetores de impedância e frequência, usou-se então os valores de 1
% Hz até 20 kHz apenas.
impedance = calib.*original.Hf(1:find(original.freq == 20000)); % Correção para obtenção da impedância
original.freq = original.freq(1:find(original.freq == 20000));

%% Estimativa da indutância da bobina do alto-falante a partir de 250 Hz

hf_sliced = impedance(find(original.freq == 250):end);
freq_sliced = original.freq(find(original.freq == 250):end);

Le_f = abs(sqrt(abs(hf_sliced).^2 - re^2)) ./ (2*pi.*freq_sliced);

disp('----------------------------------------')
disp('ESTIMATIVA INDUTÂNCIA PELA CURVA ORIGINAL')
disp('----------------------------------------')
text = sprintf(['Le (1 kHz) = %.2f [mH];\n' ...
    'Le (5 kHz) = %.2f [mH];\nLe (10 kHz) = %.2f [mH];\nLe (20 kHz) = %.2f [mH]'], ...
    10^3*Le_f(find(freq_sliced == 1000)), 10^3*Le_f(find(freq_sliced == 5000)), ...
    10^3*Le_f(find(freq_sliced == 10000)), 10^3*Le_f(find(freq_sliced == 20000)));
disp(text)


% figure('Name', 'Indutância da bobina a partir de 250 Hz')
% semilogx(freq_sliced, 10^3.*Le_f); grid on;
% xlabel('Frequência [Hz]', 'FontSize', 12); 
% ylabel('Indutância da bobina [mH]', 'FontSize', 12);
% title('Indutância da bobina a partir de 250 Hz', 'FontSize', 12);