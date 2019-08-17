@echo off

set roomid=%~1

IF NOT DEFINED roomid (
  echo HUYA Live Stream Recording Tool
  echo Usage: HSR [roomid OR URL]
  echo   example HSR 11342412
  echo           HSR https://www.huya.com/11342412
  echo   Version 1.0 by 007 2019.08
  exit /b
)

set roomid=%roomid: =%
set roomid=%roomid:https://www.huya.com/=%
set hlslivedl="%~dp0hlslivedl.exe"

set rdn=%random%_%random%_%random%
set user_agent=Mozilla/5.0 (Linux; Android 5.1.1; Nexus 6 Build/LYZ28E) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Mobile Safari/537.36
wget --header="User-Agent:%user_agent%" -i "https://m.huya.com/%roomid%" -q -Q1k -O info%rdn%.txt

type info%rdn%.txt|grep -Eo "hasvedio: '(.*)'"|sed "s/hasvedio: '//g"|sed "s/' ? '1' : '0'//g">tmp%rdn%.txt
(set /p hasvedio=)<tmp%rdn%.txt
del /Q tmp%rdn%.txt
del /Q info%rdn%.txt

echo Stream URL: %hasvedio%

set t=%time::=%
set t=%t: =0%
set savepath=%roomid%_%date:-=%-%t:~0,6%
IF NOT EXIST %savepath% md %savepath%
cd %savepath%

set cmd=%hlslivedl% -i "%hasvedio%" -o "_%roomid%_%savepath%.m3u8" 
echo   Make cmd: %cmd%
echo --- Press [Q] to stop download ---
%cmd%

cd ..
