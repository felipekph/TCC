%% Variação de Fs para cada par de medição
clear all; clc; close all;

%% load and add path
load("Hf_semMassa.mat"); load("Hf_comMassa.mat");
load("atm_data.mat"); load("deltaMass_data.mat");
addpath('Matlab_UFSM_Mareze_2'); addpath('codigos_auxiliares');

%% Dados atmosféricos

for par = 1:30

    %% Condições atmosféricas
    
    % Temperatura média do par de medição
    atm.Temp_med = mean([atm.Temp(par) atm.Temp(par+30)]);
    
    % Humidade relativa do par de medição
    atm.Hum_med = mean([atm.Hum(par) atm.Hum(par+30)]);
    
    [c0, rho0] = ita_constants({'c', 'rho_0'}, 'T', Temp_med, 'phi', Hum_med, 'p', atm.Pa);

    %% Fs

    [fs(par, 1), ~] = find_fs(Hf_semMassa(:, par), freq); % Ressonância sem adição de massa
    [fs(par, 2), ~] = find_fs(Hf_comMassa(:, par), freq); % Ressonância com adição de massa
    fs(par, 3) = Temp_med; % Temperatura média do par de medição
    fs(par, 4) = Hum_med; % Humidade relativa média do par de medição
    fs(par, 5) = delta_mass(par); % Massa aplicada sobre o cone

%     text = sprintf(['%.2f; %.2f; %.2f; %.2f; %.3f'], fs(par, 1), ...
%         fs(par, 2), fs(par, 3), fs(par, 4), fs(par, 5));
% 
%     disp(text);
% 
%     text2 = sprintf(['Par %.0f'], par);
% 
%     disp(text2);
end




