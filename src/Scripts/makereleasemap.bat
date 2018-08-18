SET VERSION=%1
SET CAMPAIGN_VERSION=%2
SET SOURCE_MAP_NAME=%3
SET TARGET_MAP_NAME=%4
SET TARGET_MAP_NAME_CAMPAIGN=%5

SET OPTIMIZER="F:\Projekte\dmdf\tools\5.0wc3mapoptimizer\VXJWTSOPT.exe"
SET SOURCE_MAP="F:\Projekte\dmdf\maps\%SOURCE_MAP_NAME%.w3x"
SET TARGET_MAP="F:\Projekte\dmdf\maps\releases\%TARGET_MAP_NAME%\%TARGET_MAP_NAME%%VERSION%.w3x"
SET TARGET_RELEASE_MAP="F:\Projekte\dmdf\maps\releases\de\%TARGET_MAP_NAME%%VERSION%.w3x"
SET TARGET_CAMPAIGN_MAP="F:\Projekte\dmdf\archive_de\Maps\TPoF\Campaign%CAMPAIGN_VERSION%\%TARGET_MAP_NAME_CAMPAIGN%.w3x"
SET SOURCE_STRINGS="F:\Projekte\dmdf\maps\%TARGET_MAP_NAME%\war3map_en.wts"
SET TARGET_STRINGS="F:\Projekte\dmdf\maps\releases\%TARGET_MAP_NAME%\war3map.wts"

del "%TARGET_MAP%"
copy "%SOURCE_MAP%" "%TARGET_MAP%"
del "%TARGET_STRINGS%"
copy "%SOURCE_STRINGS%" "%TARGET_STRINGS%"
del "%TARGET_RELEASE_MAP%"
"%OPTIMIZER%" --tweak "F:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "%SOURCE_MAP%" --do "%TARGET_RELEASE_MAP%" --checkscriptstuff --exit

IF NOT "%5"=="" (
    del "%TARGET_CAMPAIGN_MAP%"
    copy "%TARGET_RELEASE_MAP%" "%TARGET_CAMPAIGN_MAP%"
)