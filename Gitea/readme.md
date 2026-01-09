# gitea側 sshポートについて
environmentのSSH_PORTで指定した値がsshのポートとして使用される。
そのためポートフォワーディングでは
```
ports:
    - "ホスト側で使用したいポート:SSH_PORTで指定したポート"
```
となる。



# Tips

## gitea-data, mysql-dataを削除する場合
```sh
# ユーザー名、グループ名がownerの場合
sudo chown -R owner:owner gitea-data

rm -rf gitea-data
```

## .git/configの書き換えも必要
```
# .ssh/configにて以下のように記載した場合
Host gitea
  HostName <ipアドレス>
  User git
  Port 3022
  IdentityFile ~/.ssh/gitea_conoha


ssh://git@<ipアドレス>:3022/t.shimoda/jenkins-jobs.git
↓
ssh://gitea/t.shimoda/jenkins-jobs.git
```





↓ vpsでセットアップした感じあらかじめ作成しておかなくても良さそう。2025.2.10

-- 1. 同階層に以下フォルダを作成しておく --
    gitea-data/
    mysql-data/

