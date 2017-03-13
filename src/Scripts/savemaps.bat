SET CLIJASSHELPER="E:\Warcraft III\jasshelper\clijasshelper.exe"
SET COMMONJ="E:\Projekte\asl\src\common.j"
SET BLIZZARDJ="E:\Projekte\asl\src\Blizzard.j"
SET OPTIONS="--debug"
REM "--debug"

REM Apparently the JassHelper cannot run parallel.
echo Warning: Saving the maps does not necessarily update the map script depending on the current script in the map's MPQ archive!

savemap_dornheim.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% "E:\Warcraft III\"
savemap_talras.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% "E:\Warcraft III\"
savemap_worldmap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% "E:\Warcraft III\"