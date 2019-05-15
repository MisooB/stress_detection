% pred pustenim: 
% pkg load signal

clear all
# close all

[x, fs] = audioread ('sounds/veta.wav');   # fs = vzorkovacia frekvencia

# x = x(1:fs*0.8, 1);   # fs*0.8 = po prve slovo

#x = x(:, 1);

#udaje ku x
M = size(x, 1);     # dlzka x
N = fix(fs*0.02);   # velkost okienka - 20ms
N2 = fix(N/2);      # stred okna
w = hanning(N);     # vektor dlzky N
step = fix(N/3);    # posun okna
# step = 15;
Nfft = 512;         # rad furierovej transf
Nfft2 = fix(Nfft/2);

subplot(4, 1, 1);
plot(x, "k");       #k = cierna
axis([1, M])        # vyrez grafu

E = [];
S = [];
t = [];
for i = 1:step:(M-N+1)

  xw = x(i:i+N-1, 1) .* w;
  t = [t;(i+N2)/fs];

  #spectrogram
  #S = [S, fft(xw, Nfft)];
  [pb, nic] = pburg(xw, 40, Nfft, fs);
  S = [S, pb];
  
  ## energia
  E = [E, sum(xw.^2, 1)];

  
end

## vytv. vektora 0 po nfft-1, kazdy prvok vydeleny Nfft a vynasobeny fs:


#n = 512;    # length of overlapping segment
#axis([0, size(y,1)]);
#[S, f, t] = specgram (y(:, 1), n, fs, ones(n, 1), n-15);    #S = FFT, f = rows(S), t = cols(S)
%[S, f, t] = specgram (y(:, 1), n, fs, hanning(n), n-10);
#size(S)

_S = S;

S = abs(S);
S = S/max(S(:)); 
S = max(S, 10^(-40/10)); 
S = min(S, 10^(-3/10));

subplot(4, 1, 2);

#colormap(gca, flipud(gray()));
colormap(gca, gray());

f = [0:100-1] ./ Nfft .* fs;   

imagesc(t, f, log(1-S(1:100, :)));
#imagesc(t, f, log(S));
set(gca,'YDir','normal');

subplot(4, 1, 3);

# energy = sum(abs(_S).^2 / Nfft, 1);     #nebolo spravne

plot(E, "r")

axis([0, size(_S,2)]);

# m = (N*(N-1))/2
#_energy = energy(:, 1);

#newX = 0;
#for i = 1:(N-1)
#  sumX = 0;
#  for j = i+1:N
#    sumX = sumX + (energy(i) * energy(j));
#  _newX = _newX + sumX;
#  endfor
#endfor
#_newX = _newX / m

#subplot(4, 1, 4);
