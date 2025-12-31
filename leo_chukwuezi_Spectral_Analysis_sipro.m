Nt = 128;
fs = 1000;       
f0 = 5/128*fs;   
a = 1;           
phi = 0;         
n = 0:Nt-1;     
t = n/fs;        
y = a * cos(2*pi*f0*t + phi);
f1=figure(1);
set(f1,'position',[0 50 1280 600]);
plot(t, y, '-o');
xlabel('Time (s)');
ylabel('Amplitude');
title('Time-Domain Signal');
grid on;
exportgraphics(gcf,'plot1.png');

Y = fft(y);                  
freq = (0:Nt-1)*(fs/Nt);     
magnitude = abs(Y)/Nt;       
f2=figure(2);
set(f2,'position',[0 50 1280 600]);
plot(freq, magnitude, '-o');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Magnitude Spectrum (Nf = 128)');
grid on;
exportgraphics(gcf,'plot2.png');

Nf1 = 128;
Y1 = fft(y, Nf1);
freq1 = (0:Nf1-1)*(fs/Nf1);
mag1 = abs(Y1)/Nt;
f3=figure(3);
set(f3,'position',[0 50 1280 600]);
plot(freq1, mag1, 'x'); hold on;   % Cross markers
Nf2 = 4096;
Y2 = fft(y, Nf2);
freq2 = (0:Nf2-1)*(fs/Nf2);
mag2 = abs(Y2)/Nt;
plot(freq2, mag2, '-');            
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Magnitude Spectrum Comparison');
legend('Nf = 128 (cross)', 'Nf = 4096 (line)');
grid on;
exportgraphics(gcf,'plot3.png');

f0_new = 5.7/128 * fs;
y_new = a * cos(2*pi*f0_new*t + phi);
% FFT for Nf = 128
Y1_new = fft(y_new, Nf1);
mag1_new = abs(Y1_new)/Nt;
% FFT for Nf = 4096
Y2_new = fft(y_new, Nf2);
mag2_new = abs(Y2_new)/Nt;
f4=figure(4);
set(f4,'position',[0 50 1280 600]);
plot(freq1, mag1_new, 'x'); hold on;
plot(freq2, mag2_new, '-');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Magnitude Spectrum Comparison for f0 = 5.7/128 * fs');
legend('Nf = 128 (cross)', 'Nf = 4096 (line)');
grid on;
exportgraphics(gcf,'plot4.png');