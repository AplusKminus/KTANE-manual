%%Identification
%%The class identifies itself and the LaTeX version needed
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ktane-mod}[2022/05/13 KTANE Module]

%% Font Setup
\renewcommand{\normalsize}{\fontsize{12pt}{12pt}\selectfont}
\RequirePackage{fontspec}
\setmainfont[
  AutoFakeBold=5,
  AutoFakeSlant=.2,
  UprightFont=*-Regular.ttf,
  BoldFont=*-Regular.ttf,
  Path=../../../../resources/
]{SpecialElite}

\RequirePackage{ulem}
\RequirePackage{contour}

% --- Custom Underline Settings ---
\renewcommand{\ULdepth}{2.5pt} % Depth of the underline below the baseline.
\renewcommand{\ULthickness}{0.8pt}
\contourlength{0.8pt}          % Width of the white contour around letters.

% --- The actual command for the skipping underline ---
\let\ulemUline\uline
\renewcommand{\uline}[1]{%
  \ulemUline{\phantom{#1}}%       % Draw a phantom underline
  \llap{\contour{white}{#1}}% % Overlay text with white contour
}
% --- End Custom Underline ---

%% Color Setup
\RequirePackage[table]{xcolor}
\definecolor{red}{HTML}{DE8A74}
\definecolor{green}{HTML}{A0AF84}
\definecolor{yellow}{HTML}{EEC584}
\definecolor{blue}{HTML}{7080A5}
\definecolor{purple}{HTML}{C090B8}
\definecolor{gray}{HTML}{B4AEA3}
\definecolor{lightred}{HTML}{F0C4B9}
\definecolor{lightgreen}{HTML}{CAD6A9}
\definecolor{lightyellow}{HTML}{F0DBA5}
\definecolor{lightblue}{HTML}{B5C4DF}
\definecolor{lightpurple}{HTML}{DBC3D2}
\definecolor{lightgray}{HTML}{E6E6E6}
\definecolor{black}{HTML}{2E2B27}

% For intelligent spacing after commands
\RequirePackage{xspace}

% Symbol package for interaction markers
\RequirePackage{fontawesome5}

%% Module Interaction Symbol System
% Available interaction symbols
\newcommand{\keysymbol}{\faKey\xspace}  % Key dependency symbol

% Function to display interaction symbols in module title
\ExplSyntaxOn
\cs_new:Nn \g_ktane_display_interactions:n {
  \tl_if_empty:nF {#1} {
    \hspace{0.3em}#1
  }
}
\ExplSyntaxOff

% Color word commands
\newcommand{\RED}[1][RED]{\colorbox{red}{#1}\xspace}
\newcommand{\GREEN}[1][GREEN]{\colorbox{green}{#1}\xspace}
\newcommand{\YELLOW}[1][YELLOW]{\colorbox{yellow}{#1}\xspace}
\newcommand{\BLUE}[1][BLUE]{\colorbox{blue}{#1}\xspace}
\newcommand{\PURPLE}[1][PURPLE]{\colorbox{purple}{#1}\xspace}
\newcommand{\WHITE}[1][WHITE]{\colorbox{lightgray}{#1}\xspace}
\newcommand{\GRAY}[1][GRAY]{\colorbox{gray}{#1}\xspace}
\newcommand{\BLACK}[1][BLACK]{\colorbox{black}{\textcolor{white}{#1}}\xspace}

%% Used for table alignment
\RequirePackage{array}
\RequirePackage{adjustbox}
\RequirePackage{multirow}
\RequirePackage{booktabs}
\RequirePackage{nicematrix}

\LoadClass[a4paper, twoside]{article}

%% Extended captions
\RequirePackage{caption}

%% Graphic support
\RequirePackage{graphicx}
\RequirePackage{tikz}
\usetikzlibrary{fit, positioning, patterns, shapes.geometric}
\pgfdeclarepatternformonly{diagonal stripes}{%
  \pgfqpoint{-5pt}{-5pt}%   % Lower-left corner of the pattern tile's drawing bounding box (allows proper painting in ghostscript)
}{%
  \pgfqpoint{21pt}{21pt}%   % Upper-right corner of the pattern tile's drawing bounding box (allows proper painting in ghostscript)
}{%
  \pgfqpoint{16pt}{16pt}%   % XY-step for tiling (the actual repeat distance)
}{
  \pgfsetlinewidth{5.66pt} % Set the line width
  \pgfsetrectcap
  \pgfpathmoveto{\pgfqpoint{-3pt}{-3pt}}
  \pgfpathlineto{\pgfqpoint{19pt}{19pt}}
  \pgfusepath{stroke}
}

%% Wrapping figures and tables to the left or right
\input{insbox}
\RequirePackage{wrapfig2}

%% Page Setup
\RequirePackage{ragged2e}
\RaggedRight
\RequirePackage[margin=2cm,bottom=1cm]{geometry}
% Remove all page numbering
\pagenumbering{gobble}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                          %%
%% --- Drawing the Thumb Markers ---                                        %%
%%                                                                          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Active LaTeX3-Syntax
\ExplSyntaxOn
% For placing the thumb marker tabs
\RequirePackage[absolute]{textpos}
% The unit of the horizontal tab measurement
\setlength{\TPHorizModule}{1cm}
% The unit of the vertical tab measurement
\setlength{\TPVertModule}{1pt}
% The list of tab contents
\clist_const:Nn \thumbmarkernames
  {
    \#A,
    B,
    C,
    DE,
    F,
    GH,
    IJK,
    L,
    M,
    NO,
    P,
    QR,
    S,
    T,
    UVW,
    XYZ
  }
% The index that is currently selected to be drawn. -1 = cut entire register off, 0 = leave first tab, etc
\int_new:N \g_ktane_thumbmarkerselectedindex_int
\int_gset:Nn \g_ktane_thumbmarkerselectedindex_int {-1}
% Wether to draw the tab of the given iteration (used in g_ktane_addthumbmarkers:)
\int_new:N \l_draw_bool
% The vertical distance from the top of the page where to draw the tab of the given iteration (used in
% g_ktane_addthumbmarkers:)
\dim_new:N \l_vdistance_dim
% The index of the tab of the given iteration, zero-based (used in g_ktane_addthumbmarkers:)
\int_new:N \l_ktane_thumbmarkerdrawindex_int
% The list of characters on the thumb marker of the given iteration
\tl_new:N \l_ktane_thumbmarkernameparts_tl
% The method to draw all thumb markers for the current page
\cs_new:Nn \g_ktane_addthumbmarkers:
  {
    % reset running index to 0
    \int_gset:Nn \l_ktane_thumbmarkerdrawindex_int {0}
    % map over the tab names
    \clist_map_inline:Nn \thumbmarkernames {
      % Turn name into token list
      \tl_set:Nn \l_ktane_thumbmarkernameparts_tl {##1}
      % calculate the vertical distance
      \dim_set:Nn \l_vdistance_dim {\paperheight * \l_ktane_thumbmarkerdrawindex_int / \clist_count:N \thumbmarkernames}
      \int_if_even:nTF {\count0}
        {% page# even (left) -- always draw tab
          \int_set:Nn \l_draw_bool {1}
        }
        {% page# odd (right) -- only draw current and following tabs
          \int_compare:nNnF{\l_ktane_thumbmarkerdrawindex_int} < {\g_ktane_thumbmarkerselectedindex_int}
          {% current index to draw >= defined "start"-index
            \int_set:Nn \l_draw_bool {1}
          }
        }
      % whether to draw
      \int_compare:nNnT {\l_draw_bool} = {1}{
        % plaxing the tab in absolute coordinates
        \begin{textblock}{1}(\int_if_odd:nTF {\count0}{20}{0},\dim_to_decimal:n {\l_vdistance_dim})
          \vbox{
            \hbox{
              % add a leading vertical line (cutting line) to tabs on odd pages following the current tab
              \int_if_odd:nT {\count0}
                {\int_compare:nT{\l_ktane_thumbmarkerdrawindex_int > \g_ktane_thumbmarkerselectedindex_int}{\vrule}}
              % 297 / 16 = 18.5625
              \vbox to 18.5625mm{
                \vfill
                \hbox to 1cm{
                  \hfill\vbox{
                    % Wrap each name part in an hbox
                    \tl_map_inline:Nn \l_ktane_thumbmarkernameparts_tl {\hbox{####1}}
                  }\hfill
                }
                \vfill
              }
            }
            % add a trailing horizontal line (cutting line) to the current tab on odd pages
            \int_if_odd:nT {\count0}
              {\int_compare:nT{\l_ktane_thumbmarkerdrawindex_int = \g_ktane_thumbmarkerselectedindex_int}
                {\hrule}
              }
          }
        \end{textblock}
      }
      % increase the index of the iteration
      \int_gincr:N \l_ktane_thumbmarkerdrawindex_int
    }
  }
% For drawing the markers on every page
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\fancyhead[LO,LE]{Keep~Talking~and~Nobody~Explodes~v.1}
% draw the thumb markers on all pages
\fancyfoot[C]{\g_ktane_addthumbmarkers:}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                          %%
%% --- Defining the custom module environment ---                           %%
%%                                                                          %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{titlesec}
\titleformat{\section}
{\LARGE\bfseries\centering}
{\thesection.}
{0.33em}
{}
\titlespacing*{\section}{0pt}{*4}{*1.5}

\titleformat{\subsection}
{\Large\bfseries}
{\thesubsection.}
{0.33em}
{}
\titlespacing*{\subsection}{0pt}{*4}{*1.5}

\titleformat{\subsubsection}
{\large\bfseries}
{\thesubsubsection.}
{0.33em}
{\uline}

% Custom command for headings with bold and underline
\newcommand{\textheading}[1]{{\bfseries\uline{#1}}}

% Custom bulletlist environment that mimics itemize behavior
\newenvironment{bulletlist}{%
  % Add vertical space like itemize
  \par\addvspace{\topsep}%
  % Define \bulletitem only within this environment
  \newcommand{\bulletitem}[1]{%
    \par
    \begingroup
    \advance\leftskip by 2.5em
    \parindent=0em
    \noindent
    \llap{\hspace{2.5em}$\bullet$\hspace{0.5em}}##1\par
    \endgroup
  }%
}{%
  % Add vertical space at end like itemize
  \par\addvspace{\topsep}%
  % \bulletitem is automatically undefined when environment ends
}

\prop_new:N \l_ktane_moduleconfiguration_pl

\RequirePackage{xstring}
% Helper variant to extract the first character of a token list
\cs_generate_variant:Nn \tl_item:nn { f }
% Helper variant to pass a token list as a variable
\cs_generate_variant:Nn \str_if_in:NnT {NVT}
% A local token list to receive the parameter
\tl_new:N \l_ktane_indexstring_tl
\str_new:N \l_ktane_markerstring_str
% A method to determine the thumb marker index from a string
\cs_new:Nn \g_ktane_setindexfromname:n {
  % set the value to 1 (default for unknown character. Actually zero, but there is a decrement at the end)
  \int_gset:Nn \g_ktane_thumbmarkerselectedindex_int {1}
  \tl_set:Nn \l_ktane_indexstring_tl {#1}
  \tl_set:Nx\l_ktane_indexstring_tl{\tl_item:fn \l_ktane_indexstring_tl {1}}

  \int_set:Nn \l_ktane_thumbmarkerdrawindex_int {1}
  % go through list to find corresponding marker
  \clist_map_inline:Nn \thumbmarkernames {
    \str_set:Nn \l_ktane_markerstring_str {##1}
    \str_if_in:NVT \l_ktane_markerstring_str {\l_ktane_indexstring_tl}
      {
        \int_gset_eq:NN \g_ktane_thumbmarkerselectedindex_int \l_ktane_thumbmarkerdrawindex_int
      }
    \int_incr:N\l_ktane_thumbmarkerdrawindex_int
  }
  % decrement to match behavior of \g_ktane_addthumbmarkers:
  \int_gdecr:N \g_ktane_thumbmarkerselectedindex_int
}

% Common module setup command - extracts common functionality
% Third parameter: what to set rhead to
\cs_new:Nn \g_ktane_setup_module_common:nnn {
  \def\moduleName{\prop_item:Nn \l_ktane_moduleconfiguration_pl {moduleName}}
  
  % The module title with interaction symbols
  \subsection*{\uline{On\ the\ Subject\ of\ \moduleName}\g_ktane_display_interactions:n{\prop_item:Nn\l_ktane_moduleconfiguration_pl{interactions}}}
  \rhead{#3}

  % The module image using insbox with proper vertical positioning
  \vspace{-0.8cm}
  \InsertBoxR{0}{
    \includegraphics[height=3.5cm]{\prop_item:Nn\l_ktane_moduleconfiguration_pl{imageResource}}
  }
  \vspace{1.1cm}

  % The introductory text
  \small\itshape#2  \normalfont\normalsize\par
}

%% Regular module environment with thumb markers and page breaks
% Parameters:
% - moduleName: Full display name (e.g. "The Button") 
% - indexString: For thumb marker sorting (e.g. "Button")
% - imageResource: Path to module image
% - interactions: Optional interaction symbols (e.g. "\keysymbol")
% Second parameter: introductory text in small italics
\newenvironment{module}[2]
  {
    \prop_set_from_keyval:Nn \l_ktane_moduleconfiguration_pl {#1}
    \g_ktane_setup_module_common:nnn {#1} {#2} {\prop_item:Nn \l_ktane_moduleconfiguration_pl {moduleName}}
    \g_ktane_setindexfromname:n {\prop_item:Nn \l_ktane_moduleconfiguration_pl {indexString}}
  }
  {
    \cleardoublepage
  }

%% Needy module environment without thumb markers or page breaks
% Parameters same as module but no indexString needed (interactions parameter still supported)
% Used for needy modules, which are part of the preamble
\newenvironment{needymodule}[2]
  {
    \prop_set_from_keyval:Nn \l_ktane_moduleconfiguration_pl {#1}
    \g_ktane_setup_module_common:nnn {#1} {#2} {Needy~Modules}
    % No thumb marker setup for needy modules
  }
  {
    % Add minimum spacing after needy module to prevent image overlap
    \par\vspace{0.5cm}
    % No page break for needy modules
  }
\ExplSyntaxOff
