SET VERSION=%1

del "E:\Projekte\dmdf\maps\releases\TheNorth\TheNorth%VERSION%.w3x"
cp "E:\Projekte\dmdf\maps\TheNorth.w3x" "E:\Projekte\dmdf\maps\releases\TheNorth\TheNorth%VERSION%.w3x"
del "E:\Projekte\dmdf\maps\releases\TheNorth\TN.w3x"
cp "E:\Projekte\dmdf\maps\TheNorth.w3x" "E:\Projekte\dmdf\maps\releases\TheNorth\TN.w3x"
del "E:\Projekte\dmdf\maps\releases\TheNorth\war3map.wts"
cp "E:\Projekte\dmdf\maps\TheNorth\war3map_en.wts" "E:\Projekte\dmdf\maps\releases\TheNorth\war3map.wts"
del "E:\Projekte\dmdf\maps\releases\de\TheNorth%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\TheNorth.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\TheNorth%VERSION%.w3x" --checkscriptstuff --exit
del "E:\Projekte\dmdf\maps\releases\TN.w3x"
cp "E:\Projekte\dmdf\maps\releases\de\TheNorth%VERSION%.w3x" "E:\Projekte\dmdf\maps\releases\TN.w3x"