function newsig = MovingMean(signal, n)
s = size(signal.time);
newsig = Signal();
sum = 0;
for i=0:n:s(1,2)-n
    for j=1:n
        sum = sum + signal.signal(i+j);
        median = sum/n;
    end
    newsig = newsig.append(median, ((signal.time(1,i+n)-signal.time(1,i+1))/2)+signal.time(1,i+1));
    sum = 0;
end
eval("newsig = "+class(signal)+"(newsig.signal, newsig.time);")

