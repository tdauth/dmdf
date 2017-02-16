SET VERSION=0.9

del "E:\Projekte\dmdf\maps\releases\Talras%VERSION%.w3x"
cp "E:\Projekte\dmdf\maps\Karte 1 - Talras.w3x" "E:\Projekte\dmdf\maps\releases\Talras%VERSION%.w3x"

del "E:\Projekte\dmdf\maps\releases\war3map.wts"
cp "E:\Projekte\dmdf\maps\Talras\war3map_en.wts" "E:\Projekte\dmdf\maps\releases\war3map.wts"

del "E:\Projekte\dmdf\maps\releases\de\Dornheim%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Tutorial.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\Dornheim%VERSION%.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\de\WorldMap%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\WorldMap.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\WorldMap%VERSION%.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\de\Talras%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 1 - Talras.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\Talras%VERSION%.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\de\Gardonar%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 2 - Gardonar.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\Gardonar%VERSION%.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\de\GardonarsHell%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 2.1 - Gardonars Unterwelt.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\GardonarsHell%VERSION%.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\de\Deranor%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 5 - Deranor.w3x" --do "E:\Projekte\dmdf\maps\releases\de\Deranor%VERSION%.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\de\Holzbruck%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 3 - Holzbruck.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\Holzbruck%VERSION%.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\de\HolzbrucksUnderworld%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 3.1 - Holzbrucks Unterwelt.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\HolzbrucksUnderworld%VERSION%.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\de\Arena%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Arena.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\Arena%VERSION%.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\de\TheNorth%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\TheNorth.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\TheNorth%VERSION%.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\DH.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Tutorial.w3x" --do "E:\Projekte\dmdf\maps\releases\DH.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\WM.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\WorldMap.w3x" --do "E:\Projekte\dmdf\maps\releases\WM.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\TL.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 1 - Talras.w3x" --do "E:\Projekte\dmdf\maps\releases\TL.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\GA.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 2 - Gardonar.w3x" --do "E:\Projekte\dmdf\maps\releases\GA.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\GH.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 2.1 - Gardonars Unterwelt.w3x" --do "E:\Projekte\dmdf\maps\releases\GH.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\HB.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 3 - Holzbruck.w3x" --do "E:\Projekte\dmdf\maps\releases\HB.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\HU.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 3.1 - Holzbrucks Unterwelt.w3x" --do "E:\Projekte\dmdf\maps\releases\HU.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\DS.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 5 - Deranor.w3x" --do "E:\Projekte\dmdf\maps\releases\DS.w3x" --checkscriptstuff --exit

del "E:\Projekte\dmdf\maps\releases\TN.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\TheNorth.w3x" --do "E:\Projekte\dmdf\maps\releases\TN.w3x" --checkscriptstuff --exit