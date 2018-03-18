SET VERSION=%1
SET CAMPAIGN_VERSION=%2

del "F:\Projekte\dmdf\maps\releases\en\Dornheim%VERSION%.w3x"
"F:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" --tweak "F:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "F:\Projekte\dmdf\maps\releases\Dornheim\Dornheim%VERSION%.w3x" --do "F:\Projekte\dmdf\maps\releases\en\Dornheim%VERSION%.w3x" --checkscriptstuff --exit

SET TARGET_CAMPAIGN_MAP="F:\Projekte\dmdf\archive_en\Maps\TPoF\Campaign%CAMPAIGN_VERSION%\DH.w3x"
del "%TARGET_CAMPAIGN_MAP%"
copy "F:\Projekte\dmdf\maps\releases\en\Dornheim%VERSION%.w3x" "%TARGET_CAMPAIGN_MAP%"