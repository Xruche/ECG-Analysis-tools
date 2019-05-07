total = [];
files = [100,101,102,103,104,105,106,107,108,109,111,112,113,114,115,116,117,118,119,121,122,123,124,200,201,202,203,205,207,208,209,212,213,214,215,217,219,220,221,222,223,228,230,231,232,233,234];
for i=1:length(files)
    filename = [num2str(files(i)),'.dat'];
    f = fopen(filename, 'r');
    a = fread(f, 'ubit12');
    a = a(1:2:length(a))/100;
    time = 0:1/360:(length(a)/360)-1/360;
    signal = ECGsignal(a', time);
    taco = signal.tacogram;
    new = taco.stats;
    
    total = [total; new];
end
