classdef Signal
    % Class designed to handle signal data as well as some functionality
    %   properties :
    %       signal : array of signal data
    %       time   : array of time points
    %   methods
    %
    %       Signal(signal, time) : Constructor with optional variables able
    %       to save an existing signal to the object. If no variables ar
    %       provided, an empty signal will be generated.
    %       
    %       siggen(start,duration,period) : method to generate a new signal
    %       time points and a zero signal.
    %       
    %       clear() : method to clear the signal and generate a zero
    %       signal.
    %
    %       addsin(amplitude, frequency, angle) : add a sinwave to the
    %       signal with specified parameters.
    %
    %       represent(start, finish) : representation of the signal on a
    %       plot. When providing start and finish it will only display the
    %       signal between the interval of signal numbers.
    
    properties
        signal = []
        time = []
    end
    
    methods
        function obj = Signal(signal,time)
            if and(exist('signal', 'var'),exist('time', 'var'))
                obj.signal = signal;
                obj.time = time;
            elseif xor(exist('signal', 'var'),exist('time','var'))
                error("Bad argument for signal generation, provide (signal, time) array or none");
            else
                obj.signal = [];
                obj.time = [];
            end
        end
        
        function obj = siggen(obj, start, duration, period) 
            obj.time = start:period:duration;
            s = size(obj.time);
            obj.signal = zeros(1, s(1,2));          
        end
        
        function obj = clear(obj)
           s = size(obj.time);
           if (s(1,2)== 0)
                error("Signal not initialized, not able to clear");
           else
               obj.signal = zeros(1,s(1,2));
           end
        end 
        
        function obj = addsin(obj, amplitude, freq, angle)
            newsig = amplitude * sin(freq*obj.time + angle);
            obj.signal = obj.signal + newsig;            
        end
        
        function represent(obj, start, fin)
            if and(exist('start','var'), exist('fin','var'))
                if start < fin
                    plot(obj.time(start+1:fin+1), obj.signal(start+1:fin+1));
                else
                    error("Bad arguments.")
                end
            elseif and(exist('start','var')==0, exist('fin','var')==0)
                plot(obj.time, obj.signal); 
            else
                error("Bad arguments.")
            end
            grid on;
            xlabel("Time");
            ylabel("Data");
            title("Signal");
            hold off;
        end
        
        function obj = append(obj, sig, time)
            obj.time = [obj.time, time];
            obj.signal = [obj.signal, sig];
        end
    
        function signal = subsignal(obj, start, fin)
           signal = Signal(obj.signal(start+1:fin+1), obj.time(start+1:fin+1)); 
        end
        
        function [mu, deviation] = statistics (obj)
            sum = 0;
            sumsq = 0;
            for i =1:length(obj.signal)
                sum = sum + obj.signal(i);
                sumsq = sumsq + obj.signal(i)^2;
            end
            
            mu = sum/length(obj.signal);
            deviation = sqrt((1/(length(obj.signal)-1))*(sumsq-((sum^2/length(obj.signal)))));
        end
        
        function obj = times(obj, vegades)
            obj.signal = obj.signal*vegades;            
        end
        
        function obj = plus(obj, b)
            if isa(b, 'Signal')
                obj.signal = obj.signal+b.signal;            
            else
                obj.signal = obj.signal+b
            end
        
        end
    end
end

