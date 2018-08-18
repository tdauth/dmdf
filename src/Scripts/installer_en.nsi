!include MUI2.nsh

Unicode true

!define PROJECTS_DIR "F:\Projekte\"
!define INPUT_DIR_TPOF "F:\Projekte\dmdf\"
!define INPUT_DIR "F:\Projekte\dmdf\maps\releases"
!define INPUT_ARCHIVE_DIR "F:\Projekte\dmdf\archive\"
!define INPUT_ARCHIVE_DIR_LANG "F:\Projekte\dmdf\archive_en\"
!define OUTPUT_WARCRAFT_DOCUMENTS_DIR "Warcraft III"
!define VERSION "1.0"
!define CAMPAIGN_VERSION "10"

Name "The Power of Fire"
OutFile "F:\Projekte\dmdf\releases\ThePowerOfFireEnglish${VERSION}.exe"
InstallDir "$PROGRAMFILES\Warcraft III"

!define MUI_ABORTWARNING

!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "Warcraft III directory"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

Function MyFinishRun
ExecShell "" "$instdir\Warcraft III.exe"
FunctionEnd

!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_FUNCTION MyFinishRun
!define MUI_FINISHPAGE_SHOWREADME "$instdir\ThePowerOfFireEnglish.txt"
!define MUI_FINISHPAGE_LINK "Modification website"
!define MUI_FINISHPAGE_LINK_LOCATION "http://www.moddb.com/mods/warcraft-iii-the-power-of-fire"

!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English" ;first language is the default language

Section "Application" Application
	SetOutPath "$INSTDIR\"
	File "${INPUT_DIR_TPOF}\ThePowerOfFireEnglish.txt"
	WriteUninstaller "$INSTDIR\UninstallThePowerOfFire.exe"
SectionEnd

Section "Application Data" ApplicationData
	SetOutPath "$INSTDIR\War3Mod.mpq\"
	File /r "${INPUT_ARCHIVE_DIR}"
	File /r "${INPUT_ARCHIVE_DIR_LANG}"
SectionEnd

Section "English Maps" EnglishMaps
	SetOutPath "$DOCUMENTS\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Maps\The Power of Fire"
	File "${INPUT_DIR}\en\Dornheim${VERSION}.w3x"
	File "${INPUT_DIR}\en\Talras${VERSION}.w3x"
	File "${INPUT_DIR}\en\Gardonar${VERSION}.w3x"
	File "${INPUT_DIR}\en\GardonarsHell${VERSION}.w3x"
	File "${INPUT_DIR}\en\Deranor${VERSION}.w3x"
	File "${INPUT_DIR}\en\Holzbruck${VERSION}.w3x"
	File "${INPUT_DIR}\en\HolzbrucksUnderworld${VERSION}.w3x"
	File "${INPUT_DIR}\en\TheNorth${VERSION}.w3x"
	File "${INPUT_DIR}\en\Arena${VERSION}.w3x"
	File "${INPUT_DIR}\en\WorldMap${VERSION}.w3x"
	File "${INPUT_DIR}\en\Credits${VERSION}.w3x"
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
	SetOutPath "$INSTDIR\The Power of Fire"
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
	RMDir /r "$INSTDIR\War3Mod.mpq"
	Delete "$INSTDIR\ThePowerOfFireEnglish.txt"
	RMDir /r "$INSTDIR\The Power of Fire"
	RMDir /r "$INSTDIR\TPoF"
	Delete "$INSTDIR\The Power of Fire.lnk"
	Delete "$DESKTOP\The Power of Fire.lnk"
SectionEnd

Function .onInit
	Var /GLOBAL InstallPath
	ReadRegStr $InstallPath HKCU "Software\Blizzard Entertainment\Warcraft III" InstallPathX
	DetailPrint "Warcraft install path: $InstallPath"
	StrCmp $InstallPath "" continue setInstallDirToRegStr
	setInstallDirToRegStr:
		StrCpy $InstDir $InstallPath
	continue:

	!insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

# Make sure Warcraft III is installed in the target directory
Function .onVerifyInstDir
	IfFileExists "$INSTDIR\Warcraft III.exe" good
		Abort
	good:
FunctionEnd
