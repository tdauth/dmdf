SET VERSION=%1

del "E:\Projekte\dmdf\maps\releases\Dornheim\Dornheim%VERSION%.w3x"
cp "E:\Projekte\dmdf\maps\Tutorial.w3x" "E:\Projekte\dmdf\maps\releases\Dornheim\Dornheim%VERSION%.w3x"
del "E:\Projekte\dmdf\maps\releases\Dornheim\war3map.wts"
cp "E:\Projekte\dmdf\maps\Tutorial\war3map_en.wts" "E:\Projekte\dmdf\maps\releases\Dornheim\war3map.wts"
del "E:\Projekte\dmdf\maps\releases\de\Dornheim%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Tutorial.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\Dornheim%VERSION%.w3x" --checkscriptstuff --exit
del "E:\Projekte\dmdf\maps\releases\DH.w3x"
cp  "E:\Projekte\dmdf\maps\releases\de\Dornheim%VERSION%.w3x" "E:\Projekte\dmdf\maps\releases\DH.w3x"