SET VERSION=%1

del "F:\Projekte\dmdf\maps\releases\TheNorth\TheNorth%VERSION%.w3x"
copy "F:\Projekte\dmdf\maps\TheNorth.w3x" "F:\Projekte\dmdf\maps\releases\TheNorth\TheNorth%VERSION%.w3x"
del "F:\Projekte\dmdf\maps\releases\TheNorth\war3map.wts"
copy "F:\Projekte\dmdf\maps\TheNorth\war3map_en.wts" "F:\Projekte\dmdf\maps\releases\TheNorth\war3map.wts"
del "F:\Projekte\dmdf\maps\releases\de\TheNorth%VERSION%.w3x"
"F:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" --tweak "F:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "F:\Projekte\dmdf\maps\TheNorth.w3x" --do "F:\Projekte\dmdf\maps\releases\de\TheNorth%VERSION%.w3x" --checkscriptstuff --exit
del "F:\Projekte\dmdf\maps\releases\TN.w3x"
copy "F:\Projekte\dmdf\maps\releases\de\TheNorth%VERSION%.w3x" "F:\Projekte\dmdf\maps\releases\TN.w3x"