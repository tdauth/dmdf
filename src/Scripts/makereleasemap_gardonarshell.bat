SET VERSION=%1

del "E:\Projekte\dmdf\maps\releases\GardonarsHell\GardonarsHell%VERSION%.w3x"
cp "E:\Projekte\dmdf\maps\Karte 2.1 - Gardonars Unterwelt.w3x" "E:\Projekte\dmdf\maps\releases\GardonarsHell\GardonarsHell%VERSION%.w3x"
del "E:\Projekte\dmdf\maps\releases\GardonarsHell\war3map.wts"
cp "E:\Projekte\dmdf\maps\GardonarsHell\war3map_en.wts" "E:\Projekte\dmdf\maps\releases\GardonarsHell\war3map.wts"
del "E:\Projekte\dmdf\maps\releases\de\GardonarsHell%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" --tweak "E:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "E:\Projekte\dmdf\maps\Karte 2.1 - Gardonars Unterwelt.w3x" --do "E:\Projekte\dmdf\maps\releases\de\GardonarsHell%VERSION%.w3x" --checkscriptstuff --exit
del "E:\Projekte\dmdf\maps\releases\GH.w3x"
cp "E:\Projekte\dmdf\maps\releases\de\GardonarsHell%VERSION%.w3x" "E:\Projekte\dmdf\maps\releases\GH.w3x"