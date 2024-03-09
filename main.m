clear all
close all
clc

%% Add path but our test one is included for now
%% addpath('PATH');

%% Imports
import readOpalData_v2.*
import filterIMU.*
import RotateAcc.*
import RotateVector.*



start = 1;

clear data filename trunk lumbar head lfoot rfoot Fs cIndex offsetA offsetV nDevices iSamples
filename = 'Tug.h5';
data = readOpalData_v2(filename);
Fs = data.sampleRate;

%% ========== ALIGN IMU AXES WITH GLOBAL FRAME AND FILTER ============ %%
data = alignOpals(data,Fs);
iSamples = 1:length(data.time);
nDevices = length(data.sensor);
if ~isempty(data.time)
    
    for cDevice = 1:nDevices
        %fiter data
        data.sensor(cDevice).acceleration = filterIMU(data.sensor(cDevice).acceleration,4,6,Fs);
        
        %             [data.sensor(cDevice).acceleration] = rotateIMU(acc, 4, 10, Fs);
        %             [data.sensor(cDevice).acceleration50Hz] = rotateIMU(acc, 4, 50, Fs);
        
    end
    
    %% ============ SELECT FOOT, LUMBAR, TRUNK, HEAD IMU =========%%
    for n=1:length(data.sensor)
        if contains(data.sensor(n).monitorLabel,'Trunk') || contains(data.sensor(n).monitorLabel,'Sternum');
            trunk = struct(data.sensor(n));
        else if contains(data.sensor(n).monitorLabel,'Lumbar');
                lumbar = struct(data.sensor(n));
            else if contains(data.sensor(n).monitorLabel,'Head') || contains(data.sensor(n).monitorLabel,'ForeHead') || contains(data.sensor(n).monitorLabel,'Head') || contains(data.sensor(n).monitorLabel,'Forehead');
                    head = struct(data.sensor(n));
                else if contains(data.sensor(n).monitorLabel,'Right Foot');
                        rfoot = struct(data.sensor(n));
                    else if contains(data.sensor(n).monitorLabel,'Left Foot');
                            lfoot = struct(data.sensor(n));
                        end
                    end
                end
            end
        end
    end
    
end
%turn.Pk_TurnV_Head(ind) = max(abs(head.rotation(:,3)));
turn.Pk_TurnV_Trunk(filename) = max(abs(trunk.rotation(:,3)));
turn.Pk_TurnV_Lumbar(filename) = max(abs(lumbar.rotation(:,3)));

disp(filename);



%data = readOpalData_v2('TUG.h5');

%Fs = data.sampleRate;

%aligned_opals = alignOpals(data,Fs);



