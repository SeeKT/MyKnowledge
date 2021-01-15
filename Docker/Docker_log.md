# 自分のためのPython環境を作るためにDockerを使う (1)
## 背景
- WSL2でDockerが便利になったみたいです．
- これまでPythonの仮想環境は手作業でやってたけど，シェルスクリプトかDockerfile作れば楽だろうなと思いました．
- 今回はDockerの練習ついでにDockerを用いた環境構築を試行錯誤しながら行ってみます．
## 環境
### ホスト
- Windows10 Home
- WSL2
- Docker Desktopが導入済み
### 開発環境
- Ubuntu20.04
- Python3.8
- Pip for Python3
- pipenv
## 基本
- 参考
    - https://qiita.com/minato-naka/items/e9cd026747693759800c
        - 図がすごく分かりやすくてイメージが掴みやすいと思いました
- コンテナ
    - アプリケーションの実行環境
    - サーバのようなもの
- イメージ
    - コンテナの元になる設定ファイル
    - OSやミドルウェアなどの情報が入っている
- Docker Hub
    - Dockerのイメージを共有することのできるサービス
- Dockerfile
    - Dockerイメージを作成するための設定を記述したテキストファイル
## 準備: Docker Desktopを入れる
- 参考
    - https://qiita.com/KoKeCross/items/a6365af2594a102a817b
        - 私はこの通りにDocker Desktopを入れました．
## DockerでPython環境を作るための準備とログの記録
- 参考
    - https://blauthree.hatenablog.com/entry/2019/07/13/000839
- 以降PowerShell (Windows Terminal) を使います．
    - ">"はPowerShellとします．
### Dockerの起動
- Docker Desktopで"Start Docker Desktop when you log in"にチェックを入れるとPCにログインする度にdockerが起動するので楽です．
    ```
    > docker -v
    ```
    でDocker Versionが出力されたらOK．
### Ubuntuの導入
- Ubuntu20.04をインストール
    ```
    > docker pull ubuntu:20.04
    > docker images
    REPOSITORY                 TAG       IMAGE ID       CREATED       SIZE
    ubuntu                     20.04     f643c72bc252   7 weeks ago   72.9MB
    ```
- Dockerコンテナの作成と起動
    ```
    > docker run -it -d --name ubuntu20 ubuntu:20.04
    ```
    |オプション|動作|
    |--|--|
    |-it|ターミナルで操作可能にする|
    |-d|バックグラウンド実行|
    |--name|コンテナに名前を付ける|
    ```
    > docker ps -a
    CONTAINER ID   IMAGE          COMMAND       CREATED          STATUS                     PORTS     NAMES
    58c2f9d189ec   ubuntu:20.04   "/bin/bash"   11 seconds ago   Up 10 seconds                        ubuntu20
    ```
    - createとstartではSTATUSがExited(0)になったが，runではUpになった．
- コンテナへのログイン
    ```
    > docker exec -it ubuntu20 /bin/bash
    root@58c2f9d189ec:/# apt update && apt -y upgrade
    root@58c2f9d189ec:/# apt-get update
    root@58c2f9d189ec:/# cd
    ```
- 必要そうなものの導入
    ```
    root@58c2f9d189ec:~# apt-get -y install sudo curl wget gcc build-essential git vim
    ```
### Python環境の構築
- デフォルトではpython3もpipも入っていない
- python3とpython3-pipを入れる
    ```
    root@58c2f9d189ec:~/# apt install -y python3 python3-pip
    root@58c2f9d189ec:~/# python3 --version
    Python 3.8.5
    root@58c2f9d189ec:~/# pip3 --version
    pip 20.0.2 from /usr/lib/python3/dist-packages/pip (python 3.8)
    ```
- pipenvを入れる
    ```
    root@58c2f9d189ec:~# pip3 install pipenv
    root@58c2f9d189ec:~# pipenv --version
    pipenv, version 2020.11.15
    ```
- 仮想環境を作る
    ```
    root@58c2f9d189ec:~# mkdir Python_env && cd Python_env
    root@58c2f9d189ec:~/Python_env# pipenv --python 3
    root@58c2f9d189ec:~/Python_env# pipenv install --skip-lock numpy scipy matplotlib sympy pandas sklearn networkx pulp statsmodels
    ```
- 仮想環境に入って起動
    ```
    root@58c2f9d189ec:~/Python_env# pipenv shell
    (Python_env) root@58c2f9d189ec:~/Python_env# python
    Python 3.8.5 (default, Jul 28 2020, 12:59:40)
    [GCC 9.3.0] on linux
    Type "help", "copyright", "credits" or "license" for more information.
    >>> import numpy as np
    >>> import pulp
    ```
- ログアウトして，コンテナを停止
    ```
    (Python_env) root@58c2f9d189ec:~/Python_env# exit
    exit
    root@58c2f9d189ec:~/Python_env# exit
    exit
    > docker stop ubuntu20
    ubuntu20
    ```
### 削除
```
> docker rm ubuntu20
ubuntu20
```
## DockerFileの記述
- 先ほどのログをもとに，DockerFileを作る．
- PCの任意の場所に任意の名前のディレクトリを作成し，その中にDockerfileという名前を作成する．
    ```
    <directory path>/
        |- Dockerfile
    ```
    - 今回は，"Python_env"というディレクトリをWindowsのDocumentsディレクトリ直下に作り，その中にDockerfileを作ることにする．
    - 今回はPython関係の環境のみを書いたが，今後実用のために追加する．
    ```
    vim Dockerfile
    ```
    ```Docker
    # ベースとなるimage
    FROM ubuntu:20.04

    # RUN: コンテナ生成時に実行
    RUN apt update && apt -y upgrade
    RUN apt-get update
    RUN cd
    RUN apt install -y python3 python3-pip
    RUN pip3 install pipenv
    RUN mkdir Python_env && cd Python_env && \
            pipenv --python 3 && \
            pipenv install --skip-lock numpy scipy matplotlib sympy pandas sklearn networkx pulp statsmodels

    ```
- イメージの作成
    ```
    \Documents\Python_env> docker build -t ubuntu_python .
    ```
- 確認
    ```
    \Documents\Python_env> docker images
    REPOSITORY                 TAG       IMAGE ID       CREATED         SIZE
    ubuntu_python              latest    f452a4272355   2 minutes ago   1.13GB
    ```
- コンテナの作成，起動
    ```
    \Documents\Python_env> docker run -it -d --name ubuntu20_pyenv ubuntu_python
    \Documents\Python_env> docker ps -a
    CONTAINER ID   IMAGE           COMMAND       CREATED         STATUS                      PORTS     NAMES
    03d8af05dffa   ubuntu_python   "/bin/bash"   6 seconds ago   Up 5 seconds                          ubuntu20_pyenv
    ```
- ログイン
    ```
    \Documents\Python_env> docker exec -it ubuntu20_pyenv /bin/bash
    root@03d8af05dffa:/# ls
    Python_env  boot  etc   lib    lib64   media  opt   root  sbin  sys  usr
    bin         dev   home  lib32  libx32  mnt    proc  run   srv   tmp  var
    ```
    - 本当はPython_envはrootの下にできていてほしかった...
        - たぶんDockerfileのRUN cdでrootにいってない気がする
- 確認
    ```
    root@03d8af05dffa:/# cd Python_env/
    root@03d8af05dffa:/Python_env# pipenv shell
    (Python_env) root@03d8af05dffa:/Python_env# python
    Python 3.8.5 (default, Jul 28 2020, 12:59:40)
    [GCC 9.3.0] on linux
    Type "help", "copyright", "credits" or "license" for more information.
    >>> import numpy as np
    >>> import matplotlib.pyplot as plt
    ```
    - 一応上手くいってるみたいです．
## 他の環境から同じDockerfileで環境を作れるのかの確認
- WSL2上では作ることができましたが，他の環境にDockerfileを持っていったときにどうなるのかということが気になったので．作れるとは思うけど．
### テスト環境
- OS: Ubuntu18.04
- Docker導入済み
    - 参考: https://www.kkaneko.jp/tools/docker/ubuntu_docker.html
- イメージの作成
    ```
    $ docker build -t ubuntu_python .
    ...
    Successfully tagged ubuntu_python:latest
    ```
- 確認
    ```
    $ docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
    ubuntu_python       latest              9126b7a156f8        About a minute ago   1.13GB
    ```
    たぶん作れてます．
- コンテナの作成と起動
    ```
    $ docker run -it -d --name ubuntu_test_pyenv ubuntu_python
    $ docker ps -a
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
    1d6caac9b817        ubuntu_python       "/bin/bash"         9 seconds ago       Up 8 seconds                            ubuntu_test_pyenv
    ```
- ログイン
    ```
    $ docker exec -it ubuntu_test_pyenv /bin/bash
    root@1d6caac9b817:/# ls
    Python_env  boot  etc   lib    lib64   media  opt   root  sbin  sys  usr
    bin         dev   home  lib32  libx32  mnt    proc  run   srv   tmp  var
    ```
- 同じ環境が作れると思います．
## まとめと目標
- Dockerfileを作って環境構築するところまでできたと思う．
- ホームディレクトリにユーザディレクトリを作って，その直下で作業するのと，sudo権限与えるのとかをやりたい．
## 余談
- Ubuntu18でapt installでpipを入れると
    ```
    pip 9.0.1 from /usr/lib/python3/dist-packages (python 3.6)
    ```
    が入るけど，これupgrade pipでエラー吐くんですよね．
- だから研究室のUbuntu18にはapt経由ではなく，curlで入手したget-pip.py経由でpipを入れていました．
- Ubuntu20ではapt経由で入れてもpip 20が入るので良かったです．
    - (ただ，gccのバージョンが新しすぎて対応していないプログラムでエラーが出たり...)
    - ノートパソコンにUbuntu20を入れていたのですが，ちょくちょく落ちたり，書き込みエラーになったりしていたので，ノートパソコンに入れるOSはUbuntu18にしました．