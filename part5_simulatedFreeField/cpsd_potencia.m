sens_voltage = 10;
Nfft = 51200;
Fs = 51200;

voltage = sens_voltage .* Recording(:, 2);
current = sens_voltage .* Recording(:, 3);

a = 2;
b = 1;
%[Pxy,F] = cpsd(X,Y,WINDOW,NOVERLAP,NFFT,Fs) %cross epectrum
%[Hf, freqh] = tfestimate(x, y, hanning(NFFT), NFFT/a, b*NFFT,Fs);%'twosided');

[w_f, f] = cpsd(voltage, current, hanning(Nfft), Nfft/a, b*Nfft, Fs);

w_rms = rms(voltage .* current);
disp(w_rms)

% figure('Name', 'Tensão no tempo')
% plot(t, voltage)
% xlabel('Tempo [s]'); ylabel('Tensão [V]'); title('Tensão de saída do amplificador');
% print(gcf, '-dpng', '-r600', 'tensaoSaida_amp.png')
% 
% figure('Name', 'Corrente no tempo')
% plot(t, current)
% xlabel('Tempo [s]'); ylabel('Corrente [V]'); title('Corrente de saída do amplificador');
% print(gcf, '-dpng', '-r600', 'correnteSaida_amp.png')

figure('Name', 'Potência na frequência')
semilogx(f, abs(w_f)); grid; hold on;
xlabel('Frequência [Hz]'); ylabel('Potência [W (?)]'); title('Potência de saída do amplificador')
xlim([20 20000])
% print(gcf, '-dpng', '-r600', 'potenciaSaida_amp.png')
