clear all; close all; clc
%% Butterworth original
R = 4;
Q = .707;
fc = 2000;
L = R/(2*pi*fc*Q);
C = Q/(2*pi*fc*R);
f = 20:20000;
s = j.*(2*pi*f);
w = 2*pi*f;

high_pass = L*C*s.^2 ./ (1 + L*s/R + L*C*s.^2);
low_pass = 1 ./ (1 + L*s/R + L*C*s.^2);

%overall frequency response
overall_real = real(low_pass) + real(high_pass);
overall_imag = imag(low_pass) - imag(high_pass);
overall = overall_real + 1i.*overall_imag;

figure('Name', 'Curva Butterworth original')
semilogx(f, 20*log10(abs(low_pass))); grid on; hold on;
semilogx(f, 20*log10(abs(high_pass)));
semilogx(f, 20*log10(abs(overall)));
xlabel('Frequência [Hz]'), ylabel('Magnitude [dB ref. 1]'); title('Resposta de um filtro butterworth')
legend('LPF', 'HPF', 'Resposta conjunta', 'Location', 'southwest')
xlim([20 20000]), ylim([-10 5]);
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'});
% print(gcf, '-dpng', '-r300', 'butterworth_normal.png')

%% Plot com butterworth ajustado

R = 4;
Q = .707;

% HPF
fc_1 = 2000*1.3;
L1 = R/(2*pi*fc_1*Q);
C1 = Q/(2*pi*fc_1*R);

% LPF
fc_2 = 2000/1.3;
L2 = R/(2*pi*fc_2*Q);
C2 = Q/(2*pi*fc_2*R);

f = 20:20000;
s = j.*(2*pi*f);

high_pass = L1*C1*s.^2 ./ (1 + L1*s/R + L1*C1*s.^2);
low_pass = 1 ./ (1 + L2*s/R + L2*C2*s.^2);

%overall frequency response
overall_real = real(low_pass) + real(high_pass);
overall_imag = imag(low_pass) - imag(high_pass);
overall = overall_real + 1i.*overall_imag;

figure('Name', 'Curva Butterworth ajustada')
semilogx(f, 20*log10(abs(low_pass))); grid on; hold on;
semilogx(f, 20*log10(abs(high_pass)));
semilogx(f, 20*log10(abs(overall)));
xlabel('Frequência [Hz]'), ylabel('Magnitude [dB ref. 1]'); title('Resposta de um filtro butterworth')
legend('LPF', 'HPF', 'Resposta conjunta', 'Location', 'southwest')
xlim([20 20000]), ylim([-10 5]);
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'});
% print(gcf, '-dpng', '-r300', 'butterworth_ajustado.png')

%%

R = 4.53;
C = 22e-6;
L = .25e-3;
teste = R./(-w.^2*R*L*C+j*w*L+R);

figure('Name', 'Curva Butterworth original')
semilogx(f, 20*log10(abs(teste))); grid on; hold on;
xlabel('Frequência [Hz]'), ylabel('Magnitude [dB ref. 1]'); title('Resposta de um filtro butterworth')
xlim([20 20000]), ylim([-10 5]);
xticks([20 100 1000 10000]); xticklabels({'20', '100', '1000', '10000'});