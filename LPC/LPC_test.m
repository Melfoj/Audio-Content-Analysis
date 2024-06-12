clc; clear all; close all;

file_name ="..\Signali\Cisti\Govor\1_govor.wav";
[x,fs] = audioread(file_name);
M=10000;
x(M+10)=max(x);
a = lpc(x(1:M), N);
P=length(x);
y = zeros(1, P);
t=(1:P);

% fill in the known part of the time series
y(1:M) = x(1:M);

% in reality, you would use `filter` instead of the for-loop
% for ii=(M+1):M+20      
%     y(ii) = -sum(a(2:end) .* y((ii-1):-1:(ii-N)));
% end

% Run the initial timeseries through the filter to get the filter state 
[~, zf] = filter(-[0 a(2:end)], 1, x(1:M));     

% Now use the filter as an IIR to extrapolate
y((M+1):P) = filter([0 0], -a, zeros(1, P-M), zf); 


y(M+20:length(x))=x(M+20:length(x));
figure,
plot(t, x, t, y);
l = line(M*[1 1], get(gca, 'ylim'));
set(l, 'color', [0,0,0]);
legend('actual signal', 'extrapolated signal', 'start of extrapolation');