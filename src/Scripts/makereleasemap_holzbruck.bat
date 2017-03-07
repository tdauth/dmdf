SET VERSION=%1

del "E:\Projekte\dmdf\maps\releases\Holzbruck\Holzbruck%VERSION%.w3x"
cp "E:\Projekte\dmdf\maps\Karte 3 - Holzbruck.w3x" "E:\Projekte\dmdf\maps\releases\Holzbruck\Holzbruck%VERSION%.w3x"
del "E:\Projekte\dmdf\maps\releases\Holzbruck\war3map.wts"
cp "E:\Projekte\dmdf\maps\Holzbruck\war3map_en.wts" "E:\Projekte\dmdf\maps\releases\Holzbruck\war3map.wts"
del "E:\Projekte\dmdf\maps\releases\de\Holzbruck%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 3 - Holzbruck.w3x" --do "E:\Projekte\dmdf\maps\releases\de\Holzbruck%VERSION%.w3x" --checkscriptstuff --exit
del "E:\Projekte\dmdf\maps\releases\HB.w3x"
cp "E:\Projekte\dmdf\maps\releases\de\Holzbruck%VERSION%.w3x" "E:\Projekte\dmdf\maps\releases\HB.w3x"