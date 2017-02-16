!include MUI2.nsh

Unicode true

!define INPUT_DIR "E:\Projekte\dmdf\maps\releases"
!define INPUT_SPLASH_DIR "E:\Projekte\dmdf\splash\TPoFSplash\build\TPoF"
!define INPUT_EXE_FILENAME "TPoF.exe"
!define INPUT_EXE "E:\Warcraft III\${INPUT_EXE_FILENAME}"
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
	File "${INPUT_EXE}"
	File /r "${INPUT_SPLASH_DIR}"
	WriteUninstaller "$INSTDIR\UninstallThePowerOfFire.exe"

	SetOutPath "$INSTDIR\TPoF"
	CreateShortCut "$INSTDIR\The Power of Fire.lnk" "$INSTDIR\TPoF\The Power of Fire.exe" ""
	CreateShortCut "$DESKTOP\The Power of Fire.lnk" "$INSTDIR\The Power of Fire.lnk" ""
SectionEnd

Section "English Maps" EnglishMaps
	SetOutPath "$INSTDIR\Maps\The Power of Fire\en"
	File "${INPUT_DIR}\en\Talras${VERSION}.w3x"
SectionEnd

Section "German Maps" GermanMaps
	SetOutPath "$INSTDIR\Maps\The Power of Fire\de"
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
SectionEnd

Section "German Campaign" GermanCampaign
	SetOutPath "$INSTDIR\Campaigns"
	File "${INPUT_DIR}\TPoF${CAMPAIGN_VERSION}de.w3n"
SectionEnd

Section "English Campaign" EnglishCampaign
	SetOutPath "$INSTDIR\Campaigns"
	File "${INPUT_DIR}\TPoF${CAMPAIGN_VERSION}en.w3n"
SectionEnd

Section "Uninstall"
	 Delete "$INSTDIR\Campaigns\TPoF{CAMPAIGN_VERSION}de.w3n"
	 Delete "$INSTDIR\Campaigns\TPoF{CAMPAIGN_VERSION}en.w3n"
	 RMDir /r "$INSTDIR\Maps\The Power of Fire"
	 Delete "$INSTDIR\${INPUT_EXE_FILENAME}"
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