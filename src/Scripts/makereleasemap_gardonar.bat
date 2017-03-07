SET VERSION=%1

del "E:\Projekte\dmdf\maps\releases\Gardonar\Gardonar%VERSION%.w3x"
cp "E:\Projekte\dmdf\maps\Karte 2 - Gardonar.w3x" "E:\Projekte\dmdf\maps\releases\Gardonar\Gardonar%VERSION%.w3x"
del "E:\Projekte\dmdf\maps\releases\Gardonar\war3map.wts"
cp "E:\Projekte\dmdf\maps\Gardonar\war3map_en.wts" "E:\Projekte\dmdf\maps\releases\Gardonar\war3map.wts"
del "E:\Projekte\dmdf\maps\releases\de\Gardonar%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 2 - Gardonar.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\Gardonar%VERSION%.w3x" --checkscriptstuff --exit
del "E:\Projekte\dmdf\maps\releases\GA.w3x"
cp "E:\Projekte\dmdf\maps\releases\de\Gardonar%VERSION%.w3x" "E:\Projekte\dmdf\maps\releases\GA.w3x"