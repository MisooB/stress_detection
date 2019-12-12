%pkg load signal
%addpath('jsonlab-master')

clear all

positive_files = {};
negative_files = {};
sound_dict = loadjson('word_dict4.json');

for [val, key] = sound_dict
  filename = val.file_name;
  
  [x, fs] = audioread (strcat("sounds/dataset4/", filename));   
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
    S0 = fft(xw, Nfft);
    S0 = abs(S0);
    S = [S, S0];
      
    ## energia
    E = [E, sum(xw.^2, 1)];
    
    ## subband energie
    sub0 = subband_filter(B, A, xx);
    sub0 = abs(sub0);

    sub_energies = [sub_energies, sub0];
    
    if (k >= K-1)
      ds_old = [ds_old, DagenShrikanth( (abs(S(:, (end-K+1):end)).^2) .* wg') ];
      ds_new = [ds_new, DagenShrikanth( (sub_energies(:, (end-K+1):end)) .* wg')];
    end
    
    k++;
    
  end
  
  spec_limit = 47;
  f = [0: spec_limit-1] ./ Nfft .* fs;
  
  ## trim
  x = ds_new/max(ds_new);
  for s = 1:length(x)
      if x(s) > 10^-5
        break
      end
  end
  for e = length(x):-1:s+1
      if x(e) > 10^-5
        break
      end
  end
  x = x(s:e);
  
  ## hladanie prizvuku
  x_len = length(sound_dict.(key).stress_seq);
  x_part = length(x)/x_len;
  [max_val, max_idx] = max(x);
  chlievik = floor(max_idx/x_part) + 1;
  
  printf(key);
  
  if sound_dict.(key).stress_seq(chlievik) == '1' 
    printf(' - yes')
    positive_files.(key) = chlievik;
  else
    printf(' - no')
    negative_files.(key) = chlievik;
  end
  printf('\n');
  
endfor


#save percentage4.txt positive_files negative_files