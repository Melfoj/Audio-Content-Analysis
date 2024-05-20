 clear all; close all; clc;

FILT=[];
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
for b=["_govor.wav","_muzika_rock.wav","_muzika_pop.wav","_muzika_rnb.wav"]
    ch=convertStringsToChars(b);
    it=it+1;
    for a=1:10
        file_name=sprintf('%d',a);
        switch b
        case "_govor.wav" 
            file_name=['Signali\Cisti\Govor\',file_name,ch];
        case "_muzika_rock.wav"
            file_name=['Signali\Cisti\Rock\',file_name,ch];
        case "_muzika_pop.wav"
            file_name=['Signali\Cisti\Pop\',file_name,ch];
        case "_muzika_rnb.wav"
            file_name=['Signali\Cisti\RnB\',file_name,ch];
        otherwise
            warning('No such signal.')
        end
        file_name=convertCharsToStrings(file_name);
        [x,fs] = audioread(file_name);
        x=x(:,1);
        x=x./max(abs(x));
        y=[];
        for br=1:19
            y(:, br)=filter(Hd(br+6), x);
            filt(a,br)=rms(y(:,br));
        end
    end
    FILT(it,:)=mean(filt);
    for k=1:19
        x_oktavno(it,k)=20*log10(FILT(it,k));
    end
end
for k=1:19
    f_oktavno(k)=125*2^((k-2)/3);
end
save FILT.mat;
%x_oktavno=x_oktavno-max(x_oktavno(1,:));
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
