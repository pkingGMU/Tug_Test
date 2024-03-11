# Read all csv files that contain timing duration
# Pull Sit-Stand, turn, Stand-Sit, Total Duration
# Calculate Walking timing
# Calculate proportion of these timings to the final time
# Compare Single to Dual Task

# Imports
import tkinter as tk
from tkinter import filedialog
import os
import pandas as pd

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
                df = pd.read_csv(file_path, skiprows=lambda x: x not in specific_rows)
                df.reindex()
                print (df)
                # Values of the cells we are extracting
                total_tug_time = df.iloc[0,3] # Zero index D14
                # print(total_tug_time)
    print (total_tug_time)




def main():
    diretory_info = select_directory()
    if diretory_info:
        parent_dir, subdirs = diretory_info
        read_csv_file(parent_dir, subdirs)


if __name__ == '__main__':
    main()        
