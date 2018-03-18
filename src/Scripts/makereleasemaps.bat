REM Compresses all German maps and prepares the German maps to replace the war3map.wts file by the English one.
REM As soon as a Windows console based MPQ tool is available, just replace the war3map.wts files automatically and call makeenglishreleasemaps.bat afterwards.
REM At the moment this has to be done by hand.
REM The German campaign chapters are placed into "F:\Projekte\dmdf\archive_de\Maps\TPoF\Campaign%CAMPAIGN_VERSION%" and have to be added to the German War3Mod.mpq file by hand.
SET VERSION=1.0
SET CAMPAIGN_VERSION=10

start makereleasemap_arena.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makereleasemap_credits.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makereleasemap_deranor.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makereleasemap_dornheim.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makereleasemap_gardonar.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makereleasemap_gardonarshell.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makereleasemap_holzbruck.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makereleasemap_holzbrucksunderworld.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makereleasemap_talras.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makereleasemap_thenorth.bat "%VERSION%" "%CAMPAIGN_VERSION%"
start makereleasemap_worldmap.bat "%VERSION%" "%CAMPAIGN_VERSION%"