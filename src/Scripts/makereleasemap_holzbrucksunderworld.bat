SET VERSION=%1

del "E:\Projekte\dmdf\maps\releases\HolzbrucksUnderworld\HolzbrucksUnderworld%VERSION%.w3x"
cp "E:\Projekte\dmdf\maps\Karte 3.1 - Holzbrucks Unterwelt.w3x" "E:\Projekte\dmdf\maps\releases\HolzbrucksUnderworld\HolzbrucksUnderworld%VERSION%.w3x"
del "E:\Projekte\dmdf\maps\releases\HolzbrucksUnderworld\HU.w3x"
cp "E:\Projekte\dmdf\maps\Karte 3.1 - Holzbrucks Unterwelt.w3x" "E:\Projekte\dmdf\maps\releases\HolzbrucksUnderworld\HU.w3x"
del "E:\Projekte\dmdf\maps\releases\HolzbrucksUnderworld\war3map.wts"
cp "E:\Projekte\dmdf\maps\HolzbrucksUnderworld\war3map_en.wts" "E:\Projekte\dmdf\maps\releases\HolzbrucksUnderworld\war3map.wts"
del "E:\Projekte\dmdf\maps\releases\de\HolzbrucksUnderworld%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Karte 3.1 - Holzbrucks Unterwelt.w3x" --do "E:\Projekte\dmdf\maps\releases\de\HolzbrucksUnderworld%VERSION%.w3x" --checkscriptstuff --exit
del "E:\Projekte\dmdf\maps\releases\HU.w3x"
cp "E:\Projekte\dmdf\maps\releases\de\HolzbrucksUnderworld%VERSION%.w3x" "E:\Projekte\dmdf\maps\releases\HU.w3x"