% MEDICAO DE NPS (Leq) com placa NATIONAL - Prof. Paulo Mareze (Abril/2021)
clear all; format long; clc; close all; %#ok<CLALL>

addpath("codigos_auxiliares\")

analisador = 'National';%  
%%
med = 'sensiblidade'; % número da medição, apenas para salvar dados
tipo = 'teste'; % informações do local a ser medido
namefile = ['NPS_', med, '_', tipo, '_', analisador, '.mat'];
%%
d = daq.getDevices;
s = daq.createSession('ni');
Fs = 51200; % Freq de amostragem
s.Rate = Fs;
deltaf = 1; % resolucao do eixo de frequencias, em Hz (deta f)
Nfft = (1/deltaf)*Fs; % numero de pontos da FFT
trec = 20; % tempo de medicao em segundos
s.DurationInSeconds = trec;

% [ch,idx] = addAnalogInputChannel(s,'cDAQ1Mod1',0,'IEPE'); % canal 0, até 3
[ch, idx] = addAnalogInputChannel(s, 'cDAQ1Mod1',  'ai0',  'Microphone');
[ch, idx] = addAnalogInputChannel(s, 'cDAQ1Mod1', 'ai1', 'voltage');
[ch, idx] = addAnalogOutputChannel(s, 'cDAQ1Mod3', 'ao1', 'voltage'); % ao0 - analog output canal 0

sens1 = 0.0455; %sensibilidade em V/ Pa - mic
s.Channels(1).Sensitivity = sens1; 
% s.Channels(1).MaxSoundPressureLevel = 125; %dB
% s.Channels.ExcitationCurrent = 0.004; % Fonte de corrente de 4mA
% d.Subsystems.ChannelNames
%%

ruido = 1; %aleat-1; sweep-2; 

for nn = 1:1%numero de medias

    %% SOUND CAPTURE
    disp('Two seconds to start of recording')
    pause(2)
    disp('Started!')

%% Geração de um ruído rosa/branco:
    Ts = trec + 0.5; % %Tempo de geração do som;
    
    if ruido==1 

        ts = 0:1/Fs:Ts-1/Fs;
        rNoise = dsp.ColoredNoise('Color', 'white', 'SamplesPerFrame', Ts*Fs, 'NumChannels', 1); %white, blue, brown
        xs = rNoise(); clear pinkNoise;
        xs = xs./(max(xs)); 
        queueOutputData(s, xs); [Recording, t] = s.startForeground; %para gerar o ruído atraves da plana NI (tempo medicao=tempo de geracao)
%         sound(xs,Fs);  [Recording, t] = s.startForeground;
        clear sound

    end

%% s-Sound
    if ruido==2 
        f1 = 20; f2 = Fs/1.5; % 
%         f1 = 5000; f2 = 5000.001; % 
%         f1 = 60; f2 = 60.001; % 
%         f1 = 40; f2 = 5000; % 
%          f1 = 250; f2 = 250.001; % 
        
        [sweepf, ~, ~] = sweepsine(Ts, f1, f2, Fs);
        sweepf = sweepf .* 0.89; % para não clipar
        queueOutputData(s, sweepf); [Recording, t] = s.startForeground;

%         sweep_excitacao = ita_generate_sweep('fftDegree', Fs*trec, 'mode', 'exp', ...
%                             'samplingRate', Fs, 'stopMargin', 0.1, 'freqRange', [1 20000]);
%         queueOutputData(s, sweep_excitacao.timeData); [Recording, t] = s.startForeground; %para gerar o ruído atraves da plana NI (tempo medicao=tempo de geracao)
%         clear sound;

    end
    %%
    disp('End');
    
    % Recording(:,1) = sinal do canal 1, em Pascal (com sensibilidade aplicada)
    audiowrite('input1.wav', sens1 .* Recording(:,1), Fs); % canal 1 - grava o sinal de tensão, em V
    
    figure('Name', 'Sinal de Tensão')
    plot(t, Recording(:,1), 'r'); grid on; %hold on;
    xlabel('Tempo [s]'); ylabel('Amplitude [V]')
    legend('input 1')
    
%     clear Recording
end

%% ponderação Z
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

%nivel em terco de oitava
corr_random_t = pchip([0; mic4189(:,1); 30000],[0; mic4189(:,2); -15],f_terco);
Lp_terc = ajuste .* corr_random_t + 10.*log10(Pxxb_mic ./ ((2e-5).^2));
figure()
bar(1:length(f_terco), Lp_terc);
ylabel('NPS [dB] - ref.: 20\muPa');
title(sprintf('Nível de Pressão Sonora Equivalente em (%s) usando ANSI', weighting'))
fctxt = {'16','32','63','125','250','500','1k','2k','4k','8k','16k'};
fcb0 = 1000 * 2.^((-19:1:13)/3);
tickmarks = 2:3:length(fcb0);
set(gca,'xtick',tickmarks,'xticklabel',fctxt);
axis tight
xlabel('Frequência [Hz]')
grid
ylim([min(Lp_terc)-5  max(Lp_terc)+5])
legend('mic. 1 - ponderação Z')

%% ponderação A
weighting = 'A'; % 'A'; 'C', 'flat
bandtype = 'third'; % oct, third
filename = 'input1.wav';
Transdutor = 'mic'; % mic, acc - microfone ou acelerômetro
Ref = 2e-5;% Pa
dt = 1;% FAST(0.125 s) ou SLOW(1 s)
[~, Pxxb_mic_A, ~, Pxx_mic_A] = Level_vslm2(sens1, weighting, bandtype, filename, Fs, Ref, Nfft, Transdutor,dt);

%nivel em banda estreita
Lp_est_A = ajuste .* corr_random + 10*log10(Pxx_mic_A ./ (Ref.^2));
% % figure()
% % semilogx(fxx, Lp_est_A)
% % xlabel('Frequência [Hz]')
% % ylabel('NPS [dB] - ref.: 20\muPa');
% % grid
% % ylim([min(Lp_est_A)-5 max(Lp_est_A)+5])
% % title(sprintf('Nível de Pressão Sonora Equivalente em (%s): banda estreita usando FFT',weighting'))
% % legend('mic. 1 - ponderação A')


%nivel em terco de oitava
Lp_terc_A = ajuste .* corr_random_t + 10.*log10(Pxxb_mic_A ./ ((2e-5).^2));
% % figure()
% % bar(1:length(f_terco), Lp_terc_A);
% % ylabel('NPS [dB] - ref.: 20\muPa');
% % title(sprintf('Nível de Pressão Sonora Equivalente em (%s) usando ANSI',weighting'))
% % fctxt={'16', '32', '63', '125', '250', '500', '1k', '2k', '4k', '8k', '16k'};
% % fcb0 = 1000 * 2.^((-19:1:13)/3);
% % tickmarks = 2:3:length(fcb0);
% % set(gca, 'xtick', tickmarks, 'xticklabel', fctxt);
% % axis tight
% % xlabel('Frequência [Hz]')
% % grid
% % ylim([min(Lp_terc)-5 max(Lp_terc)+5])
% % legend('mic. 1 - ponderação A')
%% Curvas NC
N = 1; % 1/oitava 

[Lp_oit, f_oit] = NarrowToNthOctave(f_terco, Lp_terc,N);

%%
% % figure()
% % semilogx(f_oit,Lp_oit,'k')
% % fctxt={'16','31,5','63','125','250','500','1k','2k','4k','8k','16k'};
% % set(gca,'xtick',f_oit,'xticklabel',fctxt);
% % axis tight 
% % ylim([-10 90])
% % grid on
% % xlabel('Frequência [Hz]')
% % ylabel('NPS [dB]')
% % legend('mic. 1')
freqc = [63 125 250 500 1000 2000 4000 8000];
Graf = Lp_oit(3:10);
Curvas_NC_NBR(freqc, Graf)

%% SALVA DADOS
% numero_medicao = med;
% dados.sensibilidade = sens1;
% dados.freq_amostragem = Fs;
% dados.tempo_medicao = trec;
% dados.num_pontos_fft = Nfft;
% 
% niveis_sonoros.oitava.Z = Lp_oit;
% niveis_sonoros.terco.Z = Lp_terc;
% niveis_sonoros.estreita.Z = Lp_est;
% niveis_sonoros.terco.A = Lp_terc_A;
% niveis_sonoros.estreita.A = Lp_est_A;
% 
% frequencias.oitava = f_oit;
% frequencias.terco = f_terco;
% frequencias.estreita = fxx;
% 
% autoespectros.terco.ponderacao_Z = Pxxb_mic;
% autoespectros.terco.ponderacao_A = Pxxb_mic_A;
% autoespectros.estreita.ponderacao_Z = Pxx_mic;
% autoespectros.estreita.ponderacao_A = Pxx_mic_A;
% 
% correcao_random_mic2689639.carta = random;
% correcao_random_mic2689639.estreita = corr_random;
% correcao_random_mic2689639.terco = corr_random_t;
% 
% save(namefile, 'numero_medicao', 'dados', 'frequencias', 'niveis_sonoros', ...
%      'autoespectros');%,'correcao_random_mic2689639');