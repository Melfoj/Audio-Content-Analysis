clc;clear all; close all;
%% Ucitavanje i promenljive
file_name ="Signali\Sum\Govor\1_govor_sum.wav";
[x,fs] = audioread(file_name);
xog=x;
T = 0.5;
N=150;
T_odb = T*fs;
n = 0.2*T_odb;

%% Lociranje i uklanjanje suma
[pks,locs]=findpeaks(x, MinPeakDistance = n, MinPeakHeight = 0.2);
prozor=10;
for i=1:length(x)
    if ismember(i,locs)
        est_x=[];
        a = lpc(x(1:max(i-prozor,1)),N);
        est_x(1:i-prozor) = x(1:i-prozor);
        [~, zf] = filter(-[0 a(2:end)], 1, x(1:max(i-prozor,1)));     
        est_x((i-prozor+1):length(x)) = filter([0 0], -a, zeros(1, length(x)-i+prozor), zf); 
        x(max(i-prozor,1):min(i+prozor,length(x)))=est_x(max(i-prozor,1):min(i+prozor,length(est_x)));
    end
end
%% Crtanje
t=(1:1:length(x))/fs;
figure,
plot(t,xog,t,x,locs/fs,pks,"o")
grid
xlabel('Sample Number')
ylabel('Amplitude');
% playerx= audioplayer(x,fs);
% playerestx=audioplayer(est_x,fs);
%% Razlika
d=xog-x;
figure, plot(t,d,locs/fs,pks,"o");