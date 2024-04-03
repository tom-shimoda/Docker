<# : by earthdiver1
@echo off & setlocal EnableDelayedExpansion
set BATCH_ARGS=%*
for %%A in (!BATCH_ARGS!) do set "ARG=%%~A" & set "ARG=!ARG:'=''!" & set "PWSH_ARGS=!PWSH_ARGS! "'!ARG!'""
endlocal &  Powershell -NoProfile -Command "$input|&([ScriptBlock]::Create((gc '%~f0'|Out-String)))" %PWSH_ARGS%
pause & exit/b
: #>

echo pass | wsl -- sudo -S service docker start
exit
