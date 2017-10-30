SET VERSION=%1

del "F:\Projekte\dmdf\maps\releases\WorldMap\WorldMap%VERSION%.w3x"
copy "F:\Projekte\dmdf\maps\WorldMap.w3x" "F:\Projekte\dmdf\maps\releases\WorldMap\WorldMap%VERSION%.w3x"
del "F:\Projekte\dmdf\maps\releases\WorldMap\war3map.wts"
copy "F:\Projekte\dmdf\maps\WorldMap\war3map_en.wts" "F:\Projekte\dmdf\maps\releases\WorldMap\war3map.wts"
del "F:\Projekte\dmdf\maps\releases\de\WorldMap%VERSION%.w3x"
"F:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" --tweak "F:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "F:\Projekte\dmdf\maps\WorldMap.w3x" --do "F:\Projekte\dmdf\maps\releases\de\WorldMap%VERSION%.w3x" --checkscriptstuff --exit
del "F:\Projekte\dmdf\maps\releases\WM.w3x"
copy "F:\Projekte\dmdf\maps\releases\de\WorldMap%VERSION%.w3x" "F:\Projekte\dmdf\maps\releases\WM.w3x"