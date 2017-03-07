SET VERSION=%1

del "E:\Projekte\dmdf\maps\releases\en\WorldMap%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\releases\WorldMap\WorldMap%VERSION%.w3x" --do  "E:\Projekte\dmdf\maps\releases\en\WorldMap%VERSION%.w3x" --checkscriptstuff --exit
del "E:\Projekte\dmdf\maps\releases\en\WM.w3x"
cp "E:\Projekte\dmdf\maps\releases\en\WorldMap%VERSION%.w3x" "E:\Projekte\dmdf\maps\releases\en\WM.w3x"