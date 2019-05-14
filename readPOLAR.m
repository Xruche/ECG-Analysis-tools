function signal = readPOLAR()
%readECG function : returns an ECGsignal object with the data at the selected
%file.

[filename, pathname] = uigetfile('*.txt', 'Open file .dat');
if xor(isequal(filename, 0), isequal(pathname, 0))
    error("Bad file selection");
else
    data = readtable(filename);
    signal = Tacogram(table2array(data(:,2))',table2array(data(:,1))');
end
end
