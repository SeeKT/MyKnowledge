# 自分のためのPython環境を作るためにDockerを使う (2)
## 背景
- Dockerfileにワークスペースを変えるのとユーザ名を変えるのを記述したい．
## Dockerfileの作成
- 参考
    - https://www.usagi1975.com/201912212117/
- 今回は，localeを日本にして，さらにsudoを使えるユーザを追加したものを作りました．
- さらに，workspaceを/home/直下のworkディレクトリとしています．
- Dockerfile
    ```Docker
    #########################################################################
    # Dockerfile (to create my python environment)
    # Base: Ubuntu 20.04
    # To build
        # docker build -t <image name> -f Dockerfile .
    # To run (the first time)
        # docker run -it -d --name <container name> <image name>
    # To start
        # docker start <container name>
    # To stop
        # docker stop <container name>
    # To execute
        # docker exec -it <container name> /bin/bash
    #########################################################################

    # the base image
    FROM ubuntu:20.04

    # update and install requirement packages
    RUN apt-get update -qq \
        && apt-get install -y --no-install-recommends \
        sudo curl wget \
        ca-certificates language-pack-ja \
        gcc build-essential git vim

    # install python3
    RUN apt install -y python3 python3-pip
    RUN pip3 install pipenv

    # update locale
    RUN update-locale LANG=ja_JP.UTF-8

    # set env (Japanese)
    ENV LANG="ja_JP.UTF-8" \ 
        LANGUAGE="ja_JP:ja" \ 
        LC_ALL="ja_JP.UTF-8" \ 
        LC_ALL="ja_JP.UTF-8" \ 
        TZ="JST-9" \ 
        TERM="xterm"

    # add user
    ARG username=tcbn
    ARG wkdir=/home/work

    # echo "username:password" | chpasswd
    # root password is "root"
    RUN echo "root:root" | chpasswd && \
        adduser --disabled-password --gecos "" "${username}" && \
        echo "${username}:${username}" | chpasswd && \
        echo "%${username}    ALL=(ALL)   NOPASSWD:    ALL" >> /etc/sudoers.d/${username} && \
        chmod 0440 /etc/sudoers.d/${username} 

    # change workdir and user
    # /home/<wkdir>
    WORKDIR ${wkdir}
    RUN chown ${username}:${username} ${wkdir}
    USER ${username}
    ```
## 実行
- docker execで入ったところ，/home/work/に入っていました．
- python3, pip3, pipenvも入っています．
```bash
tcbn@f814e8d10b72:/home/work$ ls
tcbn@f814e8d10b72:/home/work$ python3 --version
Python 3.8.5
tcbn@f814e8d10b72:/home/work$ pip3 --version
pip 20.0.2 from /usr/lib/python3/dist-packages/pip (python 3.8)
tcbn@f814e8d10b72:/home/work$ pipenv --version
pipenv, version 2020.11.15
```
## 目標
- Dockerコンテナ内にSSH接続する
    - 参考
        - https://qiita.com/dcm_ishikawa/items/340d89ba0bbd123a9d2a