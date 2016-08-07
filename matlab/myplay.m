function player = myplay(path)
[xOrig, fsOrig] = audioread(path);
player = soundnonblocking(xOrig, fsOrig);