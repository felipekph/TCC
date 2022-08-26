clear all; clc; close all;

%% load and add path
addpath('Matlab_UFSM_Mareze_2'); addpath('codigos_auxiliares');
addpath('processed_data');
load("Hf_semMassa.mat"); load("Hf_comMassa.mat");
load("CI_woofer_IC_95.mat"); load("CI_woofer_mass_IC_95.mat");
load("atm_data.mat"); load("deltaMass_data.mat");

%% Condições atmosféricas

for par = 1:30
    
    if par == 31

        Hf_semMassa(:, 31) = CI_woofer_med;
        Hf_comMassa(:, 31) = CI_woofer_med_mass;
        atm.Temp_med = mean(atm.Temp);
        atm.Hum_med = mean(atm.Hum);
        delta_mass(:, 31) = mean(delta_mass);

    else

    % Temperatura média do par de medição
    atm.Temp_med = mean([atm.Temp(par) atm.Temp(par+30)]);
    
    % Humidade relativa do par de medição
    atm.Hum_med = mean([atm.Hum(par) atm.Hum(par+30)]);

    end
    
    [atm.c0, atm.rho0] = ita_constants({'c', 'rho_0'}, 'T', atm.Temp_med, 'phi', atm.Hum_med, 'p', atm.Pa);
    
    %% Fs
    [param.fs, idx_fs] = find_fs(Hf_semMassa(:, par), freq, 2); % Posição da frequência de ressonância
    
    %% Impedância nominal, re, r0 e f1 e f2
    
    param.rs = abs(Hf_semMassa(idx_fs, par)); % Impedância da bobina na freq. de ressonância [Ω]
    param.re = 3.2; % Impedância medida no terminal do alto-falante corrigida (sem influência dos cabos)
    param.rn = min(abs(Hf_semMassa(idx_fs:end, par))); % Valor mínimo de resistência após a freq. de ressonância [Ω]
    
    if param.rn > 4 & param.rn < 8
       param.rn = 8; 
    else
       param.rn = 4;
    end
    
    param.r0 = sqrt(param.re * param.rs); % Valor de resistência para encontrar as frequências F1 e F2;
    
    param.f1 = interp1(abs(Hf_semMassa(1:idx_fs, par)), freq(find(1):idx_fs), param.r0); % F1 pelo método geométrico
    param.f2 = interp1(abs(Hf_semMassa(idx_fs:find(freq==300), par)), freq(idx_fs:find(freq==300)), param.r0); % F2 pelo método geométrico

%     param.Zmin = min(Hf_semMassa(idx_fs:10001, par)) % o que o clio
%     calcula na real?
    
    %% Área efetiva do alto-falante
    
    param.Sd = pi/4 * (0.132)^2; % [m^2]
    
    %% Massa móvel do cone (Mms) e compliância mecânica da suspensão do driver (Cms) 
    
    param.delta_mass = delta_mass(par) * 10^-3;
    
    [param.fs2, idx_fs2] = find_fs(Hf_comMassa(:, par), freq, 2);
    
    param.Mms = (param.delta_mass * (2*pi*param.fs2)^2) / ((2*pi*param.fs)^2 - (2*pi*param.fs2)^2); % [kg]
    
    param.Cms = ((2*pi*param.fs)^2 - (2*pi*param.fs2)^2) / (param.delta_mass * (2*pi*param.fs2)^2 * (2*pi*param.fs)^2); % [m/N]
    
    %% Fatores de qualidade e amortecimento da suspensão
    
    % Fator de qualidade mecânica Qms
    param.Qms = (param.fs * sqrt(param.rs/param.re)) / (param.f2 - param.f1);
    
    % Fator de qualidade elétrica Qes
    param.Qes = param.Qms / ((param.rs/param.re) - 1);
    
    % Fator de qualidade total Qts
    param.Qts = (param.Qms * param.Qes) / (param.Qms + param.Qes);
    
    % Amortecimento da suspensão
    param.Rms = (2*pi*param.fs*param.Mms) / param.Qms; % [kg/s]
    
    % Volume de ar com rigidez equivalente à rigidez da suspensão do driver
    param.Vas = atm.rho0 * atm.c0^2 * param.Sd^2 * param.Cms; % [m^3]
    param.Vas = param.Vas.value;
    
    % Fator de força magnética
    param.Bl = sqrt((2*pi*param.fs*param.Mms*param.re) / param.Qes);
    
    % Eficiência acústica do sistema
    param.n0 = 100 * (4*pi^2 / atm.c0^3) * (param.fs^3*param.Vas / param.Qes);
    param.n0 = param.n0.value;

    % Indutância em 1kHz, 10kHz e 20kHz
    [param.L_1kHz, param.L_10kHz, param.L_20kHz] = L_estimate(Hf_semMassa(:, par), freq, param.re);

    % Convertendo unidades

    param.delta_mass = param.delta_mass * 1000; % kg to g
    param.Mms = param.Mms * 1000; % kg to g
    param.Cms = param.Cms * 10^3; % m to um
    param.Sd = param.Sd * 10000; % m to cm
    param.Vas = param.Vas * 1000; % m^3 to L

    disp('----------------------------------------')
    text = sprintf(['METODO DA MASSA | PAR %i'], par);
    disp(text);
    disp('----------------------------------------')
    text = sprintf(['DeltaMass = %.3f [g];\nFs = %.2f [Hz];\nMms = %.2f [g];\n' ...
        'Cms = %.2f [mm/N];\nRms = %.2f [kg/s];\nQms = %.2f [-];\nQes = %.2f [-];\n' ...
        'Qts = %.2f [-];\nSd = %.2f [cm^2];\nVas = %.2f [L];\nn0 = %.4f [%%];\n' ...
        'Bl = %.2f [Tm].'], param.delta_mass, param.fs, param.Mms, ...
        param.Cms, param.Rms, param.Qms, param.Qes, param.Qts, param.Sd, param.Vas, param.n0, param.Bl);
    disp(text);
    text = sprintf(['L @ 1kHz = %.2f [mH];\nL @ 10kHz = %.2f [mH];' ...
        '\nL @ 20kHz = %.2f [mH].'], param.L_1kHz, param.L_10kHz, param.L_20kHz);
    disp(text)

    parameters(:, par) = [param];


end

%     disp('----------------------------------------')
%     text = sprintf(['METODO DA MASSA | ABORDAGEM III'], par);
%     disp(text);
%     disp('----------------------------------------')
%     text = sprintf(['DeltaMass = %.3f [g];\nFs = %.2f [Hz];\nMms = %.2f [g];\n' ...
%         'Cms = %.2f [mm/N];\nRms = %.2f [kg/s];\nQms = %.2f [-];\nQes = %.2f [-];\n' ...
%         'Qts = %.2f [-];\nSd = %.2f [cm^2];\nVas = %.2f [L];\nn0 = %.4f [%%];\n' ...
%         'Bl = %.2f [Tm].'], mean([parameters.delta_mass]), mean([parameters.fs]), mean([parameters.Mms]), ...
%         mean([parameters.Cms]), mean([parameters.Rms]), mean([parameters.Qms]), mean([parameters.Qes]), ...
%         mean([parameters.Qts]), mean([parameters.Sd]), mean([parameters.Vas]), mean([parameters.n0]), mean([parameters.Bl]));
%     disp(text);
%     text = sprintf(['L @ 1kHz = %.2f [mH];\nL @ 10kHz = %.2f [mH];' ...
%         '\nL @ 20kHz = %.2f [mH].'], mean([parameters.L_1kHz]), mean([parameters.L_10kHz]), mean([parameters.L_20kHz]));
%     disp(text)

%% ABORDAGEM II (curvas mais próximas da média)

% sum_errorNoMass = zeros(1, 30);
% sum_errorMass = zeros(1, 30);
% 
% for i = 1:length(sum_errorNoMass)
% 
%     sum_errorNoMass(1, i) = sum(abs(CI_woofer_med(:) - Hf_semMassa(:, i)))
%     sum_errorMass(1, i) = sum(abs(CI_woofer_med_mass(:) - Hf_comMassa(:, i)))
% 
%     idx = find(sum_errorNoMass == min(sum_errorNoMass))
%     idx = find(sum_errorMass == min(sum_errorMass))
% end

