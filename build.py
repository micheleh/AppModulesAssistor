import os
import zipfile


def create_zip_from_source(source_dir="src", zip_file="AppModulesAssistor.zip", target_dir="target"):
    # Save the current working directory
    original_directory = os.getcwd()

    # Create the target directory if it does not exist
    os.makedirs(target_dir, exist_ok=True)

    try:
        # Change to the source directory
        os.chdir(source_dir)

        # Create the zip file from the contents of the source directory, without including the src directory itself
        with zipfile.ZipFile(f"../{target_dir}/{zip_file}", 'w', zipfile.ZIP_DEFLATED) as zipf:
            for root, dirs, files in os.walk("."):
                for file in files:
                    file_path = os.path.join(root, file)
                    arcname = os.path.relpath(file_path, ".")
                    zipf.write(file_path, arcname)

    finally:
        # Return to the original directory regardless of success or failure
        os.chdir(original_directory)


if __name__ == "__main__":
    create_zip_from_source()
