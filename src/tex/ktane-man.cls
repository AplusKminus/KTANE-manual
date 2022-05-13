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

\RequirePackage{pgf,pgffor}
\RequirePackage[absolute]{textpos}
\setlength{\TPHorizModule}{1cm}
\setlength{\TPVertModule}{1pt}
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
