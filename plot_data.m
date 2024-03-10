function plot_data(struct, color, title_str)
% struct should be our calculated data (calc struct)
    
    % Extract data from cell
    data = struct{1};
    column_labels = struct{2};
    % Plot each column as a seperate box plot on the same graph
    boxplot(data, 'Labels', column_labels)
    
    xlabel('Trial Type');
    ylabel('Angular Velocity');
    title('Title');
    grid on;
    
end