%% ITA loading

load('matlab.mat')

ir = output.freqData ./ input.freqData;
ir = itaAudio(ir, 51200, 'freq');
% ir_smooth = ita_smooth(ir,'LogFreqOctave1',1,'Abs');

V_rms_amp = rms(Recording(:, 2)); 

%% post-processing

M_dB = 20 .* log10(abs(ir.freqData)./(max(abs(ir.freqData))));

M = 10.^(M_dB./20);

SPL = 20 .* log10((M .* V_rms_amp) ./ (2e-5));
% SPL = 20 .* log10((M .* V_rms_amp) ./ (sqrt(2) * 2e-5));

H_teste = 20 .* log10((abs(ir.freqData) .* V_rms_amp) ./ (2e-5));

% figure('Name', 'SPL x Freq')
semilogx(ir.freqVector, SPL); grid; hold on;
semilogx(ir.freqVector, H_teste)
% semilogx(ir_smooth.freqVector, SPL_smooth, 'LineWidth', 2); grid; hold on;
xlabel('Frequência [Hz]'); ylabel('Nível de Pressão Sonora [dB ref. 20\mu{Pa}]');
xlim([20 20000]); title('NPS comparativo da medição com microfone no eixo do Tweeter');
label = {'10', '100', '1k', '5k', '10k', '20k'}; xticklabels(label);
% legend('ITA (ajustado)', 'VLSM', 'Location', 'southeast')
% legend('SPL', 'SPL com smooth', 'Location', 'southeast')
% print(gcf, '-dpng', '-r600', 'NPS_eixoCentroGeo.png')
% print(gcf, '-dpng', '-r600', 'NPS_VLSMxITA_eixoWoofer.png')