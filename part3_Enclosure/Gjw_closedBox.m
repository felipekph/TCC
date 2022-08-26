%% resposta

fc = 81.7;
Tc = 1/(2*pi*fc);
wc = 2*pi*fc;
Qtc = [1.176, 1.5659];
f = 20:20000;
w = 2*pi*f;

for i=1:length(Qtc)

	Gjw = (1i.*w).^2 .* Tc^2 ./ ((1i.*w).^2 * Tc^2 + (1i*w*Tc)./Qtc(i) + 1);
    text = sprintf("Q_{tc} = %.2f ", Qtc(i)); text =  strrep(text, '.',',');
	semilogx(w/wc, 20*log10(abs(Gjw)), 'DisplayName', text, 'LineWidth', 1.5); grid on; hold on;
	xlim([0.3 10]), xticks([.3 .5 .7 1 1.4 2 4 8])
    xticklabels({'0,3', '0,5', '0,7', '1,0', '1,4', '2,0', '4,0', '8,0'});
	ylim([-12 9]), yticks([-12 -9 -6 -3 0 3 6 9]),
    yticklabels({'-12', '-9', '-6', '-3', '0', '3', '6', '9'});
    text = sprintf('Q_{tc}: %.4f', Qtc(i));
    title('Resposta em frequência para diversos valores de Q_{tc}')
    xlabel('w/w_c [-]'), ylabel('Magnitude normalizada [dB]')
    legend show
    legend('Location', 'southeast')
end

print(gcf, '-dpng', '-r300', 'Figuras\resposta_measuredQtc.png')

%% deslocamento

fc = 81;
Tc = 1/(2*pi*fc);
Qtc = [.5 .7 1 1.4 2];

for i=1:length(Qtc)

	Xjw = 1 ./ ((1i.*w).^2 * Tc^2 + (1i*w*Tc)./Qtc(i) + 1);
    text = sprintf("Q_{tc} = %.2f ", Qtc(i)); text =  strrep(text, '.',',');
	semilogx(w/wc, 20*log10(abs(Gjw)), 'DisplayName', text, 'LineWidth', 1.5); grid on; hold on;
	xlim([0.3 3]), xticks([.3 .5 .7 1 1.4 2])
    xticklabels({'0,3', '0,5', '0,7', '1,0', '1,4', '2,0'});
	ylim([-12 9]), yticks([-12 -9 -6 -3 0 3 6 9]),
    yticklabels({'-12', '-9', '-6', '-3', '0', '3', '6', '9'});
    text = sprintf('Q_{tc}: %.2f', Qtc(i));
    title('Resposta em frequência para diversos valores de Q_{tc}')
    xlabel('w/w_c [-]'), ylabel('Magnitude normalizada [dB]')
    legend show
    legend('Location', 'southeast')
end

%% plot qtc teorico e medido

fc = 81.7;
Tc = 1/(2*pi*fc);
wc = 2*pi*fc;
Qtc = [1.176, 1.5659];
f = 20:20000;
w = 2*pi*f;

for i=1:length(Qtc)

	Gjw = (1i.*w).^2 .* Tc^2 ./ ((1i.*w).^2 * Tc^2 + (1i*w*Tc)./Qtc(i) + 1);
	semilogx(w/wc, 20*log10(abs(Gjw)), 'DisplayName', text, 'LineWidth', 1.5); grid on; hold on;
	xlim([0.3 10]), xticks([.3 .5 .7 1 1.4 2 4 8])
    xticklabels({'0,3', '0,5', '0,7', '1,0', '1,4', '2,0', '4,0', '8,0'});
	ylim([-12 9]), yticks([-12 -9 -6 -3 0 3 6 9]),
    yticklabels({'-12', '-9', '-6', '-3', '0', '3', '6', '9'});
    if i==1
        text = sprintf('Q_{tc} simulado: %.4f', Qtc(i));
        text = strrep(text, '.',',');
    end
    if i==2
        text2 = sprintf('Q_{tc} medido: %.4f', Qtc(i));
        text2 = strrep(text2, '.',',');
        legend(text, text2, 'Location', 'southeast')
    end
    title({'Resposta em frequência para os valores de Q_{tc} medido e simulado'})
    xlabel('w/w_c [-]'), ylabel('Magnitude normalizada [dB]')
end
print(gcf, '-dpng', '-r300', 'Figuras\resposta_measuredQtc.png')