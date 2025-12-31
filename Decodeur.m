function [y, fs, bits]=Decodeur(filename, fmin, fmax, npt, scaling)
[tfy_masq, fs]=audioread(filename);
tfy_masq = tfy_masq(:,1) + 1i * tfy_masq(:,2);
tfy = zeros(npt, 1);
kmin = round(npt * fmin / fs) + 1;
kmax = round(npt * fmax / fs) + 1;
tfy(kmin:kmax) = tfy_masq;
tfy(npt-kmax+2 : npt-kmin+2) = conj(flipud(tfy_masq));
y = real(ifft(tfy));
y = y * scaling;
end