!include MUI2.nsh

Unicode true

!define PROJECTS_DIR "E:\Projekte\"
!define INPUT_DIR_ASL "E:\Projekte\asl\"
!define INPUT_DIR_TPOF "E:\Projekte\dmdf\"
!define INPUT_DIR "E:\Projekte\dmdf\maps\releases"
!define INPUT_SPLASH_DIR "E:\Projekte\dmdf\splash\TPoFSplash\build\TPoF"
!define INPUT_ARCHIVE_DIR "E:\Projekte\dmdf\archive"
!define OUTPUT_WARCRAFT_DOCUMENTS_DIR "Warcraft III"
!define VERSION "0.9"
!define CAMPAIGN_VERSION "09"

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
	File /r "${INPUT_ARCHIVE_DIR}\"
	File /r "${INPUT_SPLASH_DIR}"
	WriteUninstaller "$INSTDIR\UninstallThePowerOfFire.exe"

	SetOutPath "$INSTDIR\TPoF"
	CreateShortCut "$INSTDIR\The Power of Fire.lnk" "$INSTDIR\TPoF\The Power of Fire.exe" ""
	CreateShortCut "$DESKTOP\The Power of Fire.lnk" "$INSTDIR\The Power of Fire.lnk" ""
SectionEnd

Section "English Maps" EnglishMaps
	SetOutPath "$PROFILE\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Maps\The Power of Fire\en"
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
	SetOutPath "$PROFILE\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Maps\The Power of Fire\de"
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
	SetOutPath "$PROFILE\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Campaigns"
	File "${INPUT_DIR}\TPoF${CAMPAIGN_VERSION}de.w3n"
SectionEnd

Section "English Campaign" EnglishCampaign
	SetOutPath "$PROFILE\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Campaigns"
	File "${INPUT_DIR}\TPoF${CAMPAIGN_VERSION}en.w3n"
SectionEnd

Section "German Singleplayer Campaign" GermanSinglePlayerCampaign
	SetOutPath "$PROFILE\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Maps\TPoF09de"
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
	SetOutPath "$PROFILE\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Maps\TPoF09en"
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
	File /r "${INPUT_DIR_TPOF}\tools\JNGP"
SectionEnd

Section "Source Code" SourceCode
	SetOutPath "$INSTDIR\The Power of Fire\"
	File /r "${INPUT_DIR_TPOF}\src"
SectionEnd

Section "Documentation" Documentation
	SetOutPath "$INSTDIR\The Power of Fire\"
	File /r "${INPUT_DIR_TPOF}\doc"
SectionEnd

Section "ASL Source Code" AslSourceCode
	SetOutPath "$INSTDIR\ASL\"
	File /r "${INPUT_DIR_ASL}\src"
SectionEnd

Section "ASL Source Documentation" AslDocumentation
	SetOutPath "$INSTDIR\ASL\"
	File /r "${INPUT_DIR_ASL}\doc"
SectionEnd

Section "Uninstall"
	 Delete "$PROFILE\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Campaigns\TPoF{CAMPAIGN_VERSION}de.w3n"
	 Delete "$PROFILE\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Campaigns\TPoF{CAMPAIGN_VERSION}en.w3n"
	 RMDir /r "$PROFILE\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Maps\The Power of Fire"
	 RMDir /r "$PROFILE\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Maps\TPoF09de"
	 RMDir /r "$PROFILE\${OUTPUT_WARCRAFT_DOCUMENTS_DIR}\Maps\TPoF09en"
	 RMDir /r "$INSTDIR\Abilities"
	 RMDir /r "$INSTDIR\Fonts"
	 RMDir /r "$INSTDIR\Icons"
	 RMDir /r "$INSTDIR\Models"
	 RMDir /r "$INSTDIR\Objects"
	 RMDir /r "$INSTDIR\PathTextures"
	 RMDir /r "$INSTDIR\ReplaceableTextures"
	 RMDir /r "$INSTDIR\Scripts"
	 RMDir /r "$INSTDIR\Sound"
	 RMDir /r "$INSTDIR\TerrainArt"
	 RMDir /r "$INSTDIR\Textures"
	 RMDir /r "$INSTDIR\UI"
	 RMDir /r "$INSTDIR\Units"
	 RMDir /r "$INSTDIR\UserInterfaces"
	 Delete "$INSTDIR\CharacterManagement.tga"
	 RMDir /r "$INSTDIR\The Power of Fire"
	 RMDir /r "$INSTDIR\ASL"
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