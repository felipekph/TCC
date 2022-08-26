%% Carregamento de arquivos



%% Processamento

weighting = 'flat'; % 'A'; 'C', 'flat
bandtype = 'third'; % oct, third
filename = 'woofer_semProtetor.wav';
Transdutor = 'mic'; % mic, acc - microfone ou acelerômetro
Ref = 2e-5; % Pa
dt = 1; % FAST(0.125 s) ou SLOW(1 s)
% %% correcao do mic 4189-A21 free field para difuso (salas)
% random = load('C:\Users\user\Desktop\mic2689639_random_ok.mat');
fxx = linspace(0, Fs/2, Nfft/2+1);
ajuste = 1; % 0 ou 1
corr_random = pchip([0;mic4189(:, 1);30000],[0;mic4189(:, 2);-15],fxx);
% %%
[f_terco, Pxxb_mic, fxx, Pxx_mic] = Level_vslm2(sens, weighting, bandtype, filename, Fs, Ref, Nfft, Transdutor, dt);
% 
%nivel em banda estreita
Lp_est = ajuste .* corr_random+10*log10(Pxx_mic./(Ref.^2));

%% Plot

% figure()
semilogx(fxx, Lp_est)
xlabel('Frequência [Hz]')
ylabel('NPS [dB ref. 20\muPa]'); grid; hold on
ylim([min(Lp_est)-5 max(Lp_est)+5])
legend('Campo Livre - Eixo Woofer (sem protetor)', 'Location', 'southwest')
xlim([20 20000])
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'})
yticks([0 20 40 60 80 100]); ylim([0 100])
yticklabels({'0', '20', '40', '60', '80', '100'})
title(sprintf('Medição de campo livre no eixo do woofer'))
% print(gcf, '-dpng', '-r600', 'Figuras\NPS_eixoWoofer_comProtetor.png')