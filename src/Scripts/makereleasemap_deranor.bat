SET VERSION=%1
SET CAMPAIGN_VERSION=%2

del "F:\Projekte\dmdf\maps\releases\Deranor\Deranor%VERSION%.w3x"
copy "F:\Projekte\dmdf\maps\Karte 5 - Deranor.w3x" "F:\Projekte\dmdf\maps\releases\Deranor\Deranor%VERSION%.w3x"
del "F:\Projekte\dmdf\maps\releases\Deranor\war3map.wts"
copy "F:\Projekte\dmdf\maps\Deranor\war3map_en.wts" "F:\Projekte\dmdf\maps\releases\Deranor\war3map.wts"
del "F:\Projekte\dmdf\maps\releases\de\Deranor%VERSION%.w3x"
"F:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" --tweak "F:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "F:\Projekte\dmdf\maps\Karte 5 - Deranor.w3x" --do "F:\Projekte\dmdf\maps\releases\de\Deranor%VERSION%.w3x" --checkscriptstuff --exit

SET TARGET_CAMPAIGN_MAP="F:\Projekte\dmdf\archive_de\Maps\TPoF\Campaign%CAMPAIGN_VERSION%\DS.w3x"
del "%TARGET_CAMPAIGN_MAP%"
copy "F:\Projekte\dmdf\maps\releases\de\Deranor%VERSION%.w3x" "%TARGET_CAMPAIGN_MAP%"