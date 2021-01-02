# VSCodeを使ってSSH接続先のファイルを編集したい
## はじめに
- SSH接続先(サーバ)のファイルを，接続元(クライアント)で編集したいと思った．
    - e.g. 仮想環境上のファイルをローカルのように編集したい
## 今回の目的
- KVM上に作った仮想環境にSSH接続する
## 今回の環境
- ホストOS
    - Ubuntu20
        - WindowsでもVirtual Boxを使えば同じようにできると思います
- ゲストOS
    - Fedora 33 Server
## 仮想環境の構築
- 参考
    - https://www.server-world.info/query?os=Ubuntu_20.04&p=kvm&f=3
### KVMのインストールと起動
- インストール
    ```
    sudo apt -y install virt-manager qemu-system
    ```
- 起動
    ```
    sudo virt-manager
    ```