REM Compresses all German maps and prepares the German maps to replace the war3map.wts file by the English one.
REM As soon as a Windows console based MPQ tool is available, just replace the war3map.wts files automatically and call makeenglishreleasemaps.bat afterwards.
REM At the moment this has to be done by hand.
REM The German campaign chapters are placed into "F:\Projekte\dmdf\archive_de\Maps\TPoF\Campaign%CAMPAIGN_VERSION%" and have to be added to the German War3Mod.mpq directory by hand.
SET VERSION=1.0
SET CAMPAIGN_VERSION=10

start makereleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "Arena" "Arena"
start makereleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "Credits" "Credits" "CT"
start makereleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "Karte 5 - Deranor" "Deranor" "DS"
start makereleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "Tutorial" "Dornheim" "DH"
start makereleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "Karte 2 - Gardonar" "Gardonar" "GA"
start makereleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "Karte 2.1 - Gardonars Unterwelt" "GardonarsHell" "GH"
start makereleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "Karte 3 - Holzbruck" "Holzbruck" "HB"
start makereleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "Karte 3.1 - Holzbrucks Unterwelt" "HolzbrucksUnderworld" "HU"
start makereleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "Karte 1 - Talras" "Talras" "TL"
start makereleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "TheNorth" "TheNorth" "TN"
start makereleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "WorldMap" "WorldMap" "WM"