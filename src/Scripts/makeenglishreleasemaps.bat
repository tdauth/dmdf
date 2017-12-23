REM Call this script after replacing the war3map.wts in all English maps. It will optimize the English translations.
REM The campaign maps (TL, HU etc.) have to be added to the English campaign TPoF.w3n by hand.
SET VERSION=1.0

start makeenglishreleasemap_arena.bat "%VERSION%"
start makeenglishreleasemap_credits.bat "%VERSION%"
start makeenglishreleasemap_deranor.bat "%VERSION%"
start makeenglishreleasemap_dornheim.bat "%VERSION%"
start makeenglishreleasemap_gardonar.bat "%VERSION%"
start makeenglishreleasemap_gardonarshell.bat "%VERSION%"
start makeenglishreleasemap_holzbruck.bat "%VERSION%"
start makeenglishreleasemap_holzbrucksunderworld.bat "%VERSION%"
start makeenglishreleasemap_talras.bat "%VERSION%"
start makeenglishreleasemap_thenorth.bat "%VERSION%"
start makeenglishreleasemap_worldmap.bat "%VERSION%"