clear all;
close all;
clc;

%% Govorni signal

% Ucitavanje govornog signala
[x fs] = audioread("Govor\govor_01.wav");
t_osa = (0:length(x)-1)/fs;

%% Unosenje periodicne greske

% Perioda ponavljanja (u sekundama)
T = 0.5;
T_odb = T*fs;

% Amplituda greske
amp = 0.5;

for i = 1:T_odb:length(x)
    x(i) = x(i) + amp;
end

% Plot sa greskama
figure, plot(t_osa, x), title('Vremenski oblik formiranog signala'), 
ylim([min(x)*1.1 max(x)*1.1]),
xlabel('Vreme [s]'), ylabel('Amplituda');

%% Anvelope
[yupper, ylower] = envelope(x, 1000,'peak');

% Plot signala i anvelopa u cilju izdvajanja pikova 
figure, plot(t_osa, x, t_osa, yupper, t_osa, ylower), title('Vremenski oblik formiranog signala'), 
ylim([min(x)*1.1 max(x)*1.1]),
xlabel('Vreme [s]'), ylabel('Amplituda');

%% FindPeaks - Lokalizacija

% Opcije od koristi:
% Threshold - obavezno kombinovati
% MinPeakDistance
% MinPeakHeight - za slucaj kada je karakteristika buke potpuno poznata

% Rastojanje izmedju pikova
n = 0.5*T_odb;

% Namerno se traze pikovi na samom signalu (anvelopa moze da sluzi samo kao smernica)
figure, findpeaks(x, MinPeakDistance = n, Annotate = "extents", MinPeakHeight = 0.45);

% % Plot signala, anvelope i izdvojenih konkretnih pikova - RUCNO