:FoxaToolBox-BasicFormat
@echo off
cls
title Loading Data
echo= Loading Data...
set ROOT=%cd%
if %Phase%==Mode1 goto NextPartPhaseA
if %Phase%==Mode2 goto NextPartPhaseB
set/p worktemp=<.\Config\RunLoad-Settings\TempWorkTemp.cfg
if exist %worktemp% (
    rd /s /q %worktemp%
)
md %worktemp%\OutputLogs
md %worktemp%\SettingsData
md %worktemp%\Temp
set outlog=%worktemp%\OutputLogs\LoadPhase.log

set/p Version=<.\Config\FoxaToolBox-Data\CurrentVersion.cfg
set/p VersionCode=<.\Config\FoxaToolBox-Data\CVCode.cfg
set/p CoreVersion=<.\Config\FoxaToolBox-Data\CoreVersion.cfg

echo=[Start %time%] Current Version %Version% %VersionCode% >>%outlog%

if exist %ROOT%\WorkTemp.cfg (
    del /q %ROOT%\WorkTemp.cfg
)
echo=%worktemp% >>%ROOT%\WorkTemp.cfg
echo= Work Temp: %worktemp% >>%outlog%

::OutputData

::Windows Version
set SystemVersion=NotSupport
ver | find "Windows" > NUL && set SystemVersion=NotSupport
ver | find "5.0" > NUL && set SystemVersion=NotSupport
ver | find "5.1" > NUL && set SystemVersion=NotSupport
ver | find "5.2" > NUL && set SystemVersion=NotSupport
ver | find "6.0" > NUL && set SystemVersion=WindowsVista
ver | find "6.1" > NUL && set SystemVersion=Windows7
ver | find "6.2" > NUL && set SystemVersion=Windows8
ver | find "6.3" > NUL && set SystemVersion=Windows8.1
ver | find "10.0.1" >NUL && set SystemVersion=Windows10
ver | find "10.0.2" >NUL && set SystemVersion=Windows11
echo=%SystemVersion% >>%worktemp%\SettingsData\Winver.cfg

echo= Windows Version: %SystemVersion% >>%outlog%

::Windows File Check
if not exist %windir%\System32\ping.exe goto setfilemissing
if not exist %windir%\System32\systeminfo.exe goto setfilemissing
if not exist %windir%\System32\whoami.exe goto setfilemissing
set FileScan=Full
goto partnextA

:setfilemissing
echo= [Warning] Scan File Missing >>%outlog%
set FileScan=Failed
goto partnextA

:partnextA
::UserDisplay
whoami >>%worktemp%\SettingsData\WhoAmi.cfg
set/p LoginUser=<%worktemp%\SettingsData\WhoAmi.cfg
systeminfo >>%worktemp%\Temp\SystemInfo.cfg

:TypeSYSINFO
set SystemBit=x86
if exist %windir%\SysWOW64 (
    set SystemBit=x64
)
echo=%SystemBit% >>%worktemp%\SettingsData\SysBit.cfg

echo= OS Arch: %SystemBit% >>%outlog%

::Complete
set Phase=Mode1
if %SystemVersion%==NotSupport (
    start .\Dialog\SE-WU.exe
    exit
)
:NextPartPhaseA
set Phase=Mode2
if %FileScan%==Failed (
    start .\Dialog\SE-WF.exe
    exit
)
:NextPartPhaseB
if exist %worktemp%\Temp\AutoRun (
    rd /s /q %worktemp%\Temp\AutoRun
)
md %worktemp%\Temp\AutoRun
copy .\Config\AutoRun-List\*.cfg %worktemp%\Temp\AutoRun\*.cfg
:ReturnAutoRun
set BackPhase=ModeA
if not exist %worktemp%\Temp\AutoRun\*.cfg goto CompleteRun
ren %worktemp%\Temp\AutoRun\*.cfg START.cfg >nul 1>nul
set/p Run=<%worktemp%\Temp\AutoRun\START.cfg
del /q %worktemp%\Temp\AutoRun\START.cfg
if not exist %Run% (
    echo=File Not Found _%Run%_ >>%outlog%
    goto ReturnAutoRun
)
echo= Start %Run% >>%outlog%
start /b %Run%
ping 127.0.0.1 -n 2 >nul
goto ReturnAutoRun

:CompleteRun
rd /s /q %worktemp%\Temp\AutoRun
echo= Load Resources Complete >>%outlog%
exit
