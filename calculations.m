% Function that will calculate mean, std deviation of angular velocity during a turn

function calculation_data = calculations(fileData)

    % Data extraction
    num_trials = size(fileData, 1);
    %Count amount of 'DT' and 'ST' in 'Type' Column
    num_ST = sum(strcmp(fileData(:,3), 'ST'));
    num_DT = sum(strcmp(fileData(:,3), 'DT'));

    % Find max rows
    max_rows = max(num_ST, num_DT);

    % Preallocate empty cell
    angular_velocity_trunk_single_task = zeros(max_rows, 1);
    angular_velocity_lumbar_single_task = zeros(max_rows, 1);
    angular_velocity_trunk_dual_task = zeros(max_rows, 1);
    angular_velocity_lumbar_dual_task = zeros(max_rows, 1);

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
    
    % Matlab will throw an error unless there are the same amount of rows
    
    % Find the index of the first non-zero
    index_non_zero_lumbar_single_task = find(angular_velocity_lumbar_single_task(:, 1) ~=0);
    index_non_zero_lumbar_dual_task = find(angular_velocity_lumbar_dual_task(:, 1) ~=0);
    index_non_zero_trunk_single_task = find(angular_velocity_trunk_single_task(:, 1) ~=0);
    index_non_zero_trunk_dual_task = find(angular_velocity_trunk_dual_task(:, 1) ~=0);
    % Set new matrix
    angular_velocity_lumbar_single_task = angular_velocity_lumbar_single_task(index_non_zero_lumbar_single_task, :);
    angular_velocity_lumbar_dual_task = angular_velocity_lumbar_dual_task(index_non_zero_lumbar_dual_task, :);
    angular_velocity_trunk_single_task = angular_velocity_trunk_single_task(index_non_zero_trunk_single_task, :);
    angular_velocity_trunk_dual_task = angular_velocity_trunk_dual_task(index_non_zero_trunk_dual_task, :);
    % Pad out matrix
    angular_velocity_lumbar_single_task = padarray(angular_velocity_lumbar_single_task, [max_rows - size(angular_velocity_lumbar_single_task, 1), 0], 0, 'post');
    angular_velocity_lumbar_dual_task = padarray(angular_velocity_lumbar_dual_task, [max_rows - size(angular_velocity_lumbar_dual_task, 1), 0], 0, 'post');
    angular_velocity_trunk_single_task = padarray(angular_velocity_trunk_single_task, [max_rows - size(angular_velocity_trunk_single_task, 1), 0], 0, 'post');
    angular_velocity_trunk_dual_task = padarray(angular_velocity_trunk_dual_task, [max_rows - size(angular_velocity_trunk_dual_task, 1), 0], 0, 'post');
    % Combine matrix
    final_matrix = [angular_velocity_lumbar_single_task, angular_velocity_lumbar_dual_task, angular_velocity_trunk_single_task, angular_velocity_trunk_dual_task];
    

    % Remove empty cells and add our new max arrays into our calc structure
    final_matrix(final_matrix == 0) = NaN;

    % Labels for each column
    column_labels = {'Lumbar Single Task', 'Lumbar Dual Task',  'Trunk Single Task', 'Trunk Dual Task' };
    % Create cell with data and labels
    labeled_max_data = cell(1,2);
    labeled_max_data{1} = final_matrix;
    labeled_max_data{2} = column_labels;
    
    % Troubleshooting
    calculation_data = labeled_max_data;
    
    
    
end





