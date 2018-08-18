SET VERSION=%1
SET CAMPAIGN_VERSION=%2
SET MAP_NAME=%3
SET TARGET_MAP_NAME_CAMPAIGN=%4

SET OPTIMIZER="F:\Projekte\dmdf\tools\5.0wc3mapoptimizer\VXJWTSOPT.exe"
SET SOURCE_MAP="F:\Projekte\dmdf\maps\releases\%MAP_NAME%\%MAP_NAME%%VERSION%.w3x"
SET TARGET_RELEASE_MAP="F:\Projekte\dmdf\maps\releases\en\%MAP_NAME%%VERSION%.w3x"
SET TARGET_CAMPAIGN_MAP="F:\Projekte\dmdf\archive_en\Maps\TPoF\Campaign%CAMPAIGN_VERSION%\%TARGET_MAP_NAME_CAMPAIGN%.w3x"

del "%TARGET_RELEASE_MAP%"
"%OPTIMIZER%" --tweak "F:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "%SOURCE_MAP%" --do "%TARGET_RELEASE_MAP%" --checkscriptstuff --exit

IF NOT "%4"=="" (
    del "%TARGET_CAMPAIGN_MAP%"
    copy "%TARGET_RELEASE_MAP%" "%TARGET_CAMPAIGN_MAP%"
)