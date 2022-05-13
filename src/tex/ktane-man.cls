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

%% Thumb Register
% For drawing the register on every page
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\fancyhead[LO]{Keep Talking and Nobody Explodes v.1}
\fancyhead[RO]{}
\fancyfoot[LO]{\thumbregisterright{\currentthumbregister}}
\fancyfoot[RE]{\thumbregisterleft{\currentthumbregister}}
% For doing foreach loops
\RequirePackage{pgf,pgffor}
% For placing the register tabs
\RequirePackage[absolute]{textpos}
% The unit of the horizontal tab measurement
\setlength{\TPHorizModule}{1cm}
% The unit of the vertical tab measurement
\setlength{\TPVertModule}{1pt}
% The tabs
\def\registernames{
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
% To draw all registers starting from number n on the right side
\newcommand{\thumbregisterright}[1]{
  \foreach \x [count=\xi] in \registernames {%
    \ifnum\xi = #1
    \drawthumbregister{\numexpr \xi - 1}{\x}{1}{20}
    \fi
    \ifnum\xi > #1
    \drawthumbregister{\numexpr \xi - 1}{\x}{0}{20}
    \fi
  }
}
% To draw all registers up to number n on the left side
\newcommand{\thumbregisterleft}[1]{
  \foreach \x [count=\xi] in \registernames {%
    \ifnum\xi > #1
    \else
    \drawthumbregister{\numexpr \xi - 1}{\x}{2}{0}
    \fi
  }
}
% To draw a single register
% First param is the vertical index (0-based)
% Second param is the content of the tab
% Third param is whether to draw a vertical line before (0), a horizontal line after (1) or no lines (2)
% Fourth param is the horizontal position in cm
\newcommand{\drawthumbregister}[4]{
  \newdimen\verticaldistance
  \verticaldistance=\dimexpr \paperheight * #1
  \divide \verticaldistance by 16
  \begin{textblock}{1}(#4,\number\strip@pt\verticaldistance)
    \vbox{\hbox{\ifnum#3=0\vrule\fi
    \vbox to 18.5625mm{
      \vfill
      \hbox to 1cm{
        \hfill\vbox{#2}\hfill
      }
      \vfill}}
    \ifnum#3=1\hrule\fi}
  \end{textblock}
}
\newcommand{\indexedby}[1]{
  \def\currentthumbregister{#1}
}
