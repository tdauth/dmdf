!include MUI2.nsh

Unicode true

!define PROJECTS_DIR "E:\Projekte\"
!define INPUT_DIR_TPOF "E:\Projekte\dmdf\"
!define INPUT_DIR "E:\Projekte\dmdf\maps\releases"
!define INPUT_ARCHIVE "E:\Projekte\dmdf\War3Mod.mpq"
!define OUTPUT_WARCRAFT_DOCUMENTS_DIR "Warcraft III"
!define VERSION "1.0"
!define CAMPAIGN_VERSION "10"

Name "The Power of Fire"
OutFile "E:\Projekte\dmdf\releases\ThePowerOfFire${VERSION}.exe"
InstallDir "$PROGRAMFILES\Warcraft III"

!define MUI_ABORTWARNING

!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "Warcraft III directory"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English" ;first language is the default language
!insertmacro MUI_LANGUAGE "German"

Section "Application" Application
	SetOutPath "$INSTDIR\"
	File "${INPUT_ARCHIVE}"
	WriteUninstaller "$INSTDIR\UninstallThePowerOfFire.exe"
SectionEnd

Section "English Maps" EnglishMaps
	SetOutPath "$DOCUMENTS\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Maps\The Power of Fire\en"
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

Section "German Maps" GermanMaps
	SetOutPath "$DOCUMENTS\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Maps\The Power of Fire\de"
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

Section "German Campaign" GermanCampaign
	SetOutPath "$DOCUMENTS\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Campaigns"
	File "${INPUT_DIR}\TPoF${CAMPAIGN_VERSION}de.w3n"
SectionEnd

Section "English Campaign" EnglishCampaign
	SetOutPath "$DOCUMENTS\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Campaigns"
	File "${INPUT_DIR}\TPoF${CAMPAIGN_VERSION}en.w3n"
SectionEnd

Section "German Singleplayer Campaign" GermanSinglePlayerCampaign
	SetOutPath "$DOCUMENTS\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Maps\TPoF${CAMPAIGN_VERSION}de"
	File "${INPUT_DIR}\DH.w3x"
	File "${INPUT_DIR}\TL.w3x"
	File "${INPUT_DIR}\GA.w3x"
	File "${INPUT_DIR}\GH.w3x"
	File "${INPUT_DIR}\DS.w3x"
	File "${INPUT_DIR}\HB.w3x"
	File "${INPUT_DIR}\HU.w3x"
	File "${INPUT_DIR}\TN.w3x"
	File "${INPUT_DIR}\WM.w3x"
	File "${INPUT_DIR}\CT.w3x"
SectionEnd

Section "English Singleplayer Campaign" EnglishSinglePlayerCampaign
	SetOutPath "$DOCUMENTS\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Maps\TPoF${CAMPAIGN_VERSION}en"
	File "${INPUT_DIR}\en\DH.w3x"
	File "${INPUT_DIR}\en\TL.w3x"
	File "${INPUT_DIR}\en\GA.w3x"
	File "${INPUT_DIR}\en\GH.w3x"
	File "${INPUT_DIR}\en\DS.w3x"
	File "${INPUT_DIR}\en\HB.w3x"
	File "${INPUT_DIR}\en\HU.w3x"
	File "${INPUT_DIR}\en\TN.w3x"
	File "${INPUT_DIR}\en\WM.w3x"
	File "${INPUT_DIR}\en\CT.w3x"
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
	 Delete "$DOCUMENTS\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Campaigns\TPoF{CAMPAIGN_VERSION}de.w3n"
	 Delete "$DOCUMENTS\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Campaigns\TPoF{CAMPAIGN_VERSION}en.w3n"
	 RMDir /r "$DOCUMENTS\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Maps\The Power of Fire"
	 RMDir /r "$DOCUMENTS\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Maps\TPoF09de"
	 RMDir /r "$DOCUMENTS\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Maps\TPoF09en"
	 Delete "$INSTDIR\War3Mod.mpq"
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
	IfFileExists $INSTDIR\war3x.mpq good
		Abort
	good:
FunctionEnd