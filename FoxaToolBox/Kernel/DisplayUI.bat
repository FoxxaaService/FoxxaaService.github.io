@echo off
if %BackPhase%==ModeB goto BackShell
cls
start /b .\Kernel\TitleBar.bat
:ReloadScreen
set WorkDir=ShellExplorer
goto MainScreen

:MainScreen
if %BackPhase%==ModeB goto BackShell
type .\Text\DisplayUI-Main.text
echo= FoxaToolBox %Version% %VersionCode%
:BackShell
set BackPhase==ModeA
echo=
set/p "commandcode= $ %WorkDir%>"
set BackUnit=BackShell
if %commandcode%==help goto help
if %commandcode%==flush goto flush
if %commandcode%==admin goto admin
if %commandcode%==ver goto ver
if %commandcode%==outdata goto outdata
if %commandcode%==reload goto reload
if %commandcode%==exit goto exit
set BackPhase=ModeB
start /b .\Kernel\ListTools.bat
exit

:help
echo=
if not exist .\Text\DisplayUI-Helps.text (
    echo= Text File Missing
    echo= File: .\Text\DisplayUI-Helps.text 
    goto %BackUnit%
) 
type .\Text\DisplayUI-Helps.text
echo=
goto %BackUnit%

:flush
cls
type .\Text\DisplayUI-Flush.text
echo=
ping 127.0.0.1 -n 2 >nul
start /b .\Config\RunExtend-Code\TSInternet.bat
cls
goto ReloadScreen

:admin
if not exist .\Kernel\AdminRun.bat (
    echo=Failed to Try Load File _.\Kernel\AdminRun.bat_
    echo=Please Run Repair Script
    goto %BackUnit%
)
set SetRun=.\FoxaToolBox.exe
echo=o >>%worktemp%\Temp\StopTopBar
start /b .\Kernel\AdminRun.bat
exit

:ver
echo=
echo= FoxaToolBox %Version% %VersionCode%
echo= Copyright FoxaXuDecvin. Core Version: %CoreVersion%
echo= Windows Version : %SystemVersion% %SystemBit%
echo= Work in %LoginUser%
goto BackShell

:outdata
echo= Type Save Path
set/p "savepath= $ %WorkDir%\SelectPath>"
set workmode=collectpack
set packfolder=%worktemp%
set packfile=%savepath%
if not exist .\Kernel\7zPackEditor.bat (
    echo= Kernel File .\Kernel\7zPackEditor.bat is Missing
    echo= Please Run Repair and Try again
    goto BackShell
)
start /b .\Kernel\7zPackEditor.bat
ping 127.0.0.1 >nul
goto BackShell

:reload
echo=o >>%worktemp%\Temp\StopTopBar
ping 127.0.0.1 -n 3 >nul
Set Phase=0
start /b .\Kernel\LoadResource.bat
exit

:exit
cls
echo= Close Kernel...
ping 127.0.0.1 -n 2 >nul
echo=o >>%worktemp%\Temp\StopTopBar
exit