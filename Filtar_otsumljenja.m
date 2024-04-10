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
for b=["_govor_sum.wav","_muzika_rock_sum.wav","_muzika_pop_sum.wav","_muzika_rnb_sum.wav"]
    ch=convertStringsToChars(b);
    it=it+1;
    for a=1:2
        file_name=sprintf('%d',a);
        switch b
        case "_govor_sum.wav" 
            file_name=['Signali\Sum\Govor\',file_name,ch];
        case "_muzika_rock_sum.wav"
            file_name=['Signali\Sum\Rock\',file_name,ch];
        case "_muzika_pop_sum.wav"
            file_name=['Signali\Sum\Pop\',file_name,ch];
        case "_muzika_rnb_sum.wav"
            file_name=['Signali\Sum\RnB\',file_name,ch];
        otherwise
            warning('No such signal.')
        end
        file_name=convertCharsToStrings(file_name);
        [x,fs] = audioread(file_name);
        x=x./max(abs(x));
        y=[];
        for br=1:23
            y(:, br)=filter(Hd(br+6), x);
            RMS(a,br)=rms(y(:,br));
        end
    end
    RMS=mean(RMS);
    for k=-1:21
        x_oktavno(it,k+2)=20*log10(RMS(k+2));
        f_oktavno(k+2)=125*2^(k/3);
    end
end

x_oktavno=x_oktavno-max(x_oktavno(1,:));
%fvtool(Hd);
figure,
semilogx(f_oktavno, x_oktavno,'-o','LineWidth',3),
title('Oktavni spektar'),
xlabel('Frekvencija[Hz]'),
ylabel('Nivo[dB]'),
legend('Govor','Rock','Pop','RnB'),
xlim([100 16000]),
grid on;

% RMScor=[];
% for i=1:4
%     RMScor(:,i)=x_oktavno(1,:)-x_oktavno(i,:);
% end
% 
% figure,
% semilogx(f_oktavno,RMScor,'-o','LineWidth',3),
% title('Razlika nivoa'),
% xlabel('Frekvencija[Hz]'),
% ylabel('Nivo[dB]'),
% legend('Bez maske','Hirurska maska','N95','Pamucna maska','Vizir'),
% xlim([100 16000]),
% grid on;
