** 以下では、~/Documents/Github/Docker/jenkins に配置した場合の手順を記す **
** またagent=旧slave である **


# 1. まずはwsl上でjenkins masterノードをセットアップ
```sh
# dockerに作らせると権限を後で直さなきゃいけなくなるので、あらかじめ作成しておく
mkdir jenkins_home

# jenkinsコンテナ起動
sudo docker compose up -d
```


# 2. ポートフォワーディング
`tips/how_to_port_forwarding`を参考に


# 3. windows 立ち上げ時に wsl が起動するように
## 1. WSL で systemd を有効化（1回だけ）
```sh
/etc/wsl.conf を編集：

[boot]
systemd=true
```

## 2. Windows 側で WSL 再起動
```sh
# シャットダウン
wsl --shutdown

# 起動
wsl

```

## 3. Docker を systemd 自動起動にする
```sh
# wsl側
sudo systemctl enable docker
```

## 4. Windows タスクスケジューラで wsl を自動起動するよう設定
### タスク スケジューラ 起動
    「基本タスクの作成」ではなく「タスクの作成」
#### 全般 タブ
名前：Start WSL
✔「ユーザーがログオンしているかどうかにかかわらず実行」
✔「最上位の特権で実行」
Configure for: Windows Server 2025

#### トリガー タブ
下の New... ボタンから作成。

Begin the task：スタートアップ時

#### 操作 (Action) タブ
下の New... ボタンから作成。

Action：Start a program
Program/script: wsl.exe (絶対パスじゃなくとも動く)

#### 条件 Conditions) タブ
「AC電源～」は必要に応じて外す


# 4. sshキー作成＆登録
## wsl側
```sh
# アクセスに使用するsshキーはjenkinsコンテナ内に配置する必要がある
cd ~/Documents/Github/Docker/jenkins/jenkins_home
mkdir .ssh
cd .ssh

# id_ed25519 を作成。~/.ssh/ に生成されるので移動する
ssh-keygen

# sshキーを移動
mv ~/.ssh/id_ed25519 .
mv ~/.ssh/id_ed25519.pub .
```

## windows側
```sh
# 以下を実行してauthorized_keysの場所を確認
Get-Content "$env:ProgramData\ssh\sshd_config" | Select-String -Pattern "AuthorizedKeysFile"

# AuthorizedKeysFile      .ssh/authorized_keys
#        AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys
# と出力されたら、現在のユーザーの ~/.ssh/authorized_keys は使用されいないので次の手順に進む


# administrators_authorized_keys を編集
cd C:\ProgramData\ssh
touch administrators_authorized_keys

# administrators_authorized_keys に先程移動したpubキーの内容を追加
cat ~/Documents/Github/Docker/jenkins/jenkins_home/.ssh/id_ed25519.pub | clip
```


# 5. jenkins 設定より agent ノードを作成
## 以下、変更が必要な部分
- リモートFS
    C:\Jenkins
- 起動方法
    SSH経由でUnixマシンのスレーブエージェントを起動
    - ホスト
        ip address
    - 認証情報
        ユーザー名
    - Host Key Verification Strategy ※ 重要! デフォルト設定のままだとknown_hostに登録先にしかアクセスできない
        Non verifying Verification Strategy

設定完了すると自動でノード接続が開始される
