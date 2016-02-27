/**
 * Provides functions for internationalisation of the modification.
 * While object strings have to be translated in the map strings file "war3map.wts" all code strings from custom vJass code (not from GUI triggers) can be translated using
 * functions with text versions for multiple languages.
 *
 * The game detects the current language of a player using the function \ref GetLanguage() and returns the correct string.
 *
 * \note At the moment only German and English is supported.
 */
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
	
	
	function trpe takes string german0, string german1, string english0, string english1, integer counter returns string
		if (GetLanguage() == "German") then
			return trp(german0, german1, counter)
		endif
		
		return trp(english0, english1, counter)
	endfunction
endlibrary