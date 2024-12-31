import os
import shutil

# File paths
source_dir = r"C:\Users\kleskby\Documents\GitHub\Q.U.A.L.K.E.R\data"
dest_dir = r"C:\Users\kleskby\Documents\GitHub\Q.U.A.L.K.E.R\Release\data"
textures_file = "textures.txt"


try:
    # Read the file line by line
    with open(textures_file, 'r') as file:
        for line in file:
            # Strip whitespace and skip empty lines
            texture_path = line.strip()
            if not texture_path:
                continue

            # Construct full source and destination paths
            source_path = os.path.join(source_dir, texture_path)
            dest_path = os.path.join(dest_dir, texture_path)

            # Ensure the destination subdirectory exists
            os.makedirs(os.path.dirname(dest_path), exist_ok=True)

            # Copy the file
            if os.path.exists(source_path):
                shutil.copy2(source_path, dest_path)
                print(f"Copied: {source_path} to {dest_path}")
            else:
                print(f"File not found: {source_path}")

        	# Check and copy the _norm.png file if it exists
            norm_source_path = os.path.splitext(source_path)[0] + "_bump.png"
            norm_dest_path = os.path.splitext(dest_path)[0] + "_bump.png"
            if os.path.exists(norm_source_path):
                shutil.copy2(norm_source_path, norm_dest_path)
                print(f"Copied: {norm_source_path} to {norm_dest_path}")
            else:
                print(f"Normal map not found: {norm_source_path}")


            # norm_source_path = os.path.splitext(source_path)[0] + "_bump#.png"
            # norm_dest_path = os.path.splitext(dest_path)[0] + "_gloss.png"
            # if os.path.exists(norm_source_path):
            #     shutil.copy2(norm_source_path, norm_dest_path)
            #     print(f"Copied: {norm_source_path} to {norm_dest_path}")
            # else:
            #     print(f"Normal map not found: {norm_source_path}")

except Exception as e:
    print(f"An error occurred: {e}")
