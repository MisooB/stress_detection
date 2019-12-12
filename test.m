
[x, fs] = audioread('sounds/its_you.wav');
#xMono = sum(x, 2) / size(x, 2);

[syllables,FS,S,F,T,P] = harmaSyllableSeg(x(:, 2),kaiser(512),128,1024,20);