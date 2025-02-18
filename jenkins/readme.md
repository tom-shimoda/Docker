# linux上のDockerから構築する場合
生成されるjenkins_homeフォルダの所有権がrootになり、アクセス違反でjenkinsが起動しないため以下コマンドで現在のユーザーに所有権変更
```
sudo chown -R ${USER}:${USER} jenkins_home
```
[参考](https://qiita.com/koiusa/items/62a144f545a11df165b1)



# Debianにmaster→ssh経由起動のslaveを立てる
(masterと同一マシン上にslaveを作成したからか、50000 portは使ってないっぽい。ufw等特に設定しなくてもいけた)
0. もしかしたらslaveクライアント実行に`sudo apt-get install default-jre`が必要かも

1. まずはslaveマシンでssh-keygen (今回は名前をjenkinsとした)

2. slaveマシンで`cat jenkins.pub >> authorized_keys`で公開鍵を登録し、`sudo systemctl restart sshd`実行
間違っても`>`にしない。上書きされてしまう。

3. Jenkinsページより、Jenkinsの管理 > Nodes > New node よりノード作成
Permanent Agentにはチェックいれる

4. 以下項目を設定
```
- リモートFSルート
slaveクライアントアプリの配置場所 (e.g. /home/owner/Documents/jenkins_slave/)
- 起動方法
SSH経由でUnixマシンのスレーブエージェントを起動
  - ホスト: slaveマシンのipアドレス等
  - 認証情報: 追加ボタン > jenkinsを選択し、以下を設定
    - 種類: SSHユーザー名と秘密鍵
    - ID: 空でよい
    - ユーザー名: slaveマシンのユーザー (e.g. owner)
    - 秘密鍵: 作成したssh秘密鍵(jenkins)の内容をペースト
    - パスフレーズ: ssh鍵作成時に設定したもの
  - Host Key Verification Strategy : Non verifying Verification Strategy
  - 可用性: Keep this agent online as much as possible
```



# wsl上にslaveを立てる方法 (masterノードをwslで立てるとユーザーがjenkinsとなりいろいろ不便なので基本的にjobはslaveで実行)
(50000 port はslave用らしい。sshでslave接続する場合はこのポートを使わないみたい？)

まずはjenkinsを立てて(masterノード)、[ここ](https://qiita.com/masatomix/items/6d751d361af760346383)を参考にslaveを追加する

リモートFSに`/home/user/Documents/jenkins_slave/jenkins_home`を設定した際の例
Documents
└── jenkins_slave
    └── jenkins_home (あらかじめフォルダを作成しておく)

# 次回以降のslave起動方法
必要に応じて./samples/start.shを修正してagent.jarと同階層に配置

リモートFSに`/home/user/Documents/jenkins_slave/jenkins_home`を設定した際の例
Documents
└── jenkins_slave
    ├── agent.jar (jenkinsに追加したslaveノードのページに記載されているcurlコマンドで手に入る)
    ├── jenkins_home
    └── start.sh

## start.shを直接たたく場合 (実行したshellを落とすとslaveが死ぬので注意)
```
sh start.sh &
```
後ろに&をつけて実行するとバックグラウンド実行となる
[参考](https://qiita.com/inosy22/items/341cfc589494b8211844)

&つけ忘れた場合、あとからバックグラウンド実行に切り替えることもできるらしい
[参考](https://qiita.com/SeiuchiAzarashi/items/82100102500c207ad9e5)
    1. ctrl+zで一時停止
    2. `bg`コマンドでバックグラウンド実行


## Windowsスタートアップ時に起動させる場合
win+r より`shell:startup`を入力し、./samples/wsl_docker_start.bat を配置 ("slaveの開始項目"が今回該当する部分)

