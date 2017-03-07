SET VERSION=%1

del "E:\Projekte\dmdf\maps\releases\Deranor\Deranor%VERSION%.w3x"
cp "E:\Projekte\dmdf\maps\Karte 5 - Deranor.w3x" "E:\Projekte\dmdf\maps\releases\Deranor\Deranor%VERSION%.w3x"
del "E:\Projekte\dmdf\maps\releases\Deranor\war3map.wts"
cp "E:\Projekte\dmdf\maps\Deranor\war3map_en.wts" "E:\Projekte\dmdf\maps\releases\Deranor\war3map.wts"
del "E:\Projekte\dmdf\maps\releases\de\Deranor%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 5 - Deranor.w3x" --do "E:\Projekte\dmdf\maps\releases\de\Deranor%VERSION%.w3x" --checkscriptstuff --exit
del "E:\Projekte\dmdf\maps\releases\DS.w3x"
cp "E:\Projekte\dmdf\maps\releases\de\Deranor%VERSION%.w3x" "E:\Projekte\dmdf\maps\releases\DS.w3x"