#!/bin/bash

# This script iterates through module directories and executes their build.sh files.

# Define the path to the modules directory relative to the project root.
MODULES_DIR="src/tex/modules"

# Check if the modules directory exists.
if [ ! -d "$MODULES_DIR" ]; then
    echo "Error: Modules directory '$MODULES_DIR' not found."
    echo "Please ensure your project structure is 'project_root/src/tex/modules/'"
    exit 1
fi

echo "Starting module builds..."
echo "-----------------------------------"

# Navigate into the modules directory.
# Using pushd/popd ensures we return to the original directory after processing.
pushd "$MODULES_DIR" > /dev/null || { echo "Failed to change directory to $MODULES_DIR"; exit 1; }

# Iterate over each subdirectory (module folder) in the modules directory.
# The '*/' pattern ensures we only match directories.
for module_dir in */; do
    # Remove the trailing slash to get the clean directory name.
    module_name="${module_dir%/}"

    echo "Processing module: $module_name"

    # Check if the module directory actually exists (in case of weird globbing).
    if [ -d "$module_name" ]; then
        # Navigate into the specific module directory.
        pushd "$module_name" > /dev/null || { echo "Failed to change directory to $module_name"; continue; }

        # Define the path to the build script within the module.
        BUILD_SCRIPT="build.sh"

        # Check if the build script exists and is executable.
        if [ -f "$BUILD_SCRIPT" ] && [ -x "$BUILD_SCRIPT" ]; then
            echo "  Executing ./$BUILD_SCRIPT for $module_name..."
            ./"$BUILD_SCRIPT"
            # Check the exit status of the module's build script.
            if [ $? -ne 0 ]; then
                echo "  Warning: Build script for $module_name failed or exited with an error."
            fi
        elif [ -f "$BUILD_SCRIPT" ]; then
            echo "  Warning: './$BUILD_SCRIPT' found for $module_name, but it is not executable. Skipping."
        else
            echo "  No './$BUILD_SCRIPT' found in $module_name. Skipping."
        fi

        # Return to the modules directory.
        popd > /dev/null
        echo "-----------------------------------"
    else
        echo "  Warning: Directory '$module_name' not found or is not a directory. Skipping."
        echo "-----------------------------------"
    fi
done

# Return to the original project root directory.
popd > /dev/null

echo "All module builds attempted."
echo "-----------------------------------"
echo "Script finished."
