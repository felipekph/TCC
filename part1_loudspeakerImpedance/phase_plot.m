%% rodar até hf no data_read e aí rodar aqui
%% plot

Hf = Hf_tweeter;

for i=1:size(Hf, 2)

    legend_text = sprintf('Medição %d', i);
    hf_fix = 3.2./abs(Hf(find(freq==2), i)) .* Hf(:, i);
    semilogx(freq, atan2d(imag(hf_fix), real(hf_fix)), '--', 'DisplayName', legend_text); hold on;
    xlabel('Frequência [Hz]', 'FontSize', 12); 
    ylabel('Fase [deg]', 'FontSize', 12);
%     title('Fase - Tweeter Audiophonic KC Club 6.3 (30 medições)');
    title('Fase - Woofer Audiophonic KC Club 6.3 (30 medições)');
    legend show
    legend('Location', 'southoutside', 'NumColumns', 6, 'FontSize', 14)
    freq_ticks = [20 100 10000]; 
    xticks(freq_ticks);
    xlim([20 20000]); ylim([-90 90])
    set(gca,'XTickLabel',string(freq_ticks),'fontsize',18)
    yticks([-90 -45 0 45 90]); yticklabels({'-90', '-45', '0', '45', '90'});
    set(gcf,'units','normalized','outerposition',[0.1 0.1 0.6 0.8])
    grid on

end

print(gcf, '-dpng', '-r300', '..\Figuras\fase_tweeter_ruido_branco.png')
% print(gcf, '-dpng', '-r600', '..\Figuras\fase_woofer_ruido_branco.png')


