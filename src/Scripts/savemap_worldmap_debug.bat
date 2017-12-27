SET CLIJASSHELPER="F:\wc3tools\Jass NewGen Pack Official\jasshelper\clijasshelper.exe"
SET PROJECT_DIR="F:\Projekte"
SET COMMONJ="%PROJECT_DIR%\dmdf\src\Asl\common.j"
SET BLIZZARDJ="%PROJECT_DIR%\dmdf\src\Asl\Blizzard.j"
SET OPTIONS="--debug"
SET DIR="%PROJECT_DIR%\dmdf\src\Scripts"
SET WORKING_DIR="F:\wc3tools\Jass NewGen Pack Official\jasshelper"

cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% %WORKING_DIR% "%PROJECT_DIR%\dmdf\maps\WorldMap.w3x" "%PROJECT_DIR%\dmdf\maps\WorldMap\war3map.j"
pause