50000 port はslave用らしい。sshでslave接続する場合はこのポートを使わないみたい？

# wsl上にslaveを立てる方法 (masterノードをwslで立てるとユーザーがjenkinsとなりいろいろ不便なので基本的にjobはslaveで実行)
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
