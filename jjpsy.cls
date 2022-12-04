\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{jjpsy}[2022/12/05 v1.0]

\LoadClass[number_of_lines=32,line_length=25zw,a4paper,11pt]{jlreq}
\RequirePackage{silence}
\WarningFilter{fixltx2e}{}
\RequirePackage{graphicx}
\RequirePackage{url}
\RequirePackage[top=30truemm,bottom=30truemm,left=30truemm,right=50truemm]{geometry}

\ModifyHeading{section}{%
    font={\normalfont\bfseries},
    lines=3,
    number=false,
    align=center
}

\ModifyHeading{subsection}{%
    font={\normalfont\bfseries},
    lines=2,
    before_lines=1,
    number=false,
    align=left
}

\ModifyHeading{subsubsection}{%
    font={\normalfont\bfseries},
}

\SetBlockHeadingSpaces{%
    {
        _section{lines=3},
        _subsection{lines=1}
    }%
}

\jlreqsetup{
    caption_font=\normalfont,
    endnote_position=_<引用文献>
}

\endinput
%%
%% End of file `jjpsy.cls'.
