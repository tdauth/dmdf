SET VERSION=%1

del "F:\Projekte\dmdf\maps\releases\en\Arena%VERSION%.w3x"
"F:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" --tweak "F:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "F:\Projekte\dmdf\maps\releases\Arena\Arena%VERSION%.w3x" --do "F:\Projekte\dmdf\maps\releases\en\Arena%VERSION%.w3x" --checkscriptstuff --exit