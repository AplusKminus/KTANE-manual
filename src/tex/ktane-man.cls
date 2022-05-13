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
