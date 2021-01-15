# Ubuntuをインストールしたときの諸々のコマンドをシェルスクリプトにまとめた
## 背景
- 私はちょくちょくOSをぶっ壊すので，OSをインストールしたときに実行するコマンドをシェルとして作れば楽だと思ったから．
- 今朝いきなりSSDの書き込みエラーが出てOSを入れ直したときにシェルスクリプトを作った．
## 環境
- 作成環境
    - Ubuntu 18.04 (laptop)
    - RAM 16GB
    - SSD 256GB
- テスト環境
    - Ubuntu 18.04 (VMWare)
    - RAM 4GB
    - 仮想HDD 20GB
## 作成したシェルスクリプト
- Chromeのインストール
- Atomとパッケージのインストール
- VSCodeとパッケージのインストール
- Python2, pipのインストール
- Python3.7, pip3のインストール (--user)
- pipenvのインストール
- Dockerのインストール
    ```shell
    #!/bin/bash

    # Written by SeeKT, 2021/1/15

    # This file is executed when installed Ubuntu 18.

    # To execute
    ## chmod 755 install_ubuntu_command.sh
    ## ./install_ubuntu_command.sh

    # Change Language
    eval $"LANG=C xdg-user-dirs-gtk-update"

    # Require password
    printf "password: "
    read -s password

    # Update and Upgrade
    echo "$password" | sudo -S apt update && sudo -S apt -y upgrade

    # Install Tools
    sudo -S apt -y install gnome-tweaks git vim wget curl perl

    # Install Chrome
    sudo -S sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    sudo -S wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo -S apt-key add -
    sudo -S apt update
    sudo -S apt -y install google-chrome-stable

    # Install Atom
    wget -qO - https://packagecloud.io/AtomEditor/atom/gpgkey | sudo apt-key add -
    sudo -S sh -c 'echo "deb [arch=amd64] https://packagecloud.io/AtomEditor/atom/any/ any main" > /etc/apt/sources.list.d/atom.list'
    sudo -S apt update
    sudo -S apt -y install atom
    ## Extension of Atom
    apm install latexer language-latex pdf-view

    # Install VSCode
    wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
    sudo -S add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
    sudo -S apt update
    sudo -S apt -y install code

    ## The package of VSCode
    pkglist=(
    ms-python.python
    ms-toolsai.jupyter
    bierner.markdown-preview-github-styles
    ms-azuretools.vscode-docker
    ms-vscode.cpptools
    goessner.mdmath
    donjayamanne.githistory
    mhutchie.git-graph
    phplasma.csv-to-table
    yzane.markdown-pdf
    )

    for i in ${pkglist[@]}; do
    code --install-extension $i
    done

    # Install Python2 and pip
    sudo -S apt-get update
    sudo -S apt -y install python
    curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
    sudo -S python get-pip.py

    # Install Python3.7 and pip
    sudo -S apt -y install python3.7 python3.7-dev python3.7-distutils
    ## modified when 2021.1.15
    ## python3.7 get-pip.py --user
    sudo -S python3.7 get-pip.py
    echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
    source ~/.bashrc
    pip3 install pipenv

    # Install Docker
    sudo -S apt update
    sudo -S apt -y upgrade
    ## Delete old version (if exists)
    sudo -S apt -y remove docker docker-engine docker.io containerd docker-ce docker-ce-cli
    sudo -S apt -y autoremove
    ## Install required software
    sudo -S apt update
    sudo -S apt -y install apt-transport-https ca-certificates curl software-properties-common
    sudo -S apt -y install linux-image-generic
    ## Set docker repository
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    apt-key fingerprint 0EBFCD88
    sudo -S add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -sc) \
        stable"
    sudo -S apt update
    ## Install docker.io
    sudo -S apt -y install docker.io containerd docker-compose
    ## Add authority
    sudo -S usermod -aG docker $USER
    ## Set autostart
    sudo -S systemctl unmask docker.service
    sudo -S systemctl enable docker
    sudo -S systemctl is-enabled docker
    ```
- sudoの後のオプション-Sは，パスワードを標準入力から読み込むというもの．一度入力させたらその後入力しなくても良いようにしたかった．
## テスト
- 上記のファイルをホームディレクトリ直下に作り，権限を与え，実行した．
- 仮想マシンだったからということもあり，最初のupdate && upgradeでかなり時間がかかり，累計30分程度要した．
    ![result](https://raw.githubusercontent.com/SeeKT/MyKnowledge/images/ubuntu_shell_result/rslt.PNG "結果")
- pipenvもpip3も入っていなかったので，python3.7のところで
    ```
    python3.7 get-pip.py --user -> sudo -S python3.7 get-pip.py
    ```
    とした．
## 感想
- 手作業でやっていたものを1回のコマンド実行でできるの楽．
- うまくいってない部分だけは手でやるのが良さそう．
- VSCodeとかAtomとかのパッケージもコマンドから入れることができるの便利．