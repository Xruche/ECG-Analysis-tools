
%Programa para representar un ECG

load Electrocardiogram
%% Para utilizar programas .dat propios

% NO FUNCIONA

%fid = fopen('rec_1.dat'); 
%A = fread(fid);
%ecg = A(1:2:length(A))/100;
%% Si quieres descargarte directamente un ECG de internet (Poner link)

file = 'http://people.ucalgary.ca/~ranga/enel563/SIGNAL_DATA_FILES/ecgpvc.dat';
ecg_string = urlread(file);
whos
ecg = str2num(ecg_string);
%% Mostrar los picos de ECG

plot(ecg)
axis ([3000 3800 1500 2800])
grid on

peaks_1 = ecg>2400;
time = (1:numel(ecg))/200;
plot(time,ecg,'b',time,2600*(peaks_1),'ro')
axis ([15 20 1500 2800])
%% Detectar picos y mostrarlos por pantalla

axis ([16.4 17.2 2000 2800])

[peaks_2,pos_peaks] = findpeaks(ecg);
plot(time,ecg,'b',pos_peaks/200,(peaks_2),'ro')
axis ([15 17 1500 2800])
%% Refinado de los picos

[peaks_2,pos_peaks] = findpeaks(ecg,'MINPEAKHEIGHT',2400);
plot(time,ecg,'b',pos_peaks/200,(peaks_2),'ro')
axis ([20 23 1500 3300])
[peaks_2,pos_peaks] = findpeaks(ecg,'MINPEAKDISTANCE',10,'MINPEAKHEIGHT',2400);
plot(time,ecg,'b',pos_peaks/200,(peaks_2),'ro')
axis ([20 23 1500 3300])

%% Añadir gráfico con la diferencia de tiempo entre picos

subplot(211)
plot(time,ecg,'b',pos_peaks/200,(peaks_2),'ro')
grid on
axis tight
ylabel ('ECG','fontsize',16)
subplot(212)
plot(time(pos_peaks(2:end)), 60*diff(pos_peaks/200));axis tight
grid on
axis tight
ylabel ('Heart Rate','fontsize',16)
xlabel ('Time (seconds)','fontsize',16)