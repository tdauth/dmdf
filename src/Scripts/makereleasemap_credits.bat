SET VERSION=%1

del "E:\Projekte\dmdf\maps\releases\CreditsCredits%VERSION%.w3x"
cp "E:\Projekte\dmdf\maps\Credits.w3x" "E:\Projekte\dmdf\maps\releases\CreditsCredits%VERSION%.w3x"
del "E:\Projekte\dmdf\maps\releases\Credits\CT.w3x"
cp "E:\Projekte\dmdf\maps\Credits.w3x" "E:\Projekte\dmdf\maps\releases\Credits\CT.w3x"
del "E:\Projekte\dmdf\maps\releases\Credits\war3map.wts"
cp "E:\Projekte\dmdf\maps\Credits\war3map_en.wts" "E:\Projekte\dmdf\maps\releases\Credits\war3map.wts"
del "E:\Projekte\dmdf\maps\releases\de\Credits%VERSION%.w3x"
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" "E:\Projekte\dmdf\maps\Credits.w3x" --do  "E:\Projekte\dmdf\maps\releases\de\Credits%VERSION%.w3x" --checkscriptstuff --exit