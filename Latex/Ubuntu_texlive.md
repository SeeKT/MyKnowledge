# UbuntuにTeX環境を作る
## はじめに
- UbuntuにTeXを入れたときのメモ
## やること
0. 好きなエディタを入れる
1. TeXLiveを入れる
2. ~/.latexmkrcを作る
3. 動作テスト
### 好きなエディタを入れる
- 私はTeXの文書を作るときはAtomを使うので，Atomを入れた．
    - 公式サイト (https://atom.io/) からdebをダウンロードして実行．
        ```
        sudo apt install ./atom-amd64.deb
        ```
    - パッケージを入れる．
        - latex
        - language-latex
        - latexer
        - pdf-view
### TeXLiveを入れる
- 日本の大学(e.g. NAIST)のリポジトリからダウンロードして中身を展開する．
    ```
    wget http://ftp.naist.jp/pub/CTAN/systems/texlive/tlnet/install-tl-unx.tar.gz
    tar -zxvf install-tl-unx.tar.gz
    cd install-tl-[date]
    ```
- 管理者権限で実行する．リポジトリはダウンロードしたところ．
    ```
    sudo ./install-tl --repository http://ftp.naist.jp/pub/CTAN/systems/texlive/tlnet/
    ```
    - "I"でインストール
- パスを通す．
    ```
    sudo /usr/local/texlive/2020/bin/x86_64-linux/tlmgr path add
    ```
    - これは私の例である．
- TeXLiveのアップデート
    - 参照するリポジトリの指定
        ```
        sudo tlmgr option repository http://ftp.naist.jp/pub/CTAN/systems/texlive/tlnet/
        ```
    - アップデート
        ```
        sudo tlmgr update --self --all
        ```

### ~/.latexmkrcの作成
- 毎回コンパイル(platexしてdvipdfmxして...)というのは面倒 → latexmkを使うことで，保存する度に自動的にpdfまで生成するようにする．
    - 数々のサイトが参考になる (例: https://qiita.com/tdrk/items/16f31e45826c57bce412)
    - Ubuntuでは以下のファイルをホームディレクトリ直下(~/.latexmkrc)に配置したところ，正常に動作した．
    ```perl
    #!/usr/bin/perl
    $latex = 'platex -guess-input-enc -src-specials -interaction=nonstopmode -synctex=1';
    $latex_silent = 'platex -interaction=batchmode';
    $dvips = 'dvips';
    $bibtex = 'pbibtex';
    $makeindex = 'mendex -r -c -s jind.ist';
    $dvi_previewer = 'start dviout';
    $dvipdf = 'dvipdfmx %O -o %D %S';
    $pdf_previewer = 'xdg-open';
    $preview_continuous_mode = 1;
    $pdf_mode = 3;
    $pdf_update_method = 4;
    ```
    - latexmkについては，
        ```
        vim ~/.latexmkrc
        ```
        などとして，上記のようなものを作ればよい．

### 動作テスト
#### platex
- "test.tex"という名前のファイルをtextestというディレクトリの中に作った．
    ```tex
    \documentclass[a4j, 12pt]{jsarticle}
    \title{ {\LaTeX} 動作テスト・サンプルファイル}
    \date{\today}
    \begin{document}
    \maketitle
    \section{test}
    これはテストです．
    \begin{equation}
    f(x) = 2x + 3
    \end{equation}
    \end{\document}
    ```
- textestというディレクトリに移動して，以下のコマンドを実行する．
    ```
    platex test.tex && dvipdfmx test.dvi
    ```
    実行後にpdfファイルが問題なく生成されていたら良い．
#### latexmk
- 先程のファイルに対して，
    ```
    latexmk test.tex
    ```
    として，正しくpdfファイルが生成され，かつ，変更，保存後にpdfファイルが更新されたら問題なく導入されている．

### おまけ: styleファイルを入れる
- jlisting.styというスタイルファイルを例に説明 (参考: https://qiita.com/ocian/items/28bbbec6c44b9b6b44c4)．
- jlisting.styをダウンロードする．
- listings.styの場所を探す．
    ```
    kpsewhich listings.sty
    ```
    この場所にjlisting.styも配置することにする．
- 管理者権限でjlisting.styを移動する．
    ```
    sudo mv jlisting.sty /usr/local/texlive/2020/texmf-dist/tex/latex/listings/
    ```
- 権限を周りのstyファイルに合わせ一覧を更新する
    ```
    cd /usr/local/texlive/2020/texmf-dist/tex/latex/listings/
    chmod 644 jlisting.sty
    sudo mktexlsr
    ```
- 確認
    ```
    cd
    kpsewhich jlisting.sty
    ```
    として
    ```
    /usr/local/texlive/2020/texmf-dist/tex/latex/listings/jlisting.sty
    ```
    となったら良い．