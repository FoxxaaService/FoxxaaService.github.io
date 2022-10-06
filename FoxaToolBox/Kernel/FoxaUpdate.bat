@echo off
set outlog=%worktemp%\OutputLogs\AUpdate.log
set workpack=.\AutoUpdateService
if %commandcode%==autocheck goto autocheck
if %commandcode%==installpack goto installpack
exit

:autocheck
echo= ------------------------------------------------------- >>%outlog%
echo= [%time%] Start Check Update >>%outlog%
set URL=https://foxaxudecvin.github.io/Link/LatestVersion.dat
set SavePath=%worktemp%\Temp\LatestVersion.dat
set WorkMessage=Check Update
echo= Connecting Update Server >>%outlog%
set commandcode=download
start /b .\Kernel\MultiNetwork.bat
:waitcomplete
ping 127.0.0.1 -n 2 >nul
if not exist %worktemp%\Temp\DownloadReport.dat goto waitcomplete
set/p DRMode=<%worktemp%\Temp\DownloadReport.dat
del /q %worktemp%\Temp\DownloadReport.dat
if %DRMode%==FAILED goto CheckFailed
echo= Download Successful... >>%outlog%
set/p LatestVersion=<%worktemp%\Temp\LatestVersion.dat
echo= LatestVersion: %LatestVersion% >>%outlog%
echo= LocalVersion: %CoreVersion% >>%outlog%
if %LatestVersion%==%CoreVersion% goto NoUpdateFound
set PackVersion=

:CheckFailed
echo= Check Update Failed -Internet Error >>%outlog%
if exist %worktemp%\TitleBar\Notificat-PhaseDeep.dat (
    del /q %worktemp%\TitleBar\Notificat-PhaseDeep.dat
)
echo= Check Update Failed >>%worktemp%\TitleBar\Notificat-PhaseDeep.dat
exit

:NoUpdateFound
echo=No Update was Found >>%outlog%
if exist %worktemp%\TitleBar\Notificat-PhaseDeep.dat (
    del /q %worktemp%\TitleBar\Notificat-PhaseDeep.dat
)
echo= No Update was found >>%worktemp%\TitleBar\Notificat-PhaseDeep.dat
exit