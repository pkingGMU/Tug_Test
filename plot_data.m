function plot_data(struct, color, title_str)
% struct should be our calculated data (calc struct)
    
    % Extract data from cell
    data = struct{1};
    column_labels = struct{2};
    % Plot each column as a seperate box plot on the same graph
    subplot(1,2,1)
    subset1 = data(:, [1,2]);
    csubset1 = column_labels(:, [1,2]);
    boxplot(subset1, 'Labels', csubset1)

    xlabel('Task Type');
    ylabel('Turning Speed (deg/s)');
    title('Peak Turning Speed');
    grid on;

    % Set y-axis limits to start at 0
    ylim([0 1000]);

    subplot(1,2,2)
    subset1 = data(:, [3,4]);
    csubset1 = column_labels(:, [3,4]);
    boxplot(subset1, 'Labels', csubset1)
    
    xlabel('Task Type');
    ylabel('Turning Speed (deg/s)');
    title('Peak Turning Speed');
    grid on;

    % Set y-axis limits to start at 0
    ylim([0 1000]);
    
end