param (
    [int]$listenPort
)

# ポートフォワーディング設定
netsh interface portproxy delete v4tov4 listenaddress=* listenport=$listenPort

# 設定できたか確認
netsh interface portproxy show all
