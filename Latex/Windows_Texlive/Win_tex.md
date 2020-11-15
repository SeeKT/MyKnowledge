# WindowsにTeX環境を作る
## はじめに
- 普段Ubuntuを使っているが，WindowsにTeX環境を作りたいと思った．
- TeXWorksが嫌い．
## Require
- Windows 10
- Vimの使い方を多少知ってる
## やること
0. AtomとVimを入れる
1. TeXLiveを入れる
2. TeXのコンパイルができるかテスト
3. Strawberry Perlを入れる
4. .latexmkrcを作る
5. latexmkが使えるかテスト
### AtomとVimを入れる
- 私はTeXを書くときにAtomエディタを使うので，入れました．
    - Git管理も楽 (GitHubが作ってる)
- PowerShellで使えるエディタを入れたいなということで，Vimを入れました．
    - EmacsよりVimが好き
#### Atomの導入
- 流れ
    - Atomと検索し，ダウンロード → インストール．
    - 必要なパッケージを入れる．以下は入れておくことを勧める．
        - latex
        - language-latex
        - latexer
        - pdf-view
#### Vimの導入
- https://qiita.com/Futo_Horio/items/21456f8acbad3c6bb442 を参考にしました．

- 要約すると，
    - KaoriYaのVimをインストールする
    - "Vim"という風にディレクトリを改名
    - Program Filesに先ほど改名したVimディレクトリを入れる
    - パスを通す
        - 『ここに入力して検索』で『環境変数』と調べ，『ユーザー環境変数』の中の変数Pathで『編集』．以下を追加．

![vim_path](https://raw.githubusercontent.com/SeeKT/MyKnowledge/images/Windows_latex/vim_path.PNG "VimのPathを通す")

- これでPowerShellからvimが使えるようになる．

### TeXLiveを入れる
- このURL (https://texwiki.texjp.org/?TeX%20Live%2FWindows) の『ISOイメージからのインストール』に従う．
>> Acquiring TeX Live as an ISO image から ISO イメージがダウンロードできます． 
「download from a nearby CTAN mirror」から，texlive2020.iso をダウンロードしてください． 
Windows 10, Windows 8.1 では基本機能で ISO イメージの中身を見ることが可能です． 
2020 年 1 月 14 日にサポートが終了した Windows 7 では ISO イメージの中身を見るには Virtual CloneDrive などのソフトウェアが追加で必要です． 
ダブルクリックすると BD-ROM/DVD-ROM ドライブとしてマウントされます． 
中には install-tl-windows.bat がありますので，後はネットワークインストールと同様の手順でインストールが可能です．

- ISOイメージをダウンロードして，ダブルクリック

![texlive](https://raw.githubusercontent.com/SeeKT/MyKnowledge/images/Windows_latex/texlive.PNG "TeXLiveのインストール")

- install-tl-windows を右クリック．『管理者として実行』
    - TeXWorksをインストールにチェックが入ってるけど，外しましょう．要りません．
- 待つ (たぶん1時間はかからないと思う)．
- 特に何もしなくてもパスが通ってるみたいです．

### TeXのコンパイルができるかテスト
- 適当なディレクトリに適当なtexソースコードを作る (e.g. test.tex) ．
- 以下のコマンドを実行．test.pdfが正しく作られたらOk．
    ```
    platex test.tex
    dvipdfmx test.dvi
    ```


### Strawbery Perlを入れる
- WindowsはデフォルトではPerlを使えないので，インストールします．
    - http://strawberryperl.com/
    - 64bitの方
- 特に何もしなくてもパスが通ってるみたいです．

### .latexmkrcを作る
- ホームディレクトリ直下で，以下のコマンドで，新しく".latexmkrc"ファイルを作る．
    ```
    vim .latexmkrc
    ```
- "i"を押して挿入モードにして，以下のコマンド列を記述する (copy and pasteでも良い)
    ```
    #!/usr/bin/env perl
    $latex = 'platex -guess-input-enc -src-specials -interaction=nonstopmode -synctex=1';
    $latex_silent = 'platex -interaction=batchmode';
    $dvips = 'dvips';
    $bibtex = 'pbibtex';
    $makeindex = 'mendex -r -c -s jind.ist';
    $dvi_previewer = 'start dviout';
    $dvipdf = 'dvipdfmx %O -o %D %S';
    $preview_continuous_mode = 1;
    $pdf_mode = 3;
    $pdf_update_method = 4;
    ```

![latexmk](https://raw.githubusercontent.com/SeeKT/MyKnowledge/images/Windows_latex/latexmk.PNG "latexmk")

- Escを押してノーマルモードにする．
- ノーマルモードの状態で，":wq"と打って，保存して終了．

### latexmkのテスト
- PowerShellから，以下のコマンドを実行．
    ```
    latexmk test.tex
    ```
- これで，pdf-viewerが起動し，ctrl + sで保存するとpdfが更新されたら良い．
- 終了時はctrl + cを2回押す．

## AtomによるTeX文書作成環境
- こんな感じで左側に文書，右側にPDFを配置して，文書の作成ができる → 文書作成の効率化．
- また，一番左のProjectから今のディレクトリにあるファイルが見れる → 図の挿入のときのパスを楽に調べられる．
- Git連携が楽．

![atom](https://raw.githubusercontent.com/SeeKT/MyKnowledge/images/Windows_latex/testtex.PNG "AtomによるTeX文書作成環境")

## おわりに
- Atom + latexmkで良いTeX Lifeを．