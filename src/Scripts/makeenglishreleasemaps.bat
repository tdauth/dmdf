REM Call this script after replacing the war3map.wts in all English maps. It will optimize the English translations.
REM The English campaign chapters are placed into "F:\Projekte\dmdf\archive_en\Maps\TPoF\Campaign%CAMPAIGN_VERSION%" and have to be added to the English War3Mod.mpq file by hand.
SET VERSION=1.0
SET CAMPAIGN_VERSION=10

start makeenglishreleasemap_arena.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makeenglishreleasemap_credits.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makeenglishreleasemap_deranor.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makeenglishreleasemap_dornheim.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makeenglishreleasemap_gardonar.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makeenglishreleasemap_gardonarshell.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makeenglishreleasemap_holzbruck.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makeenglishreleasemap_holzbrucksunderworld.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makeenglishreleasemap_talras.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makeenglishreleasemap_thenorth.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makeenglishreleasemap_worldmap.bat "%VERSION%" "%CAMPAIGN_VERSION%"