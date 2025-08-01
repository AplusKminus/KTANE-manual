# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a LaTeX-based manual for "Keep Talking and Nobody Explodes" bomb defusal game. The repository contains optimized LaTeX sources for a custom bomb defusal manual that streamlines module information and provides quicker solutions.

## Build Commands

This project uses XeLaTeX compilation (required for fontspec support):

```bash
# Render any individual module:
./src/tex/modules/<module_name>/build.sh

# Render all individual modules at once:
./build.sh

# Combine all rendered modules alphabetically into a single document (KTANE_manual.pdf)
./combine_modules.sh
```

## Important Instructions for Claude Code

**Always rebuild the PDF after making changes to LaTeX files:**

After any successful modification to `.tex` files, always run the corresponding build.sh of the edited module.

This ensures that all changes are properly reflected in the final PDF output and allows for immediate verification of the modifications.

## Code Architecture

### Directory Structure
- `src/tex/` - Main LaTeX source directory
  - `ktane-mod.cls` - Custom LaTeX class defining the manual's styling and layout
  - `modules/` - Individual module definitions
    - `0_intro/` - Introduction content
    - `00_explanation/` - General bomb defusal instructions and edgework
    - `button/` - Example module implementation
- `resources/` - Assets (fonts, images)

### Key Components

**Custom LaTeX Class (`ktane-mod.cls`)**:
- Defines custom document class with specialized styling
- Implements thumb marker/tab system for quick navigation
- Uses LaTeX3 syntax for advanced functionality
- Provides `module` environment for consistent module layout
- Handles typography with SpecialElite font and custom colors

**Module System**:
- Each module is implemented as a `module.tex` file in a `modules/` subdirectory
- Uses custom `module` environment with parameters:
  - `moduleName`: Full display name (e.g., "The Button")
  - `indexString`: Used for thumb marker sorting (e.g., "Button") -- this should also be the module path in lowercase to ensure correct alphabetical sorting!
  - `imageResource`: Path to module image
- Modules automatically get:
  - Proper section headers
  - Wrapped figure placement
  - Thumb marker positioning
  - Consistent formatting

**Thumb Marker System**:
- Alphabetical tabs on page edges for quick navigation
- Automatically positioned based on module `indexString`
- Different behavior for odd/even pages (left/right sides)
- Configurable through LaTeX3 variables

### Module Development

When adding new modules:
1. Create new directory in `src/tex/modules/`
2. Add `module.tex` file using the `module` environment
3. Include module images in the same directory
4. Copy the `build.sh` of any existing module to your module directory

The module environment expects:
- Configuration parameters in the first argument
- Introductory text in the second argument
- Module content in the environment body

### Styling and Layout

- Ragged right text alignment
- Custom color scheme for tables and highlights
- NiceTabular for complex table layouts with custom drawing

## Working with LaTeX

This codebase uses advanced LaTeX features:
- LaTeX3 syntax (`\ExplSyntaxOn/Off`)
- Custom environments and commands
- TikZ for custom graphics and table decorations
- fontspec for custom font handling
- Complex table layouts with booktabs and nicematrix

When editing:
- Preserve existing LaTeX3 syntax patterns
- Follow the established module structure
- Use the custom color definitions from the class file
- Maintain consistent table formatting patterns
