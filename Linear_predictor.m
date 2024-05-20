clc;clear all; close all;
file_name ="Signali\Sum\Govor\1_govor_sum.wav";
[x,fs] = audioread(file_name);
T = 0.5;
T_odb = T*fs;
n = 0.5*T_odb;
[pks,locs]=findpeaks(x, MinPeakDistance = n, MinPeakHeight = 0.45);
prozor=10;
a = lpc(x,10);
for i=1:length(x)
    if ismember(i,locs)
        est_x = filter([0 -a(2:end)],1,x(1:i+prozor));
        x(max(i-prozor,1):min(i+prozor,length(x)))=est_x(end-prozor:min(i+prozor,length(est_x)));
    end
end
plot(1:100,x(end-100+1:end),1:100,est_x(end-100+1:end),'--')
grid
xlabel('Sample Number')
ylabel('Amplitude')
legend('Original signal','LPC estimate');
playerx= audioplayer(x,fs);
playerestx=audioplayer(est_x,fs);

