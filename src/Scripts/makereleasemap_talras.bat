SET VERSION=%1
SET CAMPAIGN_VERSION=%2

del "F:\Projekte\dmdf\maps\releases\Talras\Talras%VERSION%.w3x"
copy "F:\Projekte\dmdf\maps\Karte 1 - Talras.w3x" "F:\Projekte\dmdf\maps\releases\Talras\Talras%VERSION%.w3x"
del "F:\Projekte\dmdf\maps\releases\Talras\war3map.wts"
copy "F:\Projekte\dmdf\maps\Talras\war3map_en.wts" "F:\Projekte\dmdf\maps\releases\Talras\war3map.wts"
del "F:\Projekte\dmdf\maps\releases\de\Talras%VERSION%.w3x"
"F:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" --tweak "F:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "F:\Projekte\dmdf\maps\Karte 1 - Talras.w3x" --do "F:\Projekte\dmdf\maps\releases\de\Talras%VERSION%.w3x" --checkscriptstuff --exit

SET TARGET_CAMPAIGN_MAP="F:\Projekte\dmdf\archive_de\Maps\TPoF\Campaign%CAMPAIGN_VERSION%\TL.w3x"
del "%TARGET_CAMPAIGN_MAP%"
copy "F:\Projekte\dmdf\maps\releases\de\Talras%VERSION%.w3x" "%TARGET_CAMPAIGN_MAP%"