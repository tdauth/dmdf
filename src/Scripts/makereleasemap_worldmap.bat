SET VERSION=%1

del "E:\Projekte\dmdf\maps\releases\WorldMap\WorldMap%VERSION%.w3x"
cp "E:\Projekte\dmdf\maps\WorldMap.w3x" "E:\Projekte\dmdf\maps\releases\WorldMap\WorldMap%VERSION%.w3x"
del "E:\Projekte\dmdf\maps\releases\WorldMap\war3map.wts"
cp "E:\Projekte\dmdf\maps\WorldMap\war3map_en.wts" "E:\Projekte\dmdf\maps\releases\WorldMap\war3map.wts"
del "E:\Projekte\dmdf\maps\releases\de\WorldMap%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" --tweak "E:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "E:\Projekte\dmdf\maps\WorldMap.w3x" --do "E:\Projekte\dmdf\maps\releases\de\WorldMap%VERSION%.w3x" --checkscriptstuff --exit
del "E:\Projekte\dmdf\maps\releases\WM.w3x"
cp "E:\Projekte\dmdf\maps\releases\de\WorldMap%VERSION%.w3x" "E:\Projekte\dmdf\maps\releases\WM.w3x"