% Function that will calculate mean, std deviation of angular velocity during a turn

function calculation_data = calculations(fileData)

    % Data extraction
    num_trials = size(fileData, 1);
    % Preallocate empty cell
    angular_velocity_trunk_single_task = zeros(num_trials, 1);
    angular_velocity_lumbar_single_task = zeros(num_trials, 1);
    angular_velocity_trunk_dual_task = zeros(num_trials, 1);
    angular_velocity_lumbar_dual_task = zeros(num_trials, 1);

    % Loop through each trial
    for trial = 1:num_trials
        % Get data from fileData
        trial_name = fileData{trial, 1};
        trial_data = fileData{trial, 2};
        task_type = fileData{trial, 3};

        % Get angular velocities
        if contains(task_type, 'ST')
            angular_velocity_trunk_single_task(trial) = trial_data.Pk_TurnV_Trunk;
            angular_velocity_lumbar_single_task(trial) = trial_data.Pk_TurnV_Lumbar;
        elseif contains(task_type, 'DT')
            angular_velocity_trunk_dual_task(trial) = trial_data.Pk_TurnV_Trunk;
            angular_velocity_lumbar_dual_task(trial) = trial_data.Pk_TurnV_Lumbar;
        end
    end

    % Bombine matrix
    raw_task = [angular_velocity_lumbar_single_task, angular_velocity_lumbar_dual_task, angular_velocity_trunk_single_task, angular_velocity_trunk_dual_task];
    

    % Remove empty cells and add our new max arrays into our calc structure
    raw_task(raw_task == 0) = NaN;

    % Labels for each column
    column_labels = {'Lumbar Single Task', 'Lumbar Dual Task',  'Trunk Single Task', 'Trunk Dual Task' };
    % Create cell with data and labels
    labeled_max_data = cell(1,2);
    labeled_max_data{1} = raw_task;
    labeled_max_data{2} = column_labels;
    
    % Troubleshooting
    calculation_data = labeled_max_data;
    
    
    
end





