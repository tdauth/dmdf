SET CLIJASSHELPER="E:\Warcraft III\jasshelper\clijasshelper.exe"
SET COMMONJ="E:\Projekte\dmdf\src\Asl\common.j"
SET BLIZZARDJ="E:\Projekte\dmdf\src\Asl\Blizzard.j"
SET OPTIONS=""
SET DIR="E:\Projekte\dmdf\src\Scripts"
REM "--debug"

REM Apparently the JassHelper cannot run parallel.
echo Warning: Saving the maps does not necessarily update the map script depending on the current script in the map's MPQ archive!

cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% "E:\Warcraft III" "E:\Projekte\dmdf\maps\Arena.w3x"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% "E:\Warcraft III" "E:\Projekte\dmdf\maps\TheNorth.w3x"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% "E:\Warcraft III" "E:\Projekte\dmdf\maps\Tutorial.w3x"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% "E:\Warcraft III" "E:\Projekte\dmdf\maps\WorldMap.w3x"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% "E:\Warcraft III" "E:\Projekte\dmdf\maps\Karte 2 - Gardonar.w3x"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% "E:\Warcraft III" "E:\Projekte\dmdf\maps\Karte 2.1 - Gardonars Unterwelt.w3x"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% "E:\Warcraft III" "E:\Projekte\dmdf\maps\Karte 3 - Holzbruck.w3x"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% "E:\Warcraft III" "E:\Projekte\dmdf\maps\Karte 3.1 - Holzbrucks Unterwelt.w3x"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% "E:\Warcraft III" "E:\Projekte\dmdf\maps\Karte 4 - Karornwald.w3x"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% "E:\Warcraft III" "E:\Projekte\dmdf\maps\Karte 5 - Deranor.w3x"
cd %DIR%
call savemap.bat %CLIJASSHELPER% %COMMONJ% %BLIZZARDJ% %OPTIONS% "E:\Warcraft III" "E:\Projekte\dmdf\maps\Karte 1 - Talras.w3x"
pause