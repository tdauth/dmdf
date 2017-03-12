SET CLIJASSHELPER="E:\Warcraft III\jasshelper\clijasshelper.exe"
SET COMMONJ="E:\Projekte\asl\src\common.j"
SET BLIZZARDJ="E:\Projekte\asl\src\Blizzard.j"
SET OPTIONS=""
REM "--debug"

REM Apparently the JassHelper cannot run parallel.

savemap_dornheim.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% "E:\Warcraft III\"
savemap_talras.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% "E:\Warcraft III\"