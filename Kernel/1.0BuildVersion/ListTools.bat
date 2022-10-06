@echo off
if %commandcode%==helptool goto helptool
if %commandcode%==exit goto exit
if %commandcode%==lstools goto lstools
if exist .\Config\ExtendProgram-Register\%commandcode%.cfg goto RunConfig
echo=
type .\Text\ListTools-UC.text
echo=
goto BackUI

:RunConfig
set/p RunExtend=<.\Config\ExtendProgram-Register\%commandcode%.cfg
if not exist Extend\%RunExtend% (
    echo=
    echo= [ERROR] Program File is missing
    echo= Config data "%RunExtend%"
    goto BackUI
)
set/p AdminOption=<.\Extend\%RunExtend%
if %AdminOption%==setAdminEnabled goto AdminRun
echo= Path .\Extend\%RunExtend%
start .\Extend\%RunExtend%
goto BackUI

:AdminRun
set SetRun=.\Extend\%RunExtend%
start /b .\Kernel\AdminRun.bat
goto BackUI

:lstools
dir .\Config\ExtendProgram-Register
goto BackUI

:helptool
echo=
if not exist .\Text\ListTools-Helps.text (
    echo= Text File Missing
    echo= File: .\Text\ListTools-Helps.text 
    goto BackUI
) 
type .\Text\ListTools-Helps.text
echo=
goto BackUI

:BackUI
start /b .\Kernel\DisplayUI.bat
exit