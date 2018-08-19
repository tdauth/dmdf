REM Call this script after replacing the war3map.wts in all English maps. It will optimize the English translations.
REM The English campaign chapters are placed into "F:\Projekte\dmdf\archive_en\Maps\TPoF\Campaign%CAMPAIGN_VERSION%" and have to be added to the English War3Mod.mpq directory by hand.
SET VERSION=1.0
SET CAMPAIGN_VERSION=10

start makeenglishreleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "Arena"
start makeenglishreleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "Credits" "CT"
start makeenglishreleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "Deranor" "DS"
start makeenglishreleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "Dornheim" "DH"
start makeenglishreleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "Gardonar" "GA"
start makeenglishreleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "GardonarsHell" "GH"
start makeenglishreleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "Holzbruck" "HB"
start makeenglishreleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "HolzbrucksUnderworld" "HU"
start makeenglishreleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "Talras" "TL"
start makeenglishreleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "TheNorth" "TN"
start makeenglishreleasemap.bat "%VERSION%" "%CAMPAIGN_VERSION%" "WorldMap" "WM"