# Read all csv files that contain timing duration
# Pull Sit-Stand, turn, Total Duration
# Calculate Walking timing
# Calculate proportion of these timings to the final time
# Compare Single to Dual Task

# Imports
import tkinter as tk
from tkinter import filedialog
import os
import pandas as pd
import numpy as np

# Initialize variables
data = []

# Dialog prompt to open parent directory
def select_directory():
    root = tk.Tk()
    root.withdraw()
    folder_path = filedialog.askdirectory(title='Select parent directory')
    if folder_path:
        subdirs = [name for name in os.listdir(folder_path) if os.path.isdir(os.path.join(folder_path, name))]
        return folder_path, subdirs
    
def read_csv_file(parent_dir, subdirs):

    specific_rows = [13, 14, 21]

    for subdir in subdirs:
        subdir_path = os.path.join(parent_dir, subdir)
        for file in os.listdir(subdir_path):
            if file.endswith(".csv"):
                file_path = os.path.join(subdir_path, file)
                print (f"Reading file: {file}")

                # Read contents of each csv
                df = pd.read_csv(file_path, header=None, skiprows=lambda x: x not in specific_rows)
                df.reset_index()
                
                # Values of the cells we are extracting
                total_tug_time = df.iloc[0,3] # Zero index 
                sit_stand_time = df.iloc[1,3] # Zero index 
                turn_time = df.iloc[2,3] # Zero index

                # Calculate proportions
                sit_stand_proportion = sit_stand_time/total_tug_time
                turn_proportion = turn_time/total_tug_time
                
                # Append our data
                if subdir == 'DT':
                    data.append({'Trial': file, 
                                 'Total Time': total_tug_time, 
                                 'Sit To Stand Time': sit_stand_time, 
                                 'Turn Time': turn_time, 
                                 'Sit Stand Proportion': sit_stand_proportion, 
                                 'Turn Proportion': turn_proportion,
                                 'Straight Walking Time': [], 
                                 'Type': 'DT'})
                else:
                    data.append({'Trial': file, 
                                 'Total Time': total_tug_time, 
                                 'Sit To Stand Time': sit_stand_time, 
                                 'Turn Time': turn_time, 
                                 'Sit Stand Proportion': sit_stand_proportion, 
                                 'Turn Proportion': turn_proportion,
                                 'Straight Walking Time': [], 
                                 'Type': 'ST'})
    df2 = pd.DataFrame(data)
    return df2



# Function to run our calculations
def calculate(dataframe):
    if 
    for column in dataframe.columns:
        if np.issubdtype(dataframe[column].dtype, np.number):
            mean_value = dataframe[column].mean()
            dataframe.loc['mean', column] = mean_value
    return dataframe

def write_to_excel(data):
        # Create data frame from results                
    df3 = pd.DataFrame(data)

    # Ask the user to specify name and file location for excel file
    excel_file_path = filedialog.asksaveasfilename(defaultextension='.xlsx', filetypes=[("Excel files", "*.xlsx")])

    # Create a writer object to be able to use xlsxwriter
    writer = pd.ExcelWriter(excel_file_path, engine='xlsxwriter')
    # Create mandatory sheet for our dataframe
    df3.to_excel(writer, index=False, sheet_name='report')
    workbook = writer.book
    worksheet = writer.sheets['report']

    #Close writer object
    writer.close()
    print("Excel Saved Success")
    


def main():
    diretory_info = select_directory()
    if diretory_info:
        parent_dir, subdirs = diretory_info
        info = read_csv_file(parent_dir, subdirs)
        calculated = calculate(info)
        write_to_excel(calculated)


    
    # Create a


if __name__ == '__main__':
    main()        
