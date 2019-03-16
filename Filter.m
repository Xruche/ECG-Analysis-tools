classdef Filter    
    properties
    end
    
    methods
        function obj = Filter()
        end
        
        function newsig = MovingMedian(obj,signal, n)
            newsig = Signal();
            s = size(signal.time);
            sum = 0;
            for i=0:n:s(1,2)-n
                for j=1:n
                    sum = sum + signal.signal(i+j);
                    median = sum/n;
                end
                newsig = newsig.append(median, ((signal.time(1,i+n)-signal.time(1,i+1))/2)+signal.time(1,i+1));
                sum = 0;
            end
            if isa(signal, 'ECGsignal')
                newsig = ECGsignal(newsig.signal, newsig.time);
            end
        end
    end
end

