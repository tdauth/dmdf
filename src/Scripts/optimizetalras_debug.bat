set OUTPUT_FILEPATH="F:\Warcraft III\Maps\DMDF\Talras1.0.w3x"
del %OUTPUT_FILEPATH%
"F:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" --tweak "F:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "F:\Projekte\dmdf\maps\Karte 1 - Talras.w3x" --do %OUTPUT_FILEPATH% --checkscriptstuff --exit