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
% For drawing the markers on every page
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt}
\fancyhead[LO]{Keep Talking and Nobody Explodes v.1}
\fancyhead[RO]{}
\fancyfoot[LO]{\addthumbmarkers}
\fancyfoot[RE]{\addthumbmarkers}
% For doing foreach loops
\RequirePackage{pgf,pgffor}
% For placing the thumb marker tabs
\RequirePackage[absolute]{textpos}
% The unit of the horizontal tab measurement
\setlength{\TPHorizModule}{1cm}
% The unit of the vertical tab measurement
\setlength{\TPVertModule}{1pt}
% The tabs
\def\thumbmarkernames{
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
\newcommand{\addthumbmarkers}{
  \newdimen\verticaldistance
  % To draw a single marker
  % First param is the vertical index (0-based)
  % Second param is the content of the tab
  \newcommand{\drawthumbmarker}[2]{
    \verticaldistance=\dimexpr \paperheight * #1
    \divide \verticaldistance by 16
    % do not draw this marker
    \def\makecurrentthumbmarker{n}
    % on odd pages ...
    \ifodd\count0
    \ifnum#1<\currentthumbmarkerindex
    \else
    % draw if current marker index >= desired index
    \def\makecurrentthumbmarker{y}
    \fi
    \else
    % on even pages, draw always
    \def\makecurrentthumbmarker{y}
    \fi
    % The actual drawing of a thumb-marker
    \if y\makecurrentthumbmarker
    \begin{textblock}{1}(\ifodd\count0 20\else 0\fi,\number\strip@pt\verticaldistance)
      \vbox{\hbox{\ifodd\count0 \ifnum#1>\currentthumbmarkerindex\vrule\fi\fi
      % 297 / 16 = 18.5625
      \vbox to 18.5625mm{
        \vfill
        \hbox to 1cm{
          \hfill\vbox{#2}\hfill
        }
        \vfill}}
      \ifodd\count0\ifnum#1=\currentthumbmarkerindex\hrule\fi\fi}
    \end{textblock}
    \fi
  }
  \foreach \x [count=\xi] in \thumbmarkernames {%
    \drawthumbmarker{\numexpr \xi - 1}{\x}
  }
}
\newcommand{\indexedby}[1]{
  \def\currentthumbmarkerindex{#1}
}
