function signal = readMAT()
%readECG function : returns an ECGsignal object with the data at the selected
%file.

[filename, pathname] = uigetfile('*.mat', 'Open file .dat');
if xor(isequal(filename, 0), isequal(pathname, 0))
    error("Bad file selection");
else
    data = load(filename,'data');
    s = size(data.data);
    time = 0:0.001:(s(1)*0.001)-0.001;
    signal = ECGsignal(data.data(:,1)',time);
end
end
