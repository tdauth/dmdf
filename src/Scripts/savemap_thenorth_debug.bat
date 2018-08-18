SET PROJECT_DIR="F:\Projekte"
SET CLIJASSHELPER="%PROJECT_DIR%\dmdf\tools\JNGP\jasshelper\clijasshelper.exe"
SET COMMONJ="%PROJECT_DIR%\dmdf\src\Asl\common.j"
SET BLIZZARDJ="%PROJECT_DIR%\dmdf\src\Asl\Blizzard.j"
SET OPTIONS="--debug"
SET DIR="%PROJECT_DIR%\dmdf\src\Scripts"
SET WORKING_DIR="%PROJECT_DIR%\dmdf\tools\JNGP\jasshelper"

cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% %WORKING_DIR% "%PROJECT_DIR%\dmdf\maps\TheNorth.w3x" "%PROJECT_DIR%\dmdf\maps\TheNorth\war3map.j"
pause