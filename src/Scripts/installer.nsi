!include MUI2.nsh

Unicode true

!define INPUT_DIR "E:\Projekte\dmdf\maps\releases"
!define INPUT_EXE_FILENAME "Die Macht des Feuers.exe"
!define INPUT_EXE "E:\Warcraft III\${INPUT_EXE_FILENAME}"
!define VERSION "0.4"

Name "The Power of Fire"
OutFile "The Power of Fire.exe"
InstallDir "$PROGRAMFILES\Warcraft III"

#!define MUI_ICON "path\to\icon.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "cropped-dmdf.bmp"
!define MUI_HEADERIMAGE_RIGHT

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
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
	#IfFileExists "$INSTDIR\war3x.mpq" sections missingWarcraft
	#missingWarcraft:
	#MessageBox MB_OK "Select Warcraft III directory please."
	#goto installDir
	#sections:
	File "${INPUT_EXE}"
	CreateShortCut "$DESKTOP\The Power of Fire.lnk" "${INPUT_EXE}" ""
	WriteUninstaller "$INSTDIR\UninstallThePowerOfFire.exe"
SectionEnd

LangString DESC_Application ${LANG_ENGLISH} "The application itself."

Section "English Maps" EnglishMaps
  SetOutPath "$INSTDIR\Maps\The Power of Fire"
  File "${INPUT_DIR}\en\Talras${VERSION}.w3x"
SectionEnd

LangString DESC_EnglishMaps ${LANG_ENGLISH} "Maps of the modification (English)."

Section "German Maps" GermanMaps
  SetOutPath "$INSTDIR\Maps\The Power of Fire"
  File "${INPUT_DIR}\de\Talras${VERSION}.w3x"
  File "${INPUT_DIR}\de\Arena${VERSION}.w3x"
SectionEnd

LangString DESC_GermanMaps ${LANG_ENGLISH} "Maps of the modification (German)."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${EnglishMaps} $(DESC_EnglishMaps)
  !insertmacro MUI_DESCRIPTION_TEXT ${GermanMaps} $(DESC_GermanMaps)
  !insertmacro MUI_DESCRIPTION_TEXT ${Application} $(DESC_Application)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Section "Uninstall"
	 RMDir /r "$INSTDIR\Maps\The Power of Fire"
	 Delete "$INSTDIR\${INPUT_EXE_FILENAME}"
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