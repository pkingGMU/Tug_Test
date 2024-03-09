import readOpalData_v2.*

data = readOpalData_v2('TUG.h5');

Fs = data.sampleRate;

%aligned_opals = alignOpals(data,Fs);
