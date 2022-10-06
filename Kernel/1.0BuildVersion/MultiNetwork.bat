@echo off
:waitback
ping 127.0.0.1 -n 2 >nul
if exist %worktemp%\Temp\Download-OCCUPY goto waitback
goto StartRun

:StartRun
echo=START >>%worktemp%\Temp\Download-OCCUPY
set outlog=%worktemp%\OutputLogs\MultiNetwork.log
echo= New Task : %commandcode% >>%outlog%
if %commandcode%==test goto testpart
if %commandcode%==download goto downloadpart
echo= [ERROR] _%commandcode%_ is not belong to MultiNetwork >>%outlog%
goto ExitPart

:testpart
echo= Test Network and Try Connect Internet >>%outlog%
if exist %worktemp%\SettingsData\InternetState.cfg (
    del /q %worktemp%\SettingsData\InternetState.cfg
)
if not exist .\Config\MultiNetwork-Client (
    echo=[Exception] Config Error .\Config\MultiNetwork-Client >>%outlog%
    echo=[Exception] Cannot Test Connect Server >>%outlog%
    echo=...................................................... >>%outlog%
    goto ExitPart
)
set/p VerifyCode=<.\Config\MultiNetwork-Client\VerifyCode.cfg
set/p VerifyServer=<.\Config\MultiNetwork-Client\VerifyServer.cfg
echo= VerifyServer: %VerifyServer% >>%outlog%
echo= VerifyCode: %VerifyCode% >>%outlog%

set URL=%VerifyServer%
set SavePath=%worktemp%\Temp\VerifyNetwork.test
set BackUnit=TestIntenetBack
set WorkMessage=Test Connect Internet
goto DownloadBlock

:downloadpart
echo= New Command Download >>%outlog%
echo= Download URL: %URL% >>%outlog%
echo= Save Path: %SavePath% >>%outlog%
set BackUnit=ExitPart
goto DownloadBlock


:DownloadBlock
if exist %worktemp%\Temp\DownloadReport.dat (
    del /q %worktemp%\Temp\DownloadReport.dat
)
echo= Start Download ... >>%outlog%
echo= Download Message: %WorkMessage% >>%outlog%
echo= Search Data >>%outlog%
if not exist .\Config\MultiNetwork-Engine\%SystemVersion%.cfg (
    echo=[Unsupported] Cannot Found Download Engine in Config >>%outlog%
    echo=[Unsupported] Add Your System in _.\Config\MultiNetwork-Engine_ Folder >>%outlog%
    echo= Download Failed >>%outlog%
    echo= ...................................................... >>%outlog%
    echo=FAILED >>%worktemp%\Temp\DownloadReport.dat
    goto %BackUnit%
)
set/p DEngine=<.\Config\MultiNetwork-Engine\%SystemVersion%.cfg
if %DEngine%==CertUtil goto CU-Download
if %DEngine%==PowerShell goto PS-Download
if %DEngine%==BitsAdmin goto BA-Download
echo=[Unsupported] MultiNetwork unsupported this engine >>%outlog%
echo=[Unsupported] Value : %DEngine% >>%outlog%
echo= Download Failed >>%outlog%
echo= ...................................................... >>%outlog%
echo=FAILED >>%worktemp%\Temp\DownloadReport.dat
goto %BackUnit%

:CU-Download
echo= Start Engine CertUtil >>%outlog%
echo= Use Command: certutil -urlcache -split -f %URL% %SavePath% >>%outlog%
echo= --------------------------------------------------- >>%outlog%
certutil -urlcache -split -f %URL% %SavePath% >>%outlog%
echo= --------------------------------------------------- >>%outlog%
if not exist %SavePath% (
    echo=[ERROR] Download Failed >>%outlog%
    echo=Please Check MN Log >>%outlog%
    echo= Download Failed >>%outlog%
    echo= ...................................................... >>%outlog%
    echo=FAILED >>%worktemp%\Temp\DownloadReport.dat
    goto %BackUnit%
)
echo= Download Complete >>%outlog%
echo=TRUE >>%worktemp%\Temp\DownloadReport.dat
goto %BackUnit%

:PS-Download
echo= Start Engine PowerShell >>%outlog%
echo= Use Command: powershell curl -o %SavePath% %URL% >>%outlog%
echo= --------------------------------------------------- >>%outlog%
powershell curl -o %SavePath% %URL% >>%outlog%
echo= --------------------------------------------------- >>%outlog%
if not exist %SavePath% (
    echo=[ERROR] Download Failed >>%outlog%
    echo=Please Check MN Log >>%outlog%
    echo= Download Failed >>%outlog%
    echo= ...................................................... >>%outlog%
    echo=FAILED >>%worktemp%\Temp\DownloadReport.dat
    goto %BackUnit%
)
echo= Download Complete >>%outlog%
echo=. >>%outlog%
echo=TRUE >>%worktemp%\Temp\DownloadReport.dat
goto %BackUnit%

:BA-Download
echo= Start Engine CertUtil >>%outlog%
echo= Use Command: bitsadmin /transfer myDownloadJob /download /priority normal %URL% %cd%\%SavePath% >>%outlog%
echo= --------------------------------------------------- >>%outlog%
bitsadmin /transfer myDownloadJob /download /priority normal %URL% %cd%\%SavePath% >>%outlog%
echo= --------------------------------------------------- >>%outlog%
if not exist %SavePath% (
    echo=[ERROR] Download Failed >>%outlog%
    echo=Please Check MN Log >>%outlog%
    echo= Download Failed >>%outlog%
    echo= ...................................................... >>%outlog%
    echo=FAILED >>%worktemp%\Temp\DownloadReport.dat
    goto %BackUnit%
)
echo= Download Complete >>%outlog%
echo=TRUE >>%worktemp%\Temp\DownloadReport.dat
goto %BackUnit%

:TestIntenetBack
set/p DownRP=<%worktemp%\Temp\DownloadReport.dat
del /q %worktemp%\Temp\DownloadReport.dat
if %DownRP%==FAILED goto TestNoConnect
set/p VCFound=<%worktemp%\Temp\VerifyNetwork.test
del /q %worktemp%\Temp\VerifyNetwork.test
if %VCFound%==%VerifyCode% goto PassTestConnect
goto TestNoConnect

:PassTestConnect
echo=Internet>>%worktemp%\SettingsData\InternetState.cfg
goto ExitPart

:TestNoConnect
echo=NoInternet>>%worktemp%\SettingsData\InternetState.cfg
goto ExitPart

:ExitPart
if exist %worktemp%\Temp\Download-OCCUPY (
    del /q %worktemp%\Temp\Download-OCCUPY
)
exit