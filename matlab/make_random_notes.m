% midi = readmidi('jesu.mid')
% (Fs = sample rate. here, uses default 44.1k.)
% [y,Fs] = midi2audio(midi);    
% soundsc(y, Fs);  % FM-synth  'sine'); , 'saw');
%% convert to 'Notes' matrix:
rng(10)
Fs = 44100;
% initialize matrix:
N = 13;  % num notes
M = zeros(N,6);

M(:,1) = 1;         % all in track 1
M(:,2) = 1;         % all in channel 1
M(:,3) = randint(1,N,12)+60;      % note numbers: one ocatave starting at middle C (60)
M(:,4) = round(linspace(80,80,N))';  % lets have volume ramp up 80->120
M(:,5) = (.5:.5:6.5)';  % note on:  notes start every .5 seconds
M(:,6) = M(:,5) + .5;   % note off: each note has duration .5 seconds

midi_new = matrix2midi(M);
writemidi(midi_new, 'testout.mid');

%% just display info:
midiInfo(midi_new);

y = midi2audio(midi_new, Fs,'sine');
y = y(1:Fs*6);
soundsc(y,Fs);


y = .95.*y./max(abs(y));
wavwrite(y, Fs, 'rand_sine_6sec.wav');

