classdef Tacogram < Signal
    % Class designed as a Signal subclass to handle tacogram functionality
    % (inherits from Signal.m)
    %
    % Properties:
    %   inherited from Signal
    %   kind : references the kind of tacogram (if it's time or beat
    %   driven).
    %
    % Methods (Subclass specific):
    %
    %   subsignal(start, fin) : modification of superclass method to
    %   include kind in the returned object.
    
    properties
        beat =[]
    end
    
    methods   
        
        function obj = Tacogram()
                obj.signal = [];
                obj.time = [];
                obj.beat = [];
        end
        function new = subsignal(obj, start, fin)
            new = subsignal@Signal(obj,start,fin);
            new.kind = obj.kind; 
        end
        
        function new = poincarePlot(obj,n)
        x = [obj.signal(n:length(obj.signal)), obj.signal(1:n-1)]; 
        new = PointSpace(obj.signal, x);
        end
        
        function obj = append(obj, signal, time)
            obj.signal = [obj.signal, signal];
            obj.time = [obj.time, time];
            if length(obj.beat)==0
                obj.beat = [obj.beat,1];
            else
                obj.beat = [obj.beat, obj.beat(length(obj.beat))+1];
            end
        end
        
        function representR_R(obj)
            rr = [];
            for i=2:length(obj.time)
                rr = [rr, (obj.time(i)-obj.time(i-1))];
            end
            t = (obj.time(2:end)-obj.time(2));
            plot(t,rr);
        end
        
        function FFT (obj)
            rr = [];
            for i=2:length(obj.time)
                rr = [rr, (obj.time(i)-obj.time(i-1))];
            end
            Fs = 1000;
            per = 1/Fs;
            t = 0:per:obj.time(end)-1;
            interp = spline(obj.time(2:end), rr, t);
            Y = fft(interp);
            L = length(rr);
            P2 = abs(Y/L);
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            f = Fs*(0:(L/2))/L;
            plot(f,P1) 
        end
            
    end
end

