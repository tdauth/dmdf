SET VERSION=0.7

del "E:\Projekte\dmdf\maps\releases\Talras%VERSION%.w3x"
cp "E:\Projekte\dmdf\maps\Karte 1 - Talras.w3x" "E:\Projekte\dmdf\maps\releases\Talras%VERSION%.w3x"

del "E:\Projekte\dmdf\maps\releases\war3map.wts"
cp "E:\Projekte\dmdf\maps\Talras\war3map_en.wts" "E:\Projekte\dmdf\maps\releases\war3map.wts"

del "E:\Projekte\dmdf\maps\releases\de\Talras%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 1 - Talras.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\Talras%VERSION%.w3x" --checkscriptstuff --exit
del "E:\Projekte\dmdf\maps\releases\de\Gardonar%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 2 - Gardonar.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\Gardonar%VERSION%.w3x" --checkscriptstuff --exit
del "E:\Projekte\dmdf\maps\releases\de\Holzbruck%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 3 - Holzbruck.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\Holzbruck%VERSION%.w3x" --checkscriptstuff --exit
del "E:\Projekte\dmdf\maps\releases\de\Arena%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Arena.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\Arena%VERSION%.w3x" --checkscriptstuff --exit