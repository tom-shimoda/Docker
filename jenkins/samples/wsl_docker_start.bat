<# : by earthdiver1
@echo off & setlocal EnableDelayedExpansion
set BATCH_ARGS=%*
for %%A in (!BATCH_ARGS!) do set "ARG=%%~A" & set "ARG=!ARG:'=''!" & set "PWSH_ARGS=!PWSH_ARGS! "'!ARG!'""
endlocal &  Powershell -NoProfile -Command "$input|&([ScriptBlock]::Create((gc '%~f0'|Out-String)))" %PWSH_ARGS%
pause & exit/b
: #>

# -- = 残りのコマンド ラインをそのまま渡す (wsl --help 参照)
# -S = 標準入力でパスワードを読み込む (https://www.sejuku.net/blog/54857)
echo pass | wsl -- sudo -S service docker start

# slaveの開始
# -u = 実行ユーザー指定
echo pass | wsl -- sudo -u user -S sh /home/user/Documents/jenkins_slave/start.sh
exit
