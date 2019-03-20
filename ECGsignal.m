classdef ECGsignal < Signal
   % Class designed as a Signal sublcass to handle specific ECG signals
   % 
   % Properties:
   %    inherited from Signal
   %
   % Methods (Subclass specific):
   %
   %    tacogram () : returns a Tacogram object with the corresponding
   %    tacogram generated as time or beat driven (defined by the user). It
   %    also displays detected anomaly beats.
   %
   %    getRs () : returns a Signal object with the detected R peaks in the
   %    signal.
    properties
    end
    
    methods
                        
        function signal = tacogram(obj)
            type = input ("Enter tacogram kind (time or beat driven) : ");
            rs = obj.getRs();
            signal = Tacogram();
            if type=="time"
                for i=2:length(rs.signal)
                    bpm = 60/(rs.time(i)-rs.time(i-1));
                    if bpm > 200
                        disp("Anomaly point at : "+num2str(rs.time(i))+" s");
                    else
                        signal=signal.append(bpm,rs.time(i));
                    end
                end
            elseif type == "beat"
                for i=2:length(rs.signal)
                    bpm = 60/(rs.time(i)-rs.time(i-1));
                    if bpm > 200
                        disp("Anomaly point at : "+num2str(rs.time(i))+" s");
                    else
                        signal=signal.append(bpm,i-1);
                    end
                end            
            else
                error("Bad type argument")         
            end
            signal.kind = type;
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

