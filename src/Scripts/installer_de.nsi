!include MUI2.nsh

Unicode true

!define PROJECTS_DIR "F:\Projekte\"
!define INPUT_DIR_TPOF "F:\Projekte\dmdf\"
!define INPUT_DIR "F:\Projekte\dmdf\maps\releases"
!define INPUT_ARCHIVE "F:\Projekte\dmdf\mpq\de\War3Mod.mpq"
!define OUTPUT_WARCRAFT_DOCUMENTS_DIR "Warcraft III"
!define VERSION "1.0"
!define CAMPAIGN_VERSION "10"

Name "The Power of Fire"
OutFile "F:\Projekte\dmdf\releases\ThePowerOfFireGerman${VERSION}.exe"
InstallDir "$PROGRAMFILES\Warcraft III"

!define MUI_ABORTWARNING

!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "Warcraft-III-Verzeichnis"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

Function MyFinishRun
ExecShell "" "$instdir\Frozen Throne.exe"
FunctionEnd

!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION MyFinishRun
!define MUI_FINISHPAGE_SHOWREADME "$instdir\ThePowerOfFireGerman.txt"
!define MUI_FINISHPAGE_LINK "Modifikations-Website"
!define MUI_FINISHPAGE_LINK_LOCATION "http://www.moddb.com/mods/warcraft-iii-the-power-of-fire"

!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "German"

Section "Application" Application
	SetOutPath "$INSTDIR\"
	File "${INPUT_ARCHIVE}"
	File "${INPUT_DIR_TPOF}\ThePowerOfFireGerman.txt"
	WriteUninstaller "$INSTDIR\UninstallThePowerOfFire.exe"
SectionEnd

Section "German Maps" GermanMaps
	SetOutPath "$DOCUMENTS\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Maps\The Power of Fire"
	File "${INPUT_DIR}\de\Dornheim${VERSION}.w3x"
	File "${INPUT_DIR}\de\Talras${VERSION}.w3x"
	File "${INPUT_DIR}\de\Gardonar${VERSION}.w3x"
	File "${INPUT_DIR}\de\GardonarsHell${VERSION}.w3x"
	File "${INPUT_DIR}\de\Deranor${VERSION}.w3x"
	File "${INPUT_DIR}\de\Holzbruck${VERSION}.w3x"
	File "${INPUT_DIR}\de\HolzbrucksUnderworld${VERSION}.w3x"
	File "${INPUT_DIR}\de\TheNorth${VERSION}.w3x"
	File "${INPUT_DIR}\de\Arena${VERSION}.w3x"
	File "${INPUT_DIR}\de\WorldMap${VERSION}.w3x"
	File "${INPUT_DIR}\de\Credits${VERSION}.w3x"
SectionEnd

Section "German Dev Maps" GermanDevMaps
	SetOutPath "$INSTDIR\The Power of Fire\Maps"
	File "${INPUT_DIR_TPOF}\maps\Tutorial.w3x"
	File "${INPUT_DIR_TPOF}\maps\Karte 1 - Talras.w3x"
	File "${INPUT_DIR_TPOF}\maps\Karte 2 - Gardonar.w3x"
	File "${INPUT_DIR_TPOF}\maps\Karte 2.1 - Gardonars Unterwelt.w3x"
	File "${INPUT_DIR_TPOF}\maps\Karte 3 - Holzbruck.w3x"
	File "${INPUT_DIR_TPOF}\maps\Karte 3.1 - Holzbrucks Unterwelt.w3x"
	File "${INPUT_DIR_TPOF}\maps\TheNorth.w3x"
	File "${INPUT_DIR_TPOF}\maps\Karte 4 - Karornwald.w3x"
	File "${INPUT_DIR_TPOF}\maps\Karte 5 - Deranor.w3x"
	File "${INPUT_DIR_TPOF}\maps\Arena.w3x"
	File "${INPUT_DIR_TPOF}\maps\WorldMap.w3x"
	File "${INPUT_DIR_TPOF}\maps\Credits.w3x"
SectionEnd

Section "Object Data" ObjectData
	SetOutPath "$INSTDIR\The Power of Fire\"
	File "${INPUT_DIR_TPOF}\maps\ObjectData.w3o"
SectionEnd

Section "JNGP" JNGP
	SetOutPath "$INSTDIR\The Power of Fire\JNGP"
	File /r "${INPUT_DIR_TPOF}\tools\"
SectionEnd

Section "Source Code" SourceCode
	SetOutPath "$INSTDIR\The Power of Fire\"
	File /r "${INPUT_DIR_TPOF}\src"
SectionEnd

Section "Documentation" Documentation
	SetOutPath "$INSTDIR\The Power of Fire\"
	File /r "${INPUT_DIR_TPOF}\doc"
SectionEnd

Section "Uninstall"
	RMDir /r "$DOCUMENTS\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Maps\The Power of Fire"
	Delete "$INSTDIR\War3Mod.mpq"
	Delete "$INSTDIR\ThePowerOfFireGerman.txt"
	RMDir /r "$INSTDIR\The Power of Fire"
	RMDir /r "$INSTDIR\TPoF"
	Delete "$INSTDIR\The Power of Fire.lnk"
	Delete "$DESKTOP\The Power of Fire.lnk"
SectionEnd

Function .onInit
	Var /GLOBAL InstallPath
	ReadRegStr $InstallPath HKCU "Software\Blizzard Entertainment\Warcraft III" InstallPathX
	DetailPrint "Warcraft-Installationspfad: $InstallPath"
	StrCmp $InstallPath "" continue setInstallDirToRegStr
	setInstallDirToRegStr:
		StrCpy $InstDir $InstallPath
	continue:

	!insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

# Make sure Warcraft III is installed in the target directory
Function .onVerifyInstDir
	IfFileExists $INSTDIR\war3x.mpq good
		Abort
	good:
FunctionEnd
