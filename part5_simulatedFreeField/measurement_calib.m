clear all; format long; clc; close all; %#ok<CLALL>

d = daq.getDevices;
s = daq.createSession('ni');
s.Rate = 51200;
Fs = s.Rate;
s.DurationInSeconds = 15;

[ch,idx] = addAnalogInputChannel(s,'cDAQ1Mod1', 'ai0', 'Microphone');


sens_mic1 = 1; %sensibilidade em V/V
s.Channels(1).Sensitivity = sens_mic1; 
% s.Channels(1).MaxSoundPressureLevel = 125; %dB

% d.Subsystems.ChannelNames
trec=s.DurationInSeconds; % tempo de gravação 
%% SOUND CAPTURE
disp('Start of Recording')
%%
[Recording ,t] = s.startForeground;

disp('End')

valor_rms = rms(Recording(:, 1));

% Plot
figure('Name', 'Sinal de tensão')
plot(t, Recording)
title('Sinal de tensão medido no microfone');
xlabel('Tempo [s]'); ylabel('Tensão [V]');
sens = valor_rms./1 % sensibilidade para 1 Pascal RMS
text = sprintf('Sensibilidade %.4f [V/Pa]', sens)
legend(text, 'Location', 'northeast')

% Salva .wav da medição
audiowrite('calibrador.wav', Recording(:, 1), Fs); % canal 1 - grava o sinal de tensão, em V
