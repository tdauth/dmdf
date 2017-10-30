SET CLIJASSHELPER="F:\Warcraft III\jasshelper\clijasshelper.exe"
SET PROJECT_DIR="F:\Projekte"
SET COMMONJ="%PROJECT_DIR%\dmdf\src\Asl\common.j"
SET BLIZZARDJ="%PROJECT_DIR%\dmdf\src\Asl\Blizzard.j"
SET OPTIONS=""
SET DIR="%PROJECT_DIR%\dmdf\src\Scripts"
SET WORKING_DIR="F:\Warcraft III"
REM "--debug"

REM Apparently the JassHelper cannot run parallel.

cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% %WORKING_DIR% "%PROJECT_DIR%\dmdf\maps\Arena.w3x" "%PROJECT_DIR%\dmdf\maps\Arena\war3map.j"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% %WORKING_DIR% "%PROJECT_DIR%\dmdf\maps\TheNorth.w3x" "%PROJECT_DIR%\dmdf\maps\TheNorth\war3map.j"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% %WORKING_DIR% "%PROJECT_DIR%\dmdf\maps\Tutorial.w3x" "%PROJECT_DIR%\dmdf\maps\Tutorials\war3map.j"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% %WORKING_DIR% "%PROJECT_DIR%\dmdf\maps\WorldMap.w3x" "%PROJECT_DIR%\dmdf\maps\WorldMap\war3map.j"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% %WORKING_DIR% "%PROJECT_DIR%\dmdf\maps\Karte 2 - Gardonar.w3x" "%PROJECT_DIR%\dmdf\maps\Gardonar\war3map.j"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% %WORKING_DIR% "%PROJECT_DIR%\dmdf\maps\Karte 2.1 - Gardonars Unterwelt.w3x" "%PROJECT_DIR%\dmdf\maps\GardonarsHell\war3map.j"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% %WORKING_DIR% "%PROJECT_DIR%\dmdf\maps\Karte 3 - Holzbruck.w3x" "%PROJECT_DIR%\dmdf\maps\Holzbruck\war3map.j"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% %WORKING_DIR% "%PROJECT_DIR%\dmdf\maps\Karte 3.1 - Holzbrucks Unterwelt.w3x" "%PROJECT_DIR%\dmdf\maps\HolzbrucksUnderworld\war3map.j"
REM cd %DIR%
REM call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% %WORKING_DIR% "%PROJECT_DIR%\dmdf\maps\Karte 4 - Karornwald.w3x"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% %WORKING_DIR% "%PROJECT_DIR%\dmdf\maps\Karte 5 - Deranor.w3x" "%PROJECT_DIR%\dmdf\maps\Deranor\war3map.j"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% %WORKING_DIR% "%PROJECT_DIR%\dmdf\maps\Karte 1 - Talras.w3x" "%PROJECT_DIR%\dmdf\maps\Talras\war3map.j"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% %WORKING_DIR% "%PROJECT_DIR%\dmdf\maps\Credits.w3x" "%PROJECT_DIR%\dmdf\maps\Credits\war3map.j"
pause