#!/bin/bash

# This script builds a single LaTeX module.

# Get the directory name as the PDF name.
MODULE_NAME=$(basename "$(pwd)")

# Check for a --verbose argument passed to this script.
VERBOSE_OUTPUT=false
if [[ "$1" == "--verbose" ]]; then
    VERBOSE_OUTPUT=true
    echo "  [Module: $MODULE_NAME] Verbose output enabled for xelatex."
fi

# Clear the output directory.
mkdir -p out
rm -f out/*.pdf
rm -f out/*.log

# Define the log file path
LOG_FILE="out/${MODULE_NAME}.log"

# Compile the module with the directory name as output.
# If VERBOSE_OUTPUT is true, xelatex output is shown directly.
# Otherwise, xelatex output is redirected to a log file, and then
# only lines containing "Warning" or "Error" are displayed from the log.
if [ "$VERBOSE_OUTPUT" = true ]; then
    echo "  [Module: $MODULE_NAME] Compiling module.tex (full output)..."
    xelatex -output-directory=out -jobname="$MODULE_NAME" module.tex
    # Run xelatex twice for proper cross-referencing, etc.
    xelatex -output-directory=out -jobname="$MODULE_NAME" module.tex
else
    echo "  [Module: $MODULE_NAME] Compiling module.tex (warnings/errors only)..."
    # Run xelatex, redirecting all output to the log file.
    # Use -interaction=nonstopmode to prevent xelatex from pausing on errors.
    xelatex -interaction=nonstopmode -output-directory=out -jobname="$MODULE_NAME" module.tex > "$LOG_FILE" 2>&1
    # Run xelatex a second time, also redirecting output to the log file.
    xelatex -interaction=nonstopmode -output-directory=out -jobname="$MODULE_NAME" module.tex >> "$LOG_FILE" 2>&1

    # Now, filter the log file for warnings and errors and display them.
    # -i for case-insensitive, -E for extended regex (for |), --color=always for highlighting
    # This pattern now includes:
    # - Lines starting with '!' (for errors)
    # - Lines starting with 'LaTeX Warning:'
    # - Lines starting with 'Package <name> Warning:'
    # - Lines containing 'Overfull \\hbox' or 'Underfull \\hbox'
    # It EXCLUDES lines containing 'requested document class'
    WARNINGS_AND_ERRORS=$(grep -E -i -e '^!|^LaTeX Warning:|^Package .* Warning:|Overfull \\hbox|Underfull \\hbox' "$LOG_FILE" | grep -v 'requested document class' --color=always)

    if [ -n "$WARNINGS_AND_ERRORS" ]; then
        echo "  [Module: $MODULE_NAME] Detected Warnings/Errors:"
        echo "$WARNINGS_AND_ERRORS"
    fi
fi

# Check the exit status of the last xelatex command.
# Note: The exit status will be based on the xelatex run, not the grep command.
if [ $? -eq 0 ]; then
    echo "  [Module: $MODULE_NAME] Module compiled successfully to out/${MODULE_NAME}.pdf"
else
    echo "  [Module: $MODULE_NAME] Error: Module compilation failed for ${MODULE_NAME}.pdf"
    echo "  [Module: $MODULE_NAME] Check the full log file '$LOG_FILE' for details."
fi
