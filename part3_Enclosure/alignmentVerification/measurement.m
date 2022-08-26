clear all; format long; clc; close all; %#ok<CLALL>

%% Carrega os dispositivos da NI e seta a frequência de amostragem, resolução espectral, NFFT e tempo de medição (em s).

addpath("codigos_auxiliares/")

d = daq.getDevices;
s = daq.createSession('ni');
s.Rate = 51200; % Taxa de amostragem para a NI.
Fs = s.Rate; % Taxa de amostragem.
deltaf = 0.1; % Resolucao do eixo de frequencias, em Hz.
NFFT = (1/deltaf)*Fs; % Número de pontos da FFT.
% s.DurationInSeconds = 30; % Tempo de duração da medição, em segundos.

%% Seta os canais 0 e 1 da NI para canais de entrada

[ch, idx] = addAnalogInputChannel(s,'cDAQ1Mod1', [0, 1],'voltage'); % Canal 0, Canal 1
[ch, idx] = addAnalogOutputChannel(s, 'cDAQ1Mod2', 'ao1', 'voltage'); % ao0 - analog output canal 0

% channels = d.Subsystems.ChannelNames

sens1 = 1;% %sensibilidade V/V
calscale1 = 1/sens1;

sens2 = 1;% %sensibilidade V/V
calscale2 = 1/sens2;

%% Especificações sobre o sinal de medição

trec = 60; % Tempo de gravação, em segundos;
nbits = 16; % A NI 9234 é 24 bits porém a NI 9263 é 16 bits;
ruido = 1; % ruído branco-1; sweep-2;
Ts = trec; % %Tempo de geração do som;

%%
fprintf('Cada medição terá uma duração de %d segundos \n', trec)

for nn = 2:5%numero de medias
    
    %% Medição sem massa

    disp('------------------------------------------------------------------------------------------------')
    input('Desligue o amplificador e desconecte o alto-falante. \nAgora, reconecte o alto-falante e ligue o amplificador novamente, após isso, dê Enter para continuar com a medição!\n'); 
    disp('------------------------------------------------------------------------------------------------')
    text = sprintf('A medição com o falante fora da caixa 0%d está começando!', nn);
    disp(text);
    disp('Não esqueça de anotar a temperatura atual e umidade relativa!')
       
    if ruido == 1
        
        ts = 0:1/Fs:Ts-1/Fs;
        rNoise = dsp.ColoredNoise('Color', 'white', 'SamplesPerFrame', Ts*Fs, 'NumChannels', 1); %white, blue, brown
        xs = rNoise(); clear pinkNoise;
        xs = xs./(max(xs)); 
        queueOutputData(s, xs); [Recording, t] = s.startForeground; %para gerar o ruído atraves da plana NI (tempo medicao=tempo de geracao)
%         sound(xs,Fs);  [Recording, t] = s.startForeground;
        clear sound

        day = datetime('today');
        fname = sprintf('medicao_caixaLivre_alinhamento_sistema_%d_%s_whiteNoise_%ds', nn, day, trec);
        
    end

    if ruido == 2
        
%         sweep_excitacao = ita_generate_sweep('fftDegree', Fs*trec, 'mode', 'exp', ...
%                             'samplingRate', Fs, 'stopMargin', 0.1, 'freqRange', [1 20000]);
%         queueOutputData(s, sweep_excitacao.timeData); [Recording, t] = s.startForeground; %para gerar o ruído atraves da plana NI (tempo medicao=tempo de geracao)
%         clear sound;
% 
%         day = datetime('today');
%         fname = sprintf('medicao_caixaLivre_alinhamento_sistema_%d_%s_sweep_%ds', nn, day, trec);
        
        %% Para calibração de tensão 250 HZ

        f1=250; f2=250.001; % Para geração de um seno em 250 Hz.
        [sweepf, sweepf_fs, sweepf_t] = sweepsine(Ts, f1, f2, Fs);
        sweepf = sweepf.*0.2; % para não clipar
        queueOutputData(s, sweepf); [Recording, t] = s.startForeground; %para gerar o ruído atraves da plana NI (tempo medicao=tempo de geracao)
%         sound(sweepf, Fs); [Recording, t] = s.startForeground;
        clear sound;

    end
    
%
    disp('A medição acabou!');

    % Sinais no tempo e plot
    x = calscale2.*Recording(:, 1); % canal 1 - resistor
    y = calscale1.*Recording(:, 2); % canal 2 - falante

    a = 2;
    b = 1;
    %[Pxy,F] = cpsd(X,Y,WINDOW,NOVERLAP,NFFT,Fs) %cross epectrum
    [Hf, freqh] = tfestimate(x, y, hanning(NFFT), NFFT/a, b*NFFT,Fs);%'twosided');

    [coe, freqc] = mscohere(x, y, hanning(NFFT), NFFT/a, b*NFFT, Fs);
    Hf = 1.*Hf;

% Salvando dados

    text = sprintf('Salvando o arquivo %s\n', fname);
    path = ['Dados/caixaLivre/' fname];
 
    disp('------------------------------------------------------------------------------------------------')
    disp(text)
    disp(path)
    disp('------------------------------------------------------------------------------------------------')
    save(path);


    % Plot da medição atual

    figure('Name', 'Sinais no tempo')
    plot(t, Recording(:, 1), 'k', t, Recording(:, 2), 'r'); grid on; %hold on;
    xlabel('Tempo [s]'); ylabel('Amplitude [V]')
    legend('input 1', 'input 2')

    figure('Name', 'Função de transferência')
    semilogx(freqh, (3.2/abs(Hf(find(freqh==2)))).*Hf);  grid on; hold on
    xlabel('Frequência [Hz]')
    ylabel('Função de Transferência [V / V]')
    xlim([1 20000])
    ylim([0 20])

    figure('Name', 'Coerência')
    semilogx(freqh, coe);  grid on; hold on
    xlabel('Frequência [Hz]')
    ylabel('Coerência [-]')
    xlim([0 20000])
    ylim([0.5 1])   

    %% Medição com alto-falante na caixa
        
    disp('------------------------------------------------------------------------------------------------')
    input('Antes de continuar com a medição, desligue o amplificador e desconecte o cabo P10. \nAgora, coloque o alto-falante na caixa, ligue o amplificador e reconecte o cabo P10. \nApós, dê "Enter" para continuar com a medição.\n');
    disp('------------------------------------------------------------------------------------------------')
    text = sprintf('A medição com o falante dentro da caixa 0%d está começando!', nn);
    disp(text);    
    disp('Não esqueça de anotar a temperatura atual e umidade relativa!')
    
    if ruido == 1
        
        ts = 0:1/Fs:Ts-1/Fs;
        rNoise = dsp.ColoredNoise('Color', 'white', 'SamplesPerFrame', Ts*Fs, 'NumChannels', 1); %white, blue, brown
        xs = rNoise(); clear pinkNoise;
        xs = xs./(max(xs)); 
        queueOutputData(s, xs); [Recording, t] = s.startForeground; %para gerar o ruído atraves da plana NI (tempo medicao=tempo de geracao)
%         sound(xs,Fs);  [Recording, t] = s.startForeground;
        clear sound

        day = datetime('today');
        fname = sprintf('medicao_caixaMassa_alinhamento_sistema_%d_%s_whiteNoise_%ds', nn, day, trec);
        
    end

    if ruido == 2
        
        sweep_excitacao = ita_generate_sweep('fftDegree', Fs*trec,'mode', 'exp', ...
                            'samplingRate', Fs,'stopMargin', 0.2,'freqRange', [1 20000]);
        queueOutputData(s, sweep_excitacao.timeData); [Recording, t] = s.startForeground; %para gerar o ruído atraves da plana NI (tempo medicao=tempo de geracao)
        clear sound;

        day = datetime('today');
        fname = sprintf('medicao_caixaMassa_alinhamento_sistema_%d_%s_sweep_%ds', nn, day, trec);
        
    end
    
%
    disp('A medição acabou!');

    % Sinais no tempo e plot
    x = calscale2.*Recording(:, 1); % canal 1 - resistor
    y = calscale1.*Recording(:, 2); % canal 2 - falante

    a = 2;
    b = 1;
    %[Pxy,F] = cpsd(X,Y,WINDOW,NOVERLAP,NFFT,Fs) %cross epectrum
    [Hf, freqh] = tfestimate(x, y, hanning(NFFT), NFFT/a, b*NFFT,Fs);%'twosided');

    [coe, freqc] = mscohere(x, y, hanning(NFFT), NFFT/a, b*NFFT, Fs);
    Hf = 1.*Hf;

% Salvando dados

    text = sprintf('Salvando o arquivo %s\n', fname);
    path = ['Dados/caixaMassa/' fname];
 
    disp('------------------------------------------------------------------------------------------------')
    disp(text)
    disp(path)
    disp('------------------------------------------------------------------------------------------------')
    save(path);


    % Plot da medição atual

    figure('Name', 'Sinais no tempo')
    plot(t, Recording(:, 1), 'k', t, Recording(:, 2), 'r'); grid on; %hold on;
    xlabel('Tempo [s]'); ylabel('Amplitude [V]')
    legend('input 1', 'input 2')

    figure('Name', 'Função de transferência')
    semilogx(freqh, (3.2/abs(Hf(find(freqh==2)))).*Hf);  grid on; hold on
    xlabel('Frequência [Hz]')
    ylabel('Função de Transferência [V / V]')
    xlim([1 20000])
    ylim([0 20])

    figure('Name', 'Coerência')
    semilogx(freqh, coe);  grid on; hold on
    xlabel('Frequência [Hz]')
    ylabel('Coerência [-]')
    xlim([0 20000])
    ylim([0.5 1])   
end