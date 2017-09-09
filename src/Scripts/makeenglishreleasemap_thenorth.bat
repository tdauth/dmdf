SET VERSION=%1

del "E:\Projekte\dmdf\maps\releases\en\TheNorth%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" --tweak "E:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "E:\Projekte\dmdf\maps\releases\TheNorth\TheNorth%VERSION%.w3x" --do "E:\Projekte\dmdf\maps\releases\en\TheNorth%VERSION%.w3x" --checkscriptstuff --exit
del "E:\Projekte\dmdf\maps\releases\en\TN.w3x"
cp "E:\Projekte\dmdf\maps\releases\en\TheNorth%VERSION%.w3x" "E:\Projekte\dmdf\maps\releases\en\TN.w3x"