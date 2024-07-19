# App Modules Assistor

App Modules Assistor is an interactive decision-making tool that guides users through a flowchart to determine whether certain functionalities should be included as app modules. The tool poses a series of yes/no questions and navigates through different steps based on user responses.

## What the App Does

When you open `index.html`, you will be presented with a series of questions related to assessing if certain areas should be part of an app module. By clicking "YES" or "NO", you navigate through various steps until reaching a final conclusion. If needed, you can reset and start over from the beginning.

## How to Build It

### For Mac/Linux Users:

To package this application into a zip file, follow these steps:

1. Ensure you have the necessary permissions to execute shell scripts:
   ```bash
   chmod +x build.sh
   ```

2. Run the `build.sh` script:
   ```bash
   ./build.sh
   ```

3. The script will create a directory named `target` (if it doesn't already exist) and place a zip file named `AppModulesAssistor.zip` in it containing all project files.

### For Windows Users:

To package this application into a zip file, follow these steps:

1. Open Command Prompt.

2. Run the `build.cmd` script:
   ```cmd
   build.cmd
   ```

3. The script will create a directory named `target` (if it doesn't already exist) and place a zip file named `AppModulesAssistor.zip` in it containing all project files.


## How to Upload It

### For Mac/Linux Users:

To upload the zip file to the Octane instance that runs at http://localhost:8080/dev, follow these steps:

1. Ensure you have the necessary permissions to execute shell scripts:
   ```bash
   chmod +x upload.sh
   ```

2. Run the `upload.sh` script:
   ```bash
   ./upload.sh
   ```

### For Windows Users:

To upload the zip file to the Octane instance that runs at http://localhost:8080/dev, follow these steps:

1. Open Command Prompt.

2. Run the `upload.cmd` script:
    ```cmd
    upload.cmd
    ```
