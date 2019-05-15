% pred pustenim: 
% pkg load signal

clear all
# close all

[y, fs] = audioread ('veta.wav');
subplot(4, 1, 1);

y = y(1:fs/2, 1);
plot(y, "k");

n = 512;    # length of overlapping segment

axis([0, size(y,1)]);

[S, f, t] = specgram (y(:, 1), n, fs, hanning(n), n-15);    #S = FFT, f = rows(S), t = cols(S)
%[S, f, t] = specgram (y(:, 1), n, fs, hanning(n), n-10);

size(S)

_S = S;

S = abs(S);
S = S/max(S(:)); 
S = max(S, 10^(-40/10)); 
S = min(S, 10^(-3/10));

subplot(4, 1, 2);

colormap(gca, gray());

imagesc(t, f(1:100), log(1-S(1:100, :)));
%imagesc(t, f, S);
set(gca,'YDir','normal');

subplot(4, 1, 3);

energy = sum(abs(_S).^2, 1);

plot(energy)

axis([0, size(S,2)]);

m = (n*(n-1))/2
#_energy = energy(:, 1);

_newX = 0;
for i = 1:(n-1)
  sumX = 0;
  for j = i+1:n
    sumX = sumX + (energy(i) * energy(j));
  _newX = _newX + sumX;
  endfor
endfor
_newX = _newX / m

#subplot(4, 1, 4);
