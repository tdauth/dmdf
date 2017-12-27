set OUTPUT_FILEPATH="C:\Users\tamino\Documents\Warcraft III\Maps\DMDF\TL.w3x"
del %OUTPUT_FILEPATH%
"E:\wc3tools\5.0wc3mapoptimizer\VXJWTSOPT.exe" --tweak "F:\Projekte\dmdf\src\Scripts\tweaks.vxtweak" "E:\Projekte\dmdf\maps\Karte 1 - Talras.w3x" --do %OUTPUT_FILEPATH% --checkscriptstuff --exit