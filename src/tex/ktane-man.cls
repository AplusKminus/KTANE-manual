%%Identification
%%The class identifies itself and the LaTeX version needed
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ktane-man}[2022/05/13 KTANE Manual]

%% Font Setup
\renewcommand{\normalsize}{\fontsize{12pt}{12pt}\selectfont}
\RequirePackage{fontspec}
\setmainfont{[SpecialElite-Regular.ttf]}

%% Color Setup
\RequirePackage{xcolor}
\definecolor{red}{HTML}{DE8A74}
\definecolor{green}{HTML}{A0AF84}
\definecolor{yellow}{HTML}{EEC584}
\definecolor{blue}{HTML}{808A9F}
\definecolor{gray}{HTML}{B4AEA3}

\LoadClass[a4paper]{article}

%% Page Setup
\raggedright
\RequirePackage[margin=2cm]{geometry}
% Remove all page numbering
\pagenumbering{gobble}

%% Thumb Register
% For drawing the register on every page
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\renewcommand{\headrulewidth}{0pt}
\fancyhead[LO]{Keep Talking and Nobody Explodes v.1}
\fancyhead[RO]{}
\fancyfoot[LE,LO]{\thumbregister{3}}
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
% To draw all registers starting from numer n
\newcommand{\thumbregister}[1]{
  \foreach \x [count=\xi] in \registernames {%
    \ifnum\xi = #1
    \drawthumbregister{\numexpr \xi - 1}{\x}{1}
    \fi
    \ifnum\xi > #1
    \drawthumbregister{\numexpr \xi - 1}{\x}{0}
    \fi
  }
}
% To draw a single register
% First param is the vertical index (0-based)
% Second param is the content of the tab
% Third param is whether to draw a horizontal line after (1) or a vertical line before (0)
\newcommand{\drawthumbregister}[3]{
  \newdimen\verticaldistance
  \verticaldistance=\dimexpr \paperheight * #1
  \divide \verticaldistance by 16
  \begin{textblock}{1}(20,\number\strip@pt\verticaldistance)
    \vbox{\hbox{\ifodd#3\else\vrule\fi
    \vbox to 18.5625mm{
      \vfill
      \hbox to 1cm{
        \hfill\vbox{#2}\hfill
      }
      \vfill}}
    \ifodd#3\hrule\fi}
  \end{textblock}
}
