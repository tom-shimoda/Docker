▼ windows側 管理者権限powershellにて
```sh
wsl -e hostname -I
```

▼ wsl側
```sh
ip a
```

で、eth0のipアドレスを確認。
このアドレスがconnectaddressに該当する。
