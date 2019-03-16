classdef ECGsignal < Signal
   
    properties
    end
    
    methods
        function obj = ECGsignal(signal, time)
            obj@Signal(signal, time);            
        end
        
        function newsig = subsignal(obj, start, fin)
            newsig = subsignal@Signal(obj, start, fin);
            newsig = ECGsignal(newsig.signal, newsig.time);            
        end
                        
        function signal = tachogram(obj)
            rs = obj.getRs();
            signal = Signal();
            for i=2:length(rs.signal)
                bpm = 60/(rs.time(i)-rs.time(i-1));
                if bpm > 200
                    disp("Anomaly point at : "+num2str(rs.time(i))+" s");
                else
                    signal=signal.append(bpm,rs.time(i));
                end
            end             
        end
        
        function newsig = getRs(obj)
            [mu, dev] = obj.statistics();
            sup_limit = (mu+3*dev);
            newsig = Signal();
            for i=2:length(obj.signal)-1
                if obj.signal(i)>sup_limit
                    if and((obj.signal(i)-obj.signal(i-1))>0,(obj.signal(i+1)-obj.signal(i))<=0)
                        newsig = newsig.append(obj.signal(i), obj.time(i));
                    end
                end
            end
        end        
    end
end

