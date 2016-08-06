load mtlb
newFs = 8192;
[P,Q] = rat(newFs/Fs);
abs(P/Q*Fs-newFs)
mtlb_new = resample(mtlb,P,Q);

subplot(2,1,1)
plot((0:length(mtlb)-1)/Fs,mtlb)
subplot(2,1,2)
plot((0:length(mtlb_new)-1)/(P/Q*Fs),mtlb_new)

% Pmtlb = audioplayer(mtlb,Fs);
Pmtlb_new = audioplayer(mtlb_new,8192);
% play(Pmtlb)
play(Pmtlb_new)