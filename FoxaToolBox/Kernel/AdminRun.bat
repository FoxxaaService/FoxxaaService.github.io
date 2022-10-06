@echo off
%1 mshta vbscript:CreateObject("Shell.Application").ShellExecute("%SetRun%","/c %~s0 ::","","runas",1)(window.close)  && exit
exit