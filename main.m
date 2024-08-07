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
import calculations.*
import plot_data.*
import Write_TUG_CSV.*

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
        
        %% ============ SELECT FOOT, LUMBAR, TRUNK, HEAD IMU =========%
        % Switch case to get the correct structures from the monitor labels
        for n = 1:length(data.sensor)
            switch true
                case contains(data.sensor(n).monitorLabel, {'Trunk', 'Sternum'})
                    trunk = struct(data.sensor(n));
                case contains(data.sensor(n).monitorLabel, 'Lumbar')
                    lumbar = struct(data.sensor(n));
                case contains(data.sensor(n).monitorLabel, {'Head', 'Forehead', 'ForeHead'})
                    head = struct(data.sensor(n));
                case contains(data.sensor(n).monitorLabel, 'Right Foot')
                    rfoot = struct(data.sensor(n));
                case contains(data.sensor(n).monitorLabel, 'Left Foot')
                    lfoot = struct(data.sensor(n));
            end
        end
     end
    

    %turn.Pk_TurnV_Head(ind) = max(abs(head.rotation(:,3)));
    turn.Pk_TurnV_Trunk = max(abs(trunk.rotation(:,3)));
    turn.Pk_TurnV_Lumbar = max(abs(lumbar.rotation(:,3)));
    
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

% Troubleshooting
calc.labeled_max_data = calculations(fileData);

% Plotting raw data
plot_data(calc.labeled_max_data)
%% 

% Plotting raw data as Violin Plot
subplot(1,2,1)
violin(calc.labeled_max_data{1}(:,[1,2]))
xlabel('Task Type');
ylabel('Turning Speed (deg/s)');
title('Peak Turning Speed');
grid on;
% Set y-axis limits to start at 0
ylim([0 1000]);

subplot(1,2,2)
violin(calc.labeled_max_data{1}(:,[3,4]))
xlabel('Task Type');
ylabel('Turning Speed (deg/s)');
title('Peak Turning Speed');
grid on;
% Set y-axis limits to start at 0
ylim([0 1000]);


%%

% THIS IS THE WORKING GRAPH CODE. RUN AS SECTION AFTER RUNNING THE FULL
% SCRIPT
fig = figure();
groups = [ones(37,1); 2*ones(37,1)];  % Group 1 labeled as 1, Group 2 labeled as 2
colors = [0 0.4 0.2; 1 0.8 0.2];

Y = [calc.labeled_max_data{1}(:,1), calc.labeled_max_data{1}(:,2)];

column_labels = calc.labeled_max_data{2};
csubset2 = column_labels(:, [1,2]);
Violin_Processing(mat2cell(Y, size(Y, 1), ones(1, size(Y, 2))), 'violinalpha', .7, 'colors', colors, 'groups', groups, 'scattercolors', [0, 0, 0], 'violin', 'full', 'box', 0, 'scatter', 2, 'linkline', 1, 'withinlines', 1, 'xtlabels', csubset2)
xlabel('Task Type');
ylabel('Turning Speed (deg/s)');
title('Peak Turning Speed');

grid off;
% Set y-axis limits to start at 0
ylim([0 500]);
fontsize(fig, 40, "points")


%% 


% Excel file
Write_TUG_CSV(calc.labeled_max_data{1}, calc.labeled_max_data{2}, 'TUG_Data_CSV.csv');





