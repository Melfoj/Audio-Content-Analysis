clear all; close all; clc;

RMS=[];
it=0;

%% Oktavni Filtar
BandsPerOctave = 3;
N = 8;           % Filter Order
F0 = 1000;       % Center Frequency (Hz)
Fs = 16000;      % Sampling Frequency (Hz)
f = fdesign.octave(BandsPerOctave,'Class 1','N,F0',N,F0,Fs);
F0 = validfrequencies(f);
Nfc = length(F0);

for i=1:Nfc
    f.F0 = F0(i);
    Hd(i) = design(f,'butter');
end

%% Ucitavanje i Filtriranje
file_name1="..\Signali\Sum\Govor\1_govor_sum.wav";
file_name2="..\Signali\Cisti\Govor\1_govor.wav";
[x,fs] = audioread(file_name1);
x=x./max(abs(x));
[x2,fs] = audioread(file_name2);
x2=x2./max(abs(x2));
y=[];
y2=[];
for br=1:19
    y(:, br)=filter(Hd(br+6), x);
    RMS(br)=rms(y(:,br));
    y2(:, br)=filter(Hd(br+6), x2);
    RMS2(br)=rms(y2(:,br));
end
%RMS=mean(RMS);
for k=1:19
    x_oktavno(k)=20*log10(RMS(k));
    x_oktavno2(k)=20*log10(RMS2(k));
    f_oktavno(k)=125*2^((k-2)/3);
end
dx=x_oktavno-x_oktavno2;
%x_oktavno=x_oktavno-max(x_oktavno(1,:));
figure,
semilogx(f_oktavno, dx,'-o','LineWidth',3),
title('Oktavni spektar'),
xlabel('Frekvencija[Hz]'),
ylabel('Nivo[dB]'),
xlim([100 16000]),
grid on;

filt=load('FILT.mat');
filt=filt.FILT;
filt=filt(1:length(x_oktavno));
filt=20*log10(filt);
raz=filt-x_oktavno;

figure,
semilogx(f_oktavno, raz,'-o','LineWidth',3),
title('Oktavni spektar'),
xlabel('Frekvencija[Hz]'),
ylabel('Nivo[dB]'),
xlim([100 16000]),
grid on;
%%
N_filter=50; %privremeni red filtra, posle mozemo da bazdarimo
wp=f_oktavno./fs*2; % fs/2 nam je pi 
wd=[0 wp 1]; %zahteva nam da osa pocinje od nule i zavrsava se jedinicom
h=[];
s=raz;
s=s';
s=-s;
ap=[];
for j=1:length(s)
    ap(j)=10^(s(j)/20); %prevodjenje slabljenja iz dB u osnovne jedinice
end
ad=[ap(1) ap ap(end)]; %da bi imalo isti broj clanova kao osa
h=fir2(N_filter,wd,ad); %filtri, stavlja se svako u svoju kolonu