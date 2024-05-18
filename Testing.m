clear all; close all; clc;

RMS=[];
it=0;

%% Oktavni Filtar
BandsPerOctave = 3;
N = 8;           % Filter Order
F0 = 1000;       % Center Frequency (Hz)
Fs = 48000;      % Sampling Frequency (Hz)
f = fdesign.octave(BandsPerOctave,'Class 1','N,F0',N,F0,Fs);
F0 = validfrequencies(f);
Nfc = length(F0);

for i=1:Nfc
    f.F0 = F0(i);
    Hd(i) = design(f,'butter');
end

%% Ucitavanje i Filtriranje
file_name="Signali\Sum\Govor\1_govor_sum.wav";
[x,fs] = audioread(file_name);
x=x./max(abs(x));
y=[];
for br=1:23
    y(:, br)=filter(Hd(br+6), x);
    RMS(br)=rms(y(:,br));
end
%RMS=mean(RMS);
for k=1:23
    x_oktavno(k)=20*log10(RMS(k));
    f_oktavno(k)=125*2^((k-2)/3);
end

%x_oktavno=x_oktavno-max(x_oktavno(1,:));
figure,
semilogx(f_oktavno, x_oktavno,'-o','LineWidth',3),
title('Oktavni spektar'),
xlabel('Frekvencija[Hz]'),
ylabel('Nivo[dB]'),
xlim([100 16000]),
grid on;
