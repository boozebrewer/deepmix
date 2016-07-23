recObj = audiorecorder;
Fs = recObj.SampleRate;
for i=2:-1:1
    fprintf('%d',i);
    pause(1);
    fprintf('\b');
end
disp('Start speaking.')
t = 1;
recordblocking(recObj, 0.5);
disp('End of Recording.');

play(recObj);

y = getaudiodata(recObj);

plot(y);