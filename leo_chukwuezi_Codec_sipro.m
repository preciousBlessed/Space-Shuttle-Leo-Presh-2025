[y, fs]=audioread('musique.wav');
info=audioinfo('musique.wav')
fmin=0;
fmax=8000;
bits=info.BitsPerSample;
%Encoder
[npt, scaling] = Codeur(y, fs, bits, fmin, fmax, 'encoded.wav');
%Decoder
y_dec=Decodeur('encoded.wav', fmin, fmax, npt, scaling);

sound(y_dec,fs);
pause(length(y)/fs + 1);

sound(y_dec,fs);

fig1=figure(1);
plot(y);
ylabel('Amplitude');
xlabel('Time(s)');
title('Audio Signal before CODEC')

fig2=figure(2);
plot(y_dec);
ylabel('Amplitude');
xlabel('Time(s)');
title('Audio Signal after CODEC')

exportgraphics(fig1, 'before.png');
exportgraphics(fig2, 'after.png');