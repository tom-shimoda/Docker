param (
    [int]$listenPort,
    [int]$connectPort,
    [string]$connectAddress = "192.168.0.1"
)

# ポートフォワーディング設定
netsh interface portproxy add v4tov4 listenaddress=* listenport=$listenPort connectaddress=$connectAddress connectport=$connectPort

# 設定できたか確認
netsh interface portproxy show all
