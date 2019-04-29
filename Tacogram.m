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
        bpm =[]
    end
    
    methods   
        
        function obj = Tacogram()
                obj.signal = []; % valors del interval rr (segons)
                obj.time = [];   % valors de temps en el que es produeix el batec (el primer batec s'ignora al no poder calcular el temps entre batecs)
                obj.bpm = [];    % valors de bpm en batecs/minut
        end
        
        function new = subsignal(obj, start, fin)
            new = subsignal@Signal(obj,start,fin); 
        end
        
        function new = poincarePlot(obj,n)
        x = [obj.signal(n+1:length(obj.signal)), obj.signal(1:n)]; 
        new = PoincarePlot(obj.signal, x);
        end
        
        function obj = append(obj, bpm, time, rr)
            obj.bpm = [obj.bpm, bpm];
            obj.time = [obj.time, time];
            obj.signal = [obj.signal, rr];
        end
        
        function represent(obj)
            t = obj.time-obj.time(1);
            plot(t,obj.signal*1000);
            xlabel('Time (seconds)');
            ylabel('R-R interval (ms)');
        end
        
        function represent_bpm(obj)
            t = obj.time-obj.time(1);
            plot(t,obj.bpm);
            xlabel('Time (seconds)');
            ylabel('Heart rate (bpm)');
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
        
        function data = stats(obj)
            
            %% Calcul dels intervals rr
            
            rr = [];
            for i=2:length(obj.time)
                rr = [rr, (obj.time(i)-obj.time(i-1))*1000];
            end
            
            %% Variables estadistiques
            rr_dif = rr(2:end)-rr(1:end-1);
            NN50 = sum(rr_dif>50);
            mu = mean(rr);
            SDNN = std(rr);
            SDSD = std(rr_dif);
            pNN50 = NN50/length(rr);
            RMSSD = sqrt(sum(rr_dif.^2)/length(rr_dif));
            %% Variables en intervalos de 5 min
            number_intervals = floor(obj.time(end)/(5*60));
            interval = 1;
            interval_start =0;
            interval_end =0;
            interval_sum =0;
            inteval_sqsum =0;
            deviations = [];
            means = [];
            for i =1:number_intervals-1
                interval_start = interval_end+1;
                for j=1:(length(obj.time)-1)
                    if obj.time(j+1)>5*60*interval
                        interval_end = j-1;
                    end
                end
                interval = interval + 1;
                A = rr(interval_start:interval_end);
                means = [means, mean(A)];
                deviations = [deviations, std(A)];
            end
            SDANN = std(means);
            SDDNindex = mean (deviations);

            
            %% Variables geometriques
            edges = [min(rr):(1/128)*1000:max(rr)+(1/128)*1000];
            hist = histogram(rr, edges);
            HRV = length(rr)/max(hist.Values);
            
            data = [mu,SDNN,SDANN,RMSSD,SDDNindex,SDSD,NN50,pNN50,HRV];
        end
    end
end

