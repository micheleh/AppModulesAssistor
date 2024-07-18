#!/bin/bash

# Enable echoing of commands
#set -x

source_dir="src"
zip_file="AppModulesAssistor.zip"
target_dir="target"

mkdir -p "$target_dir"

# Change to the source directory
cd "$source_dir" || exit 1

# Create the zip file from the contents of the source directory, without including the src directory itself
zip -r "../$target_dir/$zip_file" ./*

# Return to the original directory (optional)
cd -

# List all files in the zip file including their saved path using unzip command
#unzip -l "$target_dir/$zip_file"
