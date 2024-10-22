import os, shutil
path = r"/Users/home/Documents/Fake file for project/"  # / required

# Create folder, identify files, then create folder and place into there
file_names = os.listdir(path)

folder_names = ["csv files", "image files", "text files"]
for loop in range(0, 3):
    if not os.path.exists(path + folder_names[loop]):
        os.makedirs((path + folder_names[loop]))

# Track if any files were moved
files_moved = False

for file in file_names:
    if ".csv" in file and not os.path.exists(path + "csv files/" + file):
        shutil.move(path + file, path + "csv files/" + file)
        files_moved = True
    elif ".PNG" in file and not os.path.exists(path + "image files/" + file):
        shutil.move(path + file, path + "image files/" + file)
        files_moved = True
    elif ".rtf" in file and not os.path.exists(path + "text files/" + file):
        shutil.move(path + file, path + "text files/" + file)
        files_moved = True

# Check if any files were moved
if files_moved:
    print("Files were moved successfully.")
else:
    print("There were files in this path that were not moved.")