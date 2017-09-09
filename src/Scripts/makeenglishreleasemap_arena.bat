SET VERSION=%1

del "E:\Projekte\dmdf\maps\releases\en\Arena%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" --tweak "E:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "E:\Projekte\dmdf\maps\releases\Arena\Arena%VERSION%.w3x" --do "E:\Projekte\dmdf\maps\releases\en\Arena%VERSION%.w3x" --checkscriptstuff --exit