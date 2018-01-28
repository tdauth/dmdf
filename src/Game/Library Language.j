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
	 * Allows to return a different string for every player depending on the language of the player's game.
	 * \note This might lead to desyncs if the string return value is used for all players since it might be different for every player.
	 * \param german The German version of the text.
	 * \param english The English version of the text.
	 * \return Returns \p german if the local player's language is German. Otherwise it returns \p english.
	 */
	function tre takes string german, string english returns string
		if (GetLanguage() == "German") then
			return german
		endif

		return english
	endfunction

	/**
	 * The plural string version for German and English.
	 */
	function trpe takes string germanSingularSource, string germanPluralSource, string englishSingularSource, string englishPluralSource, integer counter returns string
		if (GetLanguage() == "German") then
			return trp(germanSingularSource, germanPluralSource, counter)
		endif

		return trp(englishSingularSource, englishPluralSource, counter)
	endfunction
endlibrary