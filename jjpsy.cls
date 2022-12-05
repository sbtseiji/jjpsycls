\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{jjpsy}[2022/12/05 v1.0]

\newif\if@captionjp% 図表キャプションの言語設定用
\@captionjpfalse% 図表の言語は英語が原則

% jpcaptionオプションがある場合はキャプションを日本語モードに
\DeclareOption{jpcaption}{\@captionjptrue}
\ProcessOptions\relax

% l3keys2e package
% tablefootnote package

% ========================================
% 用紙レイアウト
% ========================================
% 投稿原稿はA4縦置き，上下左右に3cm以上の余白
% フォントサイズは10.5pt以上
%
\newcommand{\jlreqkanjiskip}{5pt plus 0.4pt minus 0.5pt}
\LoadClass[%
  gutter=50truemm,%     上下左右の余白は30mm以上
  line_length=25zw,%    1行は全角25文字
  number_of_lines=32,%  1ページは32行
  paper=a4,%            用紙サイズはA4
  11pt%                 文字サイズは10.5pt以上
  ]{jlreq}

\RequirePackage{silence}
\WarningFilter{fixltx2e}{}%      laTeX2eに関する警告を非表示
\RequirePackage{graphicx}%       画像の使用
\RequirePackage{url}%            URLの取り扱い
\RequirePackage{tikzpagenodes} % 欄外への枠の表示用
\RequirePackage{refcount}%       図表のカウンタ取得用
\RequirePackage{xifthen}%        分岐処理用
%\RequirePackage{xkeyval}%        キーの処理の単純化
\RequirePackage[nolists,nomarkers]{endfloat}

\def\jpsy@clsname{jjpsy}

\def\WordCount#1{%
  \@tempcnta\z@
  \@tfor \@tempa:=#1\do{\advance\@tempcnta\@ne}%
  \the\@tempcnta
}

% ========================================
% 本文見出し 
% ========================================
% 見出しはゴシック・ボールド体とし，番号は付けない
%
% === 中央大見出し ===
% 行の中央におき，その上下はそれぞれ1行ずつあける
%
\ModifyHeading{section}{%
  font={\normalfont\gtfamily\bfseries},
  before_space=2\zh,
  after_space=2\zh,
  number=false,
  align=center
}

% === 横大見出し ===
% 1行あけて左端から書き，本文は改行して始める
%
\ModifyHeading{subsection}{%
  font={\normalfont\gtfamily\bfseries},
  before_space=2\zh,
  after_space=1\zh,
  number=false,
  align=left
}

% ただし，中央大見出しと横大見出しが連続する場合は，
% 2行あけるのではなく，1行のみあける
%
\SetBlockHeadingSpaces{%
  {
    2\zh,_section,2\zh,_subsection,1\zh
  }%
}

% === 横小見出し ===
% 行をあけず，左端から全角1文字あけて書き，
% 本文は1文字あけて続ける
%
\RenewRuninHeading{subsubsection}{3}{font={\jlreq@keepbaselineskip{\normalsize\sffamily\gtfamily\bfseries}},indent=1\jlreq@zw,number=false}


% ========================================
% 図表キャプション
% ========================================
%
% 図と表の言語は原則として英語
%
% 図の番号はFigure X，表の番号はTable X
%
\renewcommand{\figurename}{Figure\ }
\renewcommand{\tablename}{Table\ }

% 図表番号の後，改行してタイトルを左そろえにする
%
\jlreqsetup{
  caption_font=\normalfont%
    \if@captionjp%    キャプションが日本語モードでないなら
    \else\itshape\fi% キャプションをイタリック体にする
  ,
  caption_label_font=\normalfont,
  caption_label_format={#1\newline\hspace{-\jlreq@zw}},
  caption_align=left
}

% 図表の脚注設定
\if@captionjp% 日本語と英語で表示を切り替え
  \newcommand\footnotetitle{注）}
\else
  \newcommand\footnotetitle{\emph{Note. }}
\fi
\newcommand\figurefootnote[1]{\par\footnotesize\footnotetitle#1}
\newcommand\tablefootnote[1]{\par\footnotesize\footnotetitle#1}

% 表の特定の項目に注をつける場合のコマンド
\newcounter{tbmark}[table]
\newcommand\tbmark{% 表の特定の項目にマーカーをつける
  \stepcounter{tbmark}%
  \hspace{.1\zw}\hbox{\textsuperscript{\normalfont\alph{tbmark}}}}

% ========================================
% 図表挿入コマンド
% ========================================
%
\newcounter{tblnum}%欄外に表示済の表番号
\newcounter{fignum}%欄外に表示済の図番号
\newcounter{tmp}%比較処理用のカウンタ

% ページの右側余白に［Table X］と印刷する
\newcommand\tblhere[1]{% 
  \tikz[remember picture,overlay]{%
  \coordinate (a) at (0,0);
  \coordinate (b) at (a -| current page text area.east);
  \node[draw, xshift = 10mm] at (b) {Table #1};}%
}

% ページの右側余白に［Figure X］と印刷する
\newcommand\fighere[1]{% 
  \tikz[remember picture,overlay]{%
  \coordinate (a) at (0,0);
  \coordinate (b) at (a -| current page text area.east);
  \node[draw, xshift = 10mm] at (b) {Figure #1};}%
}

% 最初に表を参照した場所に［Table X］と印刷する
\newcommand\Table[1]{%
  Table \ref{#1}%
  \setcounterref{tmp}{#1}%
  \ifnumless{\value{tblnum}}{\value{tmp}}{%
    \setcounterref{tblnum}{#1}%
    \tblhere{\ref{#1}}%
  }{}%
}

% 最初に図を参照した場所に［Table X］と印刷する
\newcommand\Figure[1]{%
  Figure \ref{#1}%
  \setcounterref{tmp}{#1}%
  \ifnumless{\value{fignum}}{\value{tmp}}{%
    \setcounterref{fignum}{#1}%
    \fighere{\ref{#1}}%
  }{}%
}


% ========================================
% 表題ページ
% ========================================
% 表題（研究助成，学会発表，修論の加筆，電子付録）
% 著者名（日本語とローマ字）（謝辞：第1著者），（改名，所属機関変更）
% 所属機関名（日本語と英語）
% 投稿原稿には著者情報は記載しない
% 英文アブストラクト
% キーワード

% 表題と副題
\renewcommand{\title}[2]{\gdef\@jtitle{#1}\gdef\@etitle{#2}}%
\newcommand{\subtitle}[2]{\gdef\@jsubtitle{#1}\gdef\@esubtitle{#2}}%

% アブストラクト
\renewcommand{\abstract}[1]{\gdef\@abstract{#1}}
\newcommand{\jabstract}[1]{\gdef\@jabstract{#1}}

% キーワード
\newcounter{jpsy@keywd}
\newcommand{\keyword}[2]{%
  \@namedef{jpsy@keyword/\the\value{jpsy@keywd}}{#1}%
  \@namedef{jpsy@jp@keyword/\the\value{jpsy@keywd}}{#1}%
  \stepcounter{jpsy@keywd}%
}

% 脚注
\newcounter{jpsy@ntcount}\stepcounter{jpsy@ntcount}%  注釈全体の個数
\newcounter{jpsy@tntcount}\stepcounter{jpsy@tntcount}% 表題注釈の個数

% 助成金や学会発表などの注は表題につける
\newcommand{\titlenote}[1]{%
  \@namedef{jpsy@notes/\the\value{jpsy@ntcount}}{#1}%
  \stepcounter{jpsy@ntcount}%
  \stepcounter{jpsy@tntcount}%
}

% 謝辞や所属変更などは，著者名につける（表題の注から通し番号）
\newcommand{\thanksnote}[1]{%
  \@namedef{jpsy@notes/\the\value{jpsy@ntcount}}{#1}%
  \stepcounter{jpsy@ntcount}%
}
\newcommand{\authornote}[1]{%
  \@namedef{jpsy@notes/\the\value{jpsy@ntcount}}{#1}%
  \stepcounter{jpsy@ntcount}%
}

% 本文中の注（表紙ページの注から通し番号）
\newcommand{\note}[1]{%
  \@namedef{jpsy@notes/\the\value{jpsy@ntcount}}{#1}%
  \hspace{0\zw}\hbox{\textsuperscript{\the\value{jpsy@ntcount}}}%
  \stepcounter{jpsy@ntcount}%
}


% 表紙ページの作成
% \edef\@wdcnt{\noexpand\WordCount{\@jtitle}}
\newcounter{jpsy@tttmp}
\renewcommand{\maketitle}{%
  \setcounter{jpsy@tttmp}{1}%
  % 表紙ページの開始
  \begin{titlepage}% 
    % 表題の表示は中央揃え
    \begin{center}
      \gtfamily\bfseries\@jtitle%
      \edef\wdcnt{\noexpand\WordCount{\@jtitle}}\wdcnt%
      \ifthenelse{\@tempcnta>40}{% 
        \ClassWarningNoLine\jpsy@clsname{「3.3.1 表題」 表題は40文字を超えないことが望ましいとされています。}}{}%
      % 表題脚注の番号を表題に付与
      \hspace{0.1\zw}\hbox{\textsuperscript{%
        \loop%
          \the\value{jpsy@tttmp}%
          \stepcounter{jpsy@tttmp}%
          \ifnum\value{jpsy@tttmp}=\value{jpsy@tntcount}\else{, }\fi%
          \ifnum\value{jpsy@tttmp}<\value{jpsy@tntcount}%
          \repeat%
      }}%
      % 副題があれば表示
      \ifthenelse{\isundefined{\@jsubtitle}}{}{%
        \par{------} \@jsubtitle {------}%
        \ClassWarningNoLine\jpsy@clsname{「3.3.1 表題」 副題はできるだけ避けてください。}%
      }%
      \par\vspace{1\zh}% 1行あける
      % 表題の英訳
      \@etitle%
      % 副題があれば表示
      \ifthenelse{\isundefined{\@esubtitle}}{}{%
        : \@esubtitle%
      }%
    \end{center}
    % アブストラクト
    \par\vspace{2\zh}% 2行あける
    \textbf{Abstract}\par% 見出し
    \ifthenelse{\isundefined{\@abstract}}{}{\@abstract}% アブストラクト
    \par\vspace{2\zh}% 2行あける
    \textbf{Keywords}\par% 見出し
    % キーワード（最大5つ）
    \newcounter{jpsy@tmp}%
    \newcommand{\maxkeywd}{5}%
    \ifthenelse{\value{jpsy@keywd}>5}{%
      \ClassWarningNoLine\jpsy@clsname{「4.11.2　キーワード」 キーワードは5項目までです。}
    }{}%
    \ifthenelse{\value{jpsy@keywd}<3}{%
      \ClassWarningNoLine\jpsy@clsname{「4.11.2　キーワード」 キーワードは3—5項目つける必要があります。}
    }{}%
    \ifthenelse{\value{jpsy@keywd}<5}{%
      \renewcommand{\maxkeywd}{\the\value{jpsy@keywd}}}{}%
      \loop%
        \ifthenelse{\equal{\@nameuse{jpsy@keyword/0}}{}}{}{%
          \ifthenelse{\equal{\value{jpsy@tmp}}{0}}{}{, }%
          \@nameuse{jpsy@keyword/0}%
          \stepcounter{jpsy@tmp}%
        }%
        \ifnum\value{jpsy@tmp}<\value{jpsy@keywd}%
          \repeat
    \clearpage
%
% AbstractとKeywordsの日本語訳
    \thispagestyle{empty}%
    \textbf{Abstractの日本語訳}\par% 見出し
    \ifthenelse{\isundefined{\@jabstract}}{}{\@jabstract}% アブストラクト
    \par\vspace{2\zh}% 2行あける
    \textbf{Keywordsの日本語訳}\par% 見出し
    \setcounter{jpsy@tmp}{0}%
    \loop%
      \ifthenelse{\equal{\@nameuse{jpsy@keyword/0}}{}}{}{%
        \ifthenelse{\equal{\value{jpsy@tmp}}{0}}{}{, }%
        \@nameuse{jpsy@keyword/0}%
        \stepcounter{jpsy@tmp}%
      }%
      \ifnum\value{jpsy@tmp}<\value{jpsy@keywd}%
        \repeat
    \end{titlepage}
  \clearpage
}

% 脚注の出力
\newcounter{jpsy@nttmp}
\newcommand{\noteshere}{%
  \stepcounter{jpsy@nttmp}%
  \clearpage\section{脚注}%
  \loop%
    \the\value{jpsy@nttmp}. %
    \@nameuse{jpsy@notes/\the\value{jpsy@nttmp}}\par%
    \stepcounter{jpsy@nttmp}%
    \ifnum\value{jpsy@nttmp}<\value{jpsy@ntcount}\repeat%
}

\endinput
%%
%% End of file `jjpsy.cls'.
