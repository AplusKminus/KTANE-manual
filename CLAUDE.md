# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a LaTeX-based manual for "Keep Talking and Nobody Explodes" bomb defusal game. The repository contains optimized LaTeX sources for a custom bomb defusal manual that streamlines module information and provides quicker solutions.

## Build Commands

This project uses XeLaTeX compilation (required for fontspec support):

```bash
# Create build directory
mkdir -p build

# Compile the main document
cd src/tex && xelatex -output-directory=../../build main.tex

# For complete build with references (run multiple times if needed)
cd src/tex && xelatex -output-directory=../../build main.tex
```

## Code Architecture

### Directory Structure
- `src/tex/` - Main LaTeX source directory
  - `main.tex` - Main document that includes all modules
  - `ktane-man.cls` - Custom LaTeX class defining the manual's styling and layout
  - `modules/` - Individual module definitions
    - `0_intro/` - Introduction content
    - `0_explanation/` - General bomb defusal instructions and edgework
    - `the_button/` - Example module implementation
  - `resources/` - Assets (fonts, images)

### Key Components

**Custom LaTeX Class (`ktane-man.cls`)**:
- Defines custom document class with specialized styling
- Implements thumb marker/tab system for quick navigation
- Uses LaTeX3 syntax for advanced functionality
- Provides `module` environment for consistent module layout
- Handles typography with SpecialElite font and custom colors

**Module System**:
- Each module is implemented as a `.tex` file in the `modules/` directory
- Uses custom `module` environment with parameters:
  - `moduleName`: Full display name (e.g., "The Button")
  - `indexString`: Used for thumb marker sorting (e.g., "Button")
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
4. Add `\include{modules/your_module/module}` to `main.tex`

The module environment expects:
- Configuration parameters in the first argument
- Introductory text in the second argument
- Module content in the environment body

### Styling and Layout

- Uses A4 paper with 2cm margins
- No page numbering (gobble mode)
- Ragged right text alignment
- Custom color scheme for tables and highlights
- Wrapfig2 package for figure placement
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