clc;clear all; close all;
file_name ="Signali\Sum\Govor\1_govor_sum.wav";
[x,fs] = audioread(file_name);
prozor=10;
a = lpc(x,10);
est_x = filter([0 -a(2:end)],1,x);
sum=1;%bull dal je prisutan sum
for i=1:length(x)
    if sum==1
        %x(max(i-prozor,1):min(i+prozor,length(x)));
    end
end
plot(1:100,x(end-100+1:end),1:100,est_x(end-100+1:end),'--')
grid
xlabel('Sample Number')
ylabel('Amplitude')
legend('Original signal','LPC estimate');
playerx= audioplayer(x,fs);
playerestx=audioplayer(est_x,fs);

