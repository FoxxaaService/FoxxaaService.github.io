@echo off
if not exist .\Kernel\7z.exe (
    echo=msgbox "Main File Missing .\Kernel\7z.exe" >>%worktemp%\Temp\ErrorReport.vbs
    %worktemp%\Temp\ErrorReport.vbs
    del /q %worktemp%\Temp\ErrorReport.vbs
    exit
)
if %workmode%==collectpack goto collectpack

:collectpack
if not exist %packfolder% (
    echo=msgbox "PackFolder %packfolder% is missing" >>%worktemp%\Temp\ErrorReport.vbs
    ping 127.0.0.1 -n 2 >nul
    %worktemp%\Temp\ErrorReport.vbs
    del /q %worktemp%\Temp\ErrorReport.vbs
    exit
)
if exist %packfile% (
    del /q %packfile%
)
set oldpath=%cd%
cd %packfolder% 
start %oldpath%\Kernel\7z.exe a %oldpath%\%packfile%
exit