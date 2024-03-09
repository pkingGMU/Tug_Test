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

%% **************Select Directory******************************************
% Import using parent directory
% Prompt user to select parent directory
parentDirectory = uigetdir('Select the parent directory that contains the dual task and single task folder');

% Check if the user canceled the dialog
if parentDirectory == 0
    disp('User canceled the operation.');
    return;
end

% Get a list of files in the subdirectories
% Get our files from the DT directory
DT_dir = dir(fullfile(parentDirectory, 'DT', '*.h5'));  
% Get our files from the ST directory
ST_dir = dir(fullfile(parentDirectory, 'ST', '*.h5')); 
% All files
allFiles = [DT_dir; ST_dir];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fileData = cell(numel(allFiles), 3); % Each row contains {filename, data, source}

for i = 1:numel(allFiles)
    clear data filename trunk lumbar head lfoot rfoot Fs cIndex offsetA offsetV nDevices iSamples
    start = 1;
    filename = fullfile(allFiles(i).folder, allFiles(i).name);
    % Read data from file (example: assuming data is stored in variable 'data')
    % read data;
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
    
    % Extract just the filename and extension
    [~, filename, ext] = fileparts(filename);

    % Store Data
    fileData{i, 2} = turn;

    % Store our file name
    fileData{i, 1} = [filename, ext];

    % Determine source directory
    if contains(allFiles(i).folder, 'DT')
        % Data comes from subdir1
        fileData{i, 3} = 'DT';
    elseif contains(allFiles(i).folder, 'ST')
        % Data comes from subdir2
        fileData{i, 3} = 'ST';
    end
end




%data = readOpalData_v2('TUG.h5');

%Fs = data.sampleRate;

%aligned_opals = alignOpals(data,Fs);


