# UbuntuにPython + Pipenvで仮想環境を作る
## はじめに
- UbuntuにPipenvを入れたときのメモ
- PipとPip3を共存させたかった
## Require
- Ubuntu18 または Ubuntu20
## Ubuntu 18の場合
- Python2でPipを入れてから，Python3.7を入れてPip3を入れる．
- Pip3でPipenvを入れる．
### Python2系とPipの導入
- Ubuntuを入れたとき，おそらくPython2系がデフォで使えなくなってる(2020.7.1現在)ので，インストールする．
    ```
    sudo apt install python
    ```
- get-pip.pyを用いてインストール (aptを使わない)
    ```
    curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
    sudo python get-pip.py
    ```
    この後に，
    ```
    pip -V
    ```
    として
    ```
    pip 20.1.1 from /usr/local/lib/python2.7/dist-packages/pip (python2.7)
    ```
    などと出てきたら良い．
### Python3.7とPipの導入
- 参考 (https://qiita.com/sabaku20XX/items/67eb69f006adbbf9c525)
    ```
    sudo apt install python3.7 python3.7-dev python3.7-distutils
    ```
    でPython3.7を入れる．
- get-pip.pyを用いてPip3をインストール
    ```
    python3.7 get-pip.py --user
    echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
    source ~/.bashrc
    ```
    とする．これは1行目でpython3.7でpipをuserディレクトリ以下に入れ，2, 3行目でパスを通している．
    ```
    pip3 -V
    ```
    として
    ```
    pip 20.1.1 from /home/user/.local/lib/python3.7/site-packages/pip (python 3.7)
    ```
    と出てきたら良い．
### Pipenvの導入
- Pip3系を使う
    ```
    pip3 install pipenv
    ```
    でpipenvを入れる．
    ```
    pipenv --version
    ```
    で，
    ```
    pipenv, version 2020.6.2
    ```
    などが出てきたら良い．

## Ubuntu 20の場合
- 参考 (https://linuxize.com/post/how-to-install-pip-on-ubuntu-20.04/)
### Pip3を入れる
- aptからpip for Python 3を入れる．
    ```
    sudo apt update
    sudo apt install python3-pip
    ```
- バージョン確認
    ```
    pip3 --version
    ```
    (output)
    ```
    pip 20.0.2 from /usr/lib/python3/dist-packages/pip (python 3.8)
    ```

### Pip2を入れる
- python2を入れる
    ```
    sudo add-apt-repository universe
    ```
    ```
    sudo apt update
    sudo apt install python2
    ```
- get-pip.pyをダウンロード
    ```
    curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
    ```
- python2で実行
    ```
    sudo python2 get-pip.py
    ```
- バージョン確認
    ```
    pip --version
    ```
    (output)
    ```
    pip 20.2.4 from /usr/local/lib/python2.7/dist-packages/pip (python 2.7)
    ```


## Pipenvのテスト
- ホームディレクトリ直下にテストディレクトリを作る．
    ```
    mkdir pytest && cd pytest
    ```
- 仮想環境を作る
    ```
    pipenv --python 3
    ```
    上記のコマンドを実行すると，pytestというディレクトリに仮想環境が構築される．
- パッケージを入れる
    - 例えば，numpy, sympy, scipyを入れる．
    ```
    pipenv install numpy sympy scipy
    ```
- 仮想環境に入る
    ```
    pipenv shell
    ```
    - プロンプト(ログインしているユーザ名やホスト名，カレントディレクトリ)の直前に(pytest)と表示されたら成功．
    - この中では，
        ```
        python ~.py
        ```
        とすると作った環境(今だとPython3.7系でnumpy, sympy, scipyが入っているもの)で~.pyに記述したスクリプトを実行できる．
- 仮想環境から出る
    ```
    exit
    ```
- 仮想環境を消す
    ```
    pipenv --rm
    ```
- 仮想環境のパスの確認
    ```
    pipenv --venv
    ```
- jupyterを使う
    ```
    pipenv install ipykernel jupyter
    ```
    - 仮想環境に入り，jupyterで使用するkernelを作成する
    ```
    pipenv shell
    python -m ipykernel install --user --name=[kernel_name]
    ```
    - 上記コマンドで作成したkernelを使うことができる．
