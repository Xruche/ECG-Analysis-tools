function signal = RandomGenerator(start, duration, period, amplitude)
%Generates a random signal with specified parameters
t = start:period:start+duration;
sig = rand(1,length(t))*amplitude;
signal = Signal(sig, t);
end

