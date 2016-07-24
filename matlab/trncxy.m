function [x,y] = trncxy(xin,yin)
len = min(length(xin),length(yin));
x = xin(1:len);
y = yin(1:len);
end