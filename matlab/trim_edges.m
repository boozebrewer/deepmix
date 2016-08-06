function x = trim_edges(x,len)
if (len+1)<floor(length(x)/2)
    x = x(len+1:end-len);
else
    error;
end