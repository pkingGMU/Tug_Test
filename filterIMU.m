function filt_data = filterIMU(data,order,Fc,Fs)
% Filters[data] data using butterworth filter with specified [order] order,
% [Fc] cuttoff frequency and [Fs] sampling frequency.
[b,a] = butter(order/2,(Fc/(Fs/2)));
filt_data = filtfilt(b,a,data);
end