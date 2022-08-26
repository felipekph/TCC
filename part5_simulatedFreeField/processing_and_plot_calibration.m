%% Carregamento de arquivos
% 
load("Dados\17_fevereiro\camara_reverberante\calibracao\inicio\calibrador.mat");
load("Dados\microfone\mic4942.mat");
addpath("codigos_auxiliares\");

%% 

audiowrite("Dados\17_fevereiro\camara_reverberante\calibracao\inicio\calibrador.wav", Recording(:, 1), Fs);

%% Processamento

weighting = 'flat'; % 'A'; 'C', 'flat
bandtype = 'third'; % oct, third
filename = 'Dados\17_fevereiro\camara_reverberante\calibracao\inicio\calibrador.wav';
Transdutor = 'mic'; % mic, acc - microfone ou acelerômetro
Ref = 2e-5; % Pa
dt = 1; % FAST(0.125 s) ou SLOW(1 s)
% %% correcao do mic 4189-A21 free field para difuso (salas)
% random = load('C:\Users\user\Desktop\mic2689639_random_ok.mat');
fxx = linspace(0, Fs/2, Fs/2+1);
ajuste = 1; % 0 ou 1
corr_random = pchip([0;mic4942(:, 1);30000],[0;mic4942(:, 2);-15],fxx);
% %%
[f_terco, Pxxb_mic, fxx, Pxx_mic] = Level_vslm2(sens, weighting, bandtype, filename, Fs, Ref, Fs, Transdutor, dt);
% 
%nivel em banda estreita
Lp_est = ajuste .* corr_random+10*log10(Pxx_mic./(Ref.^2));

%% Plot

% Plot
figure('Name', 'Sinal de tensão')
plot(t, Recording)
title('Sinal de tensão do microfone (calibração - início)');
xlabel('Tempo [s]'); ylabel('Tensão [V]');
text = sprintf('Sensibilidade %.4f [V/Pa]', sens);
legend(text, 'Location', 'northeast')
print(gcf, '-dpng', '-r300', 'Figuras\calibracao_inicioCamara_tensão.png')

figure('Name', 'Sinal no domínio da frequência')
semilogx(fxx, Lp_est)
xlabel('Frequência [Hz]')
ylabel('NPS [dB ref. 20\muPa]'); grid; hold on
ylim([min(Lp_est)-5 max(Lp_est)+5])
legend('Calibração em 1 kHz', 'Location', 'southwest')
xlim([20 20000])
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'})
yticks([0 20 40 60 80 100]); ylim([0 100])
yticklabels({'0', '20', '40', '60', '80', '100'})
title(sprintf('Calibração no início das medições'))
print(gcf, '-dpng', '-r300', 'Figuras\calibracao_inicioCamara_frequencia.png')

%% Plot mic correction facton (with and without interpolation)

figure('Name', 'Correção mic (sem interp)')
semilogx(mic4942(:, 1), mic4942(:, 2)); grid on;
title('Correção do Microfone B&K Type 4189')
xlabel('Frequência [Hz]'); ylabel('Magnitude [dB]')
xlim([1 20000])
xticks([1 10 20 100 1000 10000]); xticklabels({'1', '10', '20', '100', '1000', '10000'})
% print(gcf, '-dpng', '-r300', 'Figuras\correcao_mic4942_FreeField.png')

figure('Name', 'Correção mic (com e sem interp)')
semilogx(mic4942(:, 1), mic4942(:, 2)); hold on; grid on;
semilogx(fxx, corr_random);
title('Correção do Microfone B&K Type 4189 (sem e com interpolação)')
xlabel('Frequência [Hz]'); ylabel('Magnitude [dB]')
xlim([1 20000])
xticks([1 10 20 100 1000 10000]); xticklabels({'1', '10', '20', '100', '1000', '10000'})
legend('Correção sem interpolação', 'Correção com interpolação', 'Location', 'southeast')
% print(gcf, '-dpng', '-r300', 'Figuras\correcao_mic4942_comparativo.png')