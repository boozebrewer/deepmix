recObj = audiorecorder;
Fs = recObj.SampleRate;
for i=2:-1:1
    fprintf('%d',i);
    pause(1);
    fprintf('\b');
end
disp('Start speaking.')
t = 1;
recordblocking(recObj, 2);
disp('End of Recording.');

play(recObj);

mtlb = getaudiodata(recObj);

plot(mtlb);

% save
save('rec','mtlb','Fs');