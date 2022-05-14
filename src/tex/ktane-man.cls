%%Identification
%%The class identifies itself and the LaTeX version needed
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ktane-man}[2022/05/13 KTANE Manual]

%% Font Setup
\renewcommand{\normalsize}{\fontsize{12pt}{12pt}\selectfont}
\RequirePackage{fontspec}
\setmainfont{[SpecialElite-Regular.ttf]}

%% Color Setup
\RequirePackage[table]{xcolor}
\definecolor{red}{HTML}{DE8A74}
\definecolor{green}{HTML}{A0AF84}
\definecolor{yellow}{HTML}{EEC584}
\definecolor{blue}{HTML}{808A9F}
\definecolor{gray}{HTML}{B4AEA3}

%% Used for table alignment
\RequirePackage{array}
\RequirePackage{adjustbox}

\LoadClass[a4paper, twoside]{article}

%% Extended captions
\RequirePackage{caption}

%% Graphic support
\RequirePackage{graphicx}

%% Wraping figures and tables to the left or right
\RequirePackage{wrapfig2}

%% Page Setup
\RequirePackage{ragged2e}
\RaggedRight
\RequirePackage[margin=2cm]{geometry}
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
    \hbox{\#}\hbox{A},
    \hbox{B},
    \hbox{C},
    \hbox{D}\hbox{E},
    \hbox{F},
    \hbox{G}\hbox{H},
    \hbox{I}\hbox{J}\hbox{K},
    \hbox{L},
    \hbox{M},
    \hbox{N}\hbox{O},
    \hbox{P},
    \hbox{Q}\hbox{R},
    \hbox{S},
    \hbox{T},
    \hbox{U}\hbox{V}\hbox{W},
    \hbox{X}\hbox{Y}\hbox{Z}
  }
% The index that is currently selected to be drawn. 0 = cut entire register off, 1 = leave first tab, etc
\int_new:N \g_ktane_thumbmarkerselectedindex_int
% Wether to draw the tab of the given iteration (used in l_ktane_addthumbmarkers:)
\int_new:N \l_draw_bool
% The vertical distance from the top of the page where to draw the tab of the given iteration (used in l_ktane_addthumbmarkers:)
\dim_new:N \l_vdistance_dim
% The index of the tab of the given iteration, zero-based (used in l_ktane_addthumbmarkers:)
\int_new:N \l_ktane_thumbmarkerdrawindex_int
% The method to draw all thumb markers for the current page
\cs_new:Nn \l_ktane_addthumbmarkers:
  {
    % reset running index to 0
    \int_gset:Nn \l_ktane_thumbmarkerdrawindex_int {0}
    % map over the tab names
    \clist_map_inline:Nn \thumbmarkernames {
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
                  \hfill\vbox{##1}\hfill
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
\newcommand{\indexedby}[1]{
  \int_gset:Nn \g_ktane_thumbmarkerselectedindex_int {#1}
  % decrease number to have 0 mean "all tabs should be cut off"
  \int_gdecr:N \g_ktane_thumbmarkerselectedindex_int
}
% For drawing the markers on every page
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\fancyhead[LO]{Keep Talking and Nobody Explodes v.1}
\fancyhead[RO]{}
% draw the thumb markers on all pages
\fancyfoot[C]{\l_ktane_addthumbmarkers:}
\ExplSyntaxOff
