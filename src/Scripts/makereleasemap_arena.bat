SET VERSION=%1

del "E:\Projekte\dmdf\maps\releases\Arena\Arena%VERSION%.w3x"
cp "E:\Projekte\dmdf\maps\Arena.w3x" "E:\Projekte\dmdf\maps\releases\ArenaArena%VERSION%.w3x"
del "E:\Projekte\dmdf\maps\releases\Arena\war3map.wts"
cp "E:\Projekte\dmdf\maps\Arena\war3map_en.wts" "E:\Projekte\dmdf\maps\releases\Arena\war3map.wts"
del "E:\Projekte\dmdf\maps\releases\de\Arena%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Arena.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\Arena%VERSION%.w3x" --checkscriptstuff --exit