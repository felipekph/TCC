function [sweepf,fs,t]=sweepsine(T,f1,f2,fs)

% generate sine sweep with exponential frequency dependent energy decay
% over time and time/frequency inverse for impulse response calculation
% inputs:
%clear all; clc
%  T = 3 ;%sweep duration in seconds
%  f1 = 100;%start frequency in Hz
%  f2 = 12000;%end frequency in Hz
silence = 0;%silence before and after sweep in seconds (default: 0)
% % fs = 44100;%sampling frequency (default: 44100)

% if nargin < 5
%     fs=44100;
% end
if nargin < 4
    silence=0;
end
silence=silence*fs;

w1=2*pi*f1;
w2=2*pi*f2;
t=0:1/fs:(T*fs-1)/fs;
t=t';
K=T*w1/log(w2/w1);
L=T/log(w2/w1);
sweep=sin(K.*(exp(t./L)-1));

if sweep(end)>0
    t_end=find(sweep(end:-1:1)<0,1,'first');
end   
if sweep(end)<0
    t_end=find(sweep(end:-1:1)>0,1,'first');
   
end
t_end=length(sweep)-t_end;
sweep(t_end+1:end)=0;
sweep=[zeros(silence,1);sweep;zeros(silence,1)];
invsweep=sweep(length(sweep):-1:1).*exp(-t./L);
invsweep=invsweep/max(abs(invsweep));

%% fade-in and fade-out
fade_durations = [ 1 1 ];       % fade-in and fade-out durations (ms)
N=length(sweep);
% fade-in and fade-out window function handles
fade_windows = { @(N)(hanning(N).^2) @(N)(chebwin(N,100)) }; 
sweepf = fade( sweep, fs, fade_durations, fade_windows);
%%

%plot(t,sweepf)
% sound(sweepf,fs); 
%wavwrite(sweep,fs,'sweep2.wav');