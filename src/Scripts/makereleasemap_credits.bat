SET VERSION=%1

del "F:\Projekte\dmdf\maps\releases\CreditsCredits%VERSION%.w3x"
copy "F:\Projekte\dmdf\maps\Credits.w3x" "F:\Projekte\dmdf\maps\releases\Credits\Credits%VERSION%.w3x"
del "F:\Projekte\dmdf\maps\releases\Credits\war3map.wts"
copy "F:\Projekte\dmdf\maps\Credits\war3map_en.wts" "F:\Projekte\dmdf\maps\releases\Credits\war3map.wts"
del "F:\Projekte\dmdf\maps\releases\de\Credits%VERSION%.w3x"
"F:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" --tweak "F:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "F:\Projekte\dmdf\maps\Credits.w3x" --do "F:\Projekte\dmdf\maps\releases\de\Credits%VERSION%.w3x" --checkscriptstuff --exit