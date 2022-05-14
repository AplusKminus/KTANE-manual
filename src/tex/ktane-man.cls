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
\raggedright
\RequirePackage[margin=2cm]{geometry}
% Remove all page numbering
\pagenumbering{gobble}

%% Thumb Markers
%\RequirePackage{expl3}
\ExplSyntaxOn
% For placing the thumb marker tabs
\RequirePackage[absolute]{textpos}
% The unit of the horizontal tab measurement
\setlength{\TPHorizModule}{1cm}
% The unit of the vertical tab measurement
\setlength{\TPVertModule}{1pt}
% The tabs
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
% To draw all markers
\int_new:N \g_ktane_thumbmarkerselectedindex_int
\int_new:N \l_draw_bool
\dim_new:N \l_vdistance_dim
\int_new:N \l_ktane_thumbmarkerdrawindex_int
\cs_new:Nn \l_ktane_addthumbmarkers:
  {
    \int_gset:Nn \l_ktane_thumbmarkerdrawindex_int {0}
    \clist_map_inline:Nn \thumbmarkernames {
      \dim_set:Nn \l_vdistance_dim {\paperheight * \l_ktane_thumbmarkerdrawindex_int / 16}
      \int_if_even:nTF {\count0}
        {% page no even
          \int_set:Nn \l_draw_bool {1}
        }
        {% page no odd
          \int_compare:nNnF{\l_ktane_thumbmarkerdrawindex_int} < {\g_ktane_thumbmarkerselectedindex_int}
          {% current index to draw >= defined "start"-index
            \int_set:Nn \l_draw_bool {1}
          }
        }

      \int_compare:nNnT {\l_draw_bool} = {1}{
        \begin{textblock}{1}(\int_if_odd:nTF {\count0}{20}{0},\dim_to_decimal:n {\l_vdistance_dim})
          \vbox{
            \hbox{
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
            \int_if_odd:nT {\count0}
              {\int_compare:nT{\l_ktane_thumbmarkerdrawindex_int = \g_ktane_thumbmarkerselectedindex_int}
                {\hrule}
              }
          }
        \end{textblock}
      }
      \int_gincr:N \l_ktane_thumbmarkerdrawindex_int
    }
  }
\newcommand{\indexedby}[1]{
  \int_gset:Nn \g_ktane_thumbmarkerselectedindex_int {#1}
  \int_gdecr:N \g_ktane_thumbmarkerselectedindex_int
}
% For drawing the markers on every page
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\fancyhead[LO]{Keep Talking and Nobody Explodes v.1}
\fancyhead[RO]{}
\fancyfoot[LO]{\l_ktane_addthumbmarkers:}
\fancyfoot[RE]{\l_ktane_addthumbmarkers:}
\ExplSyntaxOff
