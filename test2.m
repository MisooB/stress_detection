% pkg load signal
% addpath('C:\Users\micha\Desktop\jsonlab-master')
## poslat nazov suboru a sekvenciu (0,1 prizvuk)
## nacitat zvuk, podla sekvencie viem pocet slabik, hladat 

clear all
# close all

#[x, fs] = audioread('sounds/its_you.wav');   # fs = vzorkovacia frekvencia
#x = x(fix(fs*1.1):fix(fs*1.9), 1);   # fs*0.8 = po prve slovo
#yMono = sum(x, 2) / size(x, 2);

#filename = 'sounds/hello2.flac';
#filename = 'sounds/especially.ogg';
#filename = 'sounds/problem.ogg';
#filename = 'sounds/catch.ogg';
#filename = 'sounds/word.ogg';
#filename = 'sounds/its_you.wav';
#filename = 'sounds/i_know.wav';
#filename = 'sounds/im_gonna_go.wav';

sound_dict = loadjson('word_dict.json');

my_word = "aspirin";

#for [val, key] = sound_dict
#  val.file_name;
#  val.stress_seq;
#end

filename = sound_dict.(my_word).file_name;

[x, fs] = audioread (strcat("sounds/dataset1/", filename));   
[B,A] = init_subbands(fs);

#udaje ku x
M = size(x, 1);     # dlzka x
N = fix(fs*0.02);   # velkost okienka - 20ms
N2 = fix(N/2);      # stred okna
w = hanning(N);     # vektor dlzky N
step = fix(N/3);    # posun okna
# step = 15;
Nfft = 512;         # rad furierovej transf
Nfft2 = fix(Nfft/2);

subplot(5, 1, 1);
plot(x, "k");       #k = cierna
axis([1, M])        # vyrez grafu

E = []; 
S = [];
t = [];
mf = [];

K = 14;
ds_old = zeros(1, K/2);
ds_new = zeros(1, K/2);
k = 0;
wg = gausswin(K);
sub_energies = [];
maxK = fix((M-N+1) / step);

for i = 1:step:(M-N+1)
  
  xx = x(i:i+N-1, 1);
  xw = x(i:i+N-1, 1) .* w;
  t = [t;(i+N2)/fs];
  
  #spectrogram
  #[S0, nic] = pburg(xw,40, Nfft, fs);
  S0 = fft(xw, Nfft);
  
  S0 = abs(S0);
  #S0 = log(S0);
  #S0 = S0/max(S0(:)); 
  #S0 = max(S0, 10^(-40/10)); 
  #S0 = min(S0, 10^(-3/10));

  S = [S, S0];
    
  #[pb, nic] = pburg(xw, 20, Nfft, fs);
  #S = [S, pb];
  
  ## energia
  E = [E, sum(xw.^2, 1)];
  
  ## subband energie
  sub0 = subband_filter(B, A, xx);
  sub0 = abs(sub0);
  #sub0 = sub0 /max(sub0(:)); 
  
  #sub0 = log(sub0);
  #sub0 = max(sub0, 10^(-40/10)); 
  #sub0 = min(sub0, 10^(-3/10));

  sub_energies = [sub_energies, sub0];
  
  #max(sub_energies (:))
  # mf = [mf, MorganFosler(abs(S(:, end)).^2)];   # vsetky riadky, posledny stlpec
  
  if (k >= K-1)
    ds_old = [ds_old, DagenShrikanth( (abs(S(:, (end-K+1):end)).^2) .* wg') ];
    ds_new = [ds_new, DagenShrikanth( (sub_energies(:, (end-K+1):end)) .* wg')];
  end
  
  k++;
  printf('progress: %d %%\r', fix(k / maxK * 100))
end

[syllables,FS,S,F,T,P] = harmaSyllableSeg(ds_new,kaiser(512),128,1024,20);