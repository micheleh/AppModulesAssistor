@echo off

set "source_dir=src"
set "zip_file=AppModulesAssistor.zip"
set "target_dir=target"

:: Create target directory if it doesn't exist
if not exist "%target_dir%" (
    mkdir "%target_dir%"
)

:: Change to the source directory
cd /d "%source_dir%" || exit /b 1

:: Create the zip file from the contents of the source directory, without including the src directory itself
powershell -Command "Compress-Archive -Path * -DestinationPath ../%target_dir%/%zip_file%"

:: Return to the original directory (optional)
cd -