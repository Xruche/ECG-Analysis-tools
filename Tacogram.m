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
        
        function obj = Tacogram(signal, time)
               if and(exist('signal', 'var'),exist('time', 'var'))
                obj.signal = signal;
                obj.time = time;
                obj.bpm = (signal.^-1)*60;
            elseif xor(exist('signal', 'var'),exist('time','var'))
                error("Bad argument for signal generation, provide (signal, time) array or none");
            else
                obj.signal = [];
                obj.time = [];
                obj.bpm = [];
               end
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
            s = obj.stats();
            mu = s(1,1);
            new_sig = obj.signal-(mu/1000);
            %plot(obj.time, new_sig);
            Fs = 20;
            per = 1/Fs;
            t = 0:per:obj.time(end);
            interp = spline(obj.time, new_sig, t);
            wind = hann(length(t));
            [pxx,w]=pwelch(interp,wind,[],[],Fs);
            plot(w,pxx);
            xlabel('Frequencia (Hz)');
            ylabel('PSD (ms^2)');
            title('Analisi espectral');
            xlim([0,0.5]);
            vline(0.4,'k','');
            vline(0.15,'k','HF');
            vline(0.04,'k','LF');
            vline(0.003,'k','VLF');
            trapz(w, pxx)*1000000
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
                    if obj.time(j+1)>(5*60*interval)
                        interval_end = j-1;
                        break;
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
            title("R-R interval histogram");
            xlabel ("Duration of R-R interval (ms)");
            ylabel ("Number of counts")
            HRV = length(rr)/max(hist.Values);
            SD1 =sqrt(0.5*SDSD^2);
            SD2 = sqrt(2*SDNN^2-0.5*SDSD^2);
            data = [mu,SDNN,SDANN,RMSSD,SDDNindex,SDSD,NN50,pNN50,HRV,SD1, SD2];
        end
    end
end

