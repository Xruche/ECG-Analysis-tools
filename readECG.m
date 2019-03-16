function signal = readECG()
%readECG function : returns a signal object with the data at the selected
%file.
%   Detailed explanation goes here
[filename, pathname] = uigetfile('*.dat', 'Open file .dat');
if xor(isequal(filename, 0), isequal(pathname, 0))
    error("Bad file selection");
else
    f = fopen(filename, 'r');
    a = fread(f, 'ubit12');
    a = a(1:2:length(a))/100;
    time = 0:1/360:(length(a)/360)-1/360;
    signal = ECGsignal(a', time);
end
end

