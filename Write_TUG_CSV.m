function Write_TUG_CSV(matrix_data, header_data, filename)
% WRITE_TUG_CSV
% Take matrix calc and write to csv
    % Write matrix to csv
    writematrix(matrix_data, filename);

    % Read CSV to append headers
    csv_content = fileread(filename);

    % Prepend header line to CSV
    csv_with_headers = [strjoin(header_data, ','), newline, csv_content];

    % Write back to file
    fid = fopen(filename, 'w');
    fprintf(fid, '%s', csv_with_headers);
    fclose(fid);

    % Confirmation
    disp('Excel File Success')
end

