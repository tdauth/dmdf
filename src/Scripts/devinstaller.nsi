!include MUI2.nsh

Unicode true

!define PROJECTS_DIR "E:\Projekte\"
!define INPUT_DIR_ASL "E:\Projekte\asl\"
!define INPUT_DIR "E:\Projekte\dmdf\"
!define INPUT_SPLASH_DIR "E:\Projekte\dmdf\splash\TPoFSplash\build\TPoF"
!define INPUT_EXE_FILENAME "TPoF.exe"
!define INPUT_EXE "E:\Warcraft III\${INPUT_EXE_FILENAME}"
!define VERSION "0.9"
!define CAMPAIGN_VERSION "09"

Name "The Power of Fire Development Version"
OutFile "E:\Projekte\dmdf\releases\ThePowerOfFireDev${VERSION}.exe"
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
	WriteUninstaller "$INSTDIR\UninstallThePowerOfFireDev.exe"

	SetOutPath "$INSTDIR\TPoF"
	CreateShortCut "$INSTDIR\The Power of Fire.lnk" "$INSTDIR\TPoF\The Power of Fire.exe" ""
	CreateShortCut "$DESKTOP\The Power of Fire.lnk" "$INSTDIR\The Power of Fire.lnk" ""
SectionEnd

Section "German Maps" GermanMaps
	SetOutPath "$INSTDIR\The Power of Fire\Maps"
	File "${INPUT_DIR}\maps\Karte 1 - Talras.w3x"
	File "${INPUT_DIR}\maps\Karte 2 - Gardonar.w3x"
	File "${INPUT_DIR}\maps\Karte 2.1 - Gardonars Unterwelt.w3x"
	File "${INPUT_DIR}\maps\Karte 3 - Holzbruck.w3x"
	File "${INPUT_DIR}\maps\Karte 3.1 - Holzbrucks Unterwelt.w3x"
	File "${INPUT_DIR}\maps\Karte 4 - Karornwald.w3x"
	File "${INPUT_DIR}\maps\Karte 5 - Deranor.w3x"
	File "${INPUT_DIR}\maps\Arena.w3x"
SectionEnd

Section "German Campaign" GermanCampaign
	SetOutPath "$INSTDIR\The Power of Fire\Campaigns"
	File "${INPUT_DIR}\maps\releases\TPoF${CAMPAIGN_VERSION}de.w3n"
SectionEnd

Section "English Campaign" EnglishCampaign
	SetOutPath "$INSTDIR\The Power of Fire\Campaigns"
	File "${INPUT_DIR}\maps\releases\TPoF${CAMPAIGN_VERSION}en.w3n"
SectionEnd

Section "Source Code" SourceCode
	SetOutPath "$INSTDIR\The Power of Fire\"
	File /r "${INPUT_DIR}\src"
SectionEnd

Section "Archive" Archive
	SetOutPath "$INSTDIR\The Power of Fire\"
	File "${PROJECTS_DIR}\TPoF.mpq"
SectionEnd

Section "Documentation" Documentation
	SetOutPath "$INSTDIR\The Power of Fire\"
	File /r "${INPUT_DIR}\doc"
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
	 RMDir /r "$INSTDIR\The Power of Fire"
	 RMDir /r "$INSTDIR\ASL"
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