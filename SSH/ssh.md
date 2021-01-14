# VSCodeを使ってSSH接続先のファイルを編集したい
## はじめに
- SSH接続先(サーバ)のファイルを，接続元(クライアント)で編集したいと思った．
    - e.g. 仮想環境上のファイルをローカルのように編集したい
## 今回の目的
- KVM上に作った仮想環境にSSH接続する
    - これと同様のやり方でssh接続したリモートのマシン上のファイルを手元で編集するみたいなことができるはず
## 今回の環境
- ホストOS
    - Ubuntu20
        - WindowsでもVirtual Boxを使えば同じようにできると思う
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
    ![kvm_manager](https://raw.githubusercontent.com/SeeKT/MyKnowledge/images/vm_ssh/kvm_manager.png "仮想マシンマネージャー")
### 仮想OSのインストール
- Fedora 33 ServerのISOイメージをダウンロード 
    - https://getfedora.org/ja/server/download/
- 仮想マシンマネージャーの左側の「新しい仮想マシンの作成」から指示に従って仮想マシンを作る．
    - ISOイメージの指定とかメモリとか
- 仮想マシンの起動，OSのインストール
    ![kvm_install](https://raw.githubusercontent.com/SeeKT/MyKnowledge/images/vm_ssh/install_fedora.png "OSのインストール")
    - 今回はユーザ名をtcbnとして，管理者権限を与えている．
- 再起動後にIPアドレスを見る
    ![kvm_ip](https://raw.githubusercontent.com/SeeKT/MyKnowledge/images/vm_ssh/fedora_localhost.png "IPアドレス")
    - 今回は192.168.122.149だった．
## SSH接続
### SSH接続のテスト
- Terminal (Windowsの場合はコマンドプロンプト/PowerShell) から以下のコマンドを実行
    ```
    ssh <user_name>@<IP_address>
    ```
    - 今回は
        ```
        ssh tcbn@192.168.122.149
        ```
- 実行後fingerprintに関して支障がなければyesとして接続できたらok
    ![kvm_ssh](https://raw.githubusercontent.com/SeeKT/MyKnowledge/images/vm_ssh/fedora_ssh.png "SSH接続")

### VSCodeを用いる
- 参考
    - https://blog.masahiko.info/entry/2019/06/15/202003
- 拡張機能 Remote - SSH をinstall．
    ![kvm_ssh](https://raw.githubusercontent.com/SeeKT/MyKnowledge/images/vm_ssh/remote_ssh.png "Remote SSH")
- config ファイルを作る
    ![kvm_config](https://raw.githubusercontent.com/SeeKT/MyKnowledge/images/vm_ssh/config.png "config")
    - F1 → Remote - SSH Connect to Host → Config
- 左下の"Open a Remote Window" → Connect to the host → 先ほど設定したもの → パスワードを入力
    ![kvm_config](https://raw.githubusercontent.com/SeeKT/MyKnowledge/images/vm_ssh/ssh_vscode.png "VSCodeで接続")
    - 普段VSCodeを使っているときのような使用感でSSH接続先のファイルを編集できる

## おまけ
### ファイルのやり取り
- ローカルからリモート
    ```
    scp (-r) [local path] [user@remotehost:path]
    ```
- リモートからローカル
    ```
    scp (-r) [user@remotehost:path] [local path]
    ```