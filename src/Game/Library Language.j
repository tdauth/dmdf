library LibraryGameLanguage requires Asl

	/**
	 * \return Returns \p german if the local player's language is German. Otherwise it returns \p english.
	 */
	function tre takes string german, string english returns string
		if (GetLanguage() == "German") then
			return german
		endif
		
		return english
	endfunction
	
endlibrary