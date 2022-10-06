@echo off
title Scan Info
set/p HeadMsg=<.\Config\TitleBar-Config\HeadMessage.cfg
set/p HN=<.\Config\TitleBar-Config\HideNotification.cfg
set/p HT=<.\Config\TitleBar-Config\HideTime.cfg
set workroot=%worktemp%\TitleBar
if exist %workroot% (
    rd /s /q %workroot%
)
md %workroot%

:ReDisplay
set/p HeadMsg=<.\Config\TitleBar-Config\HeadMessage.cfg
set/p HN=<.\Config\TitleBar-Config\HideNotification.cfg
set/p HT=<.\Config\TitleBar-Config\HideTime.cfg
if exist %workroot%\Effect-PhaseTop.dat (
    del /q %workroot%\Effect-PhaseTop.dat
)
copy .\Config\TitleBar-Config\EffectMessage.cfg %workroot%\Effect-PhaseDeep.dat >nul


:Reload
if exist %worktemp%\Temp\StopTopBar (
    del /q %worktemp%\Temp\StopTopBar
    exit
)
if not exist %workroot%\Effect-PhaseDeep.dat (
    set EffectBar=Fault
)

if exist %workroot%\Effect-PhaseDeep.dat (
    set/p EffectBar=<%workroot%\Effect-PhaseDeep.dat
)
if exist %workroot%\Effect-PhaseTop.dat (
    set/p EffectBar=<%workroot%\Effect-PhaseTop.dat
)

if not exist %workroot%\Notificat-PhaseDeep.dat (
    set NotificatBar=Free
)

if exist %workroot%\Notificat-PhaseDeep.dat (
    set/p NotificatBar=<%workroot%\Notificat-PhaseDeep.dat
)
if exist %workroot%\Notificat-PhaseTop.dat (
    set/p NotificatBar=<%workroot%\Notificat-PhaseTop.dat
)

::Internet Check
if not exist %worktemp%\SettingsData\InternetState.cfg (
    set Internet=Unknown
)

if exist %worktemp%\SettingsData\InternetState.cfg (
    set/p Internet=<%worktemp%\SettingsData\InternetState.cfg
)

:Display
if %HT%==%HN% goto SameBarMode

:DisplayPhaseB
if %HT%==open goto NoTimeBarMode
if %HN%==open goto NoNotificatBarMode
goto FullBarMode

:FullBarMode
title %HeadMsg% /  %EffectBar%  /  %NotificatBar% [%Internet%] [%time%]
ping 127.0.0.1 -n 2 >nul 1>nul
goto Reload

:NoTimeBarMode
title %HeadMsg% /  %EffectBar%  /  %NotificatBar% [%Internet%]
ping 127.0.0.1 -n 2 >nul 1>nul
goto Reload

:NoNotificatBarMode
title %HeadMsg% /  %EffectBar%  /  [%time%]
ping 127.0.0.1 -n 2 >nul 1>nul
goto Reload

:SameBarMode
if %HT%==off goto FullBarMode
title %HeadMsg% /  %EffectBar%  / %Version% %VersionCode%
ping 127.0.0.1 -n 2 >nul 1>nul
goto Reload