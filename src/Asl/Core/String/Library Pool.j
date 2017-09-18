/**
 * Provides many functions for working with character pools and checking strings and characters for their content.
 * \author Tamino Dauth
 */
library ALibraryCoreStringPool requires ALibraryCoreStringMisc

	globals
		constant string AAlphabeticalCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
		constant string ANumeralCharacters = "0123456789"
		constant string ASpecialCharacters = "!§$%&/()=?+-/*,.-;:_~#'|<>äöüß"
		constant string AWhiteSpaceCharacters = " \t"
		constant string ASignCharacters = "+-"
		constant string ABinaryCharacters = "01"
		constant string AOctalCharacters = "01234567"
		constant string AHexadecimalCharacters = "0123456789ABCDEFabcdef"
	endglobals

	/**
	 * Generates a random character from the character pool \p charPool.
	 * \param charPool Character pool which is used for generation of a random character.
	 * \return Returns a random character from the character pool \p charPool.
	 */
	function GetRandomCharacter takes string charPool returns string
		local integer randomInteger = GetRandomInt(1, StringLength(charPool))
		return SubString(charPool, randomInteger - 1, randomInteger)
	endfunction

	/**
	 * Generates a random alphabetical character.
	 * \return Returns a random alphabetical character.
	 */
	function GetRandomAlphabeticalCharacter takes nothing returns string
		return GetRandomCharacter(AAlphabeticalCharacters)
	endfunction

	/**
	 * Generates a random numeral character.
	 * \return Returns a random numeral character.
	 */
	function GetRandomNumeralCharacter takes nothing returns string
		return GetRandomCharacter(ANumeralCharacters)
	endfunction

	/**
	 * Generates a random special character.
	 * \return Returns a random special character.
	 */
	function GetRandomSpecialCharacter takes nothing returns string
		return GetRandomCharacter(ASpecialCharacters)
	endfunction

	/**
	 * Generates a random white-space character.
	 * \return Returns a random white-space character.
	 */
	function GetRandomWhiteSpaceCharacter takes nothing returns string
		return GetRandomCharacter(AWhiteSpaceCharacters)
	endfunction

	/**
	 * Generates a random sign character.
	 * \return Returns a random sign character.
	 */
	function GetRandomSignCharacter takes nothing returns string
		return GetRandomCharacter(ASignCharacters)
	endfunction

	/**
	 * Generats a random string with the length \p length.
	 * Is able to include various other characters.
	 * \param length The length of the returned value.
	 * \param includeNumberCharacters If this value is true number charactes will be added into the string pool.
	 * \param includeSpecialCharacters If this value is true special characters will be added into the string pool.
	 * \param includeWhiteSpaceCharacters If this value is true white-space characters will be added into the string pool.
	 * \return Returns a random string generated from the selected string pool.
	 */
	function GetRandomString takes integer length, boolean includeNumberCharacters, boolean includeSpecialCharacters, boolean includeWhiteSpaceCharacters returns string
		local integer i
		local string characters = AAlphabeticalCharacters
		local string result = ""
		if (includeNumberCharacters) then
			set characters = characters + ANumeralCharacters
		endif
		if (includeSpecialCharacters) then
			set characters = characters + ASpecialCharacters
		endif
		if (includeWhiteSpaceCharacters) then
			set characters = characters + AWhiteSpaceCharacters
		endif
		set i = 0
		loop
			exitwhen (i == length)
			set result = result + GetRandomCharacter(characters)
			set i = i + 1
		endloop
		return result
	endfunction

	/**
	 * Checks if string \p whichString contains only characters from character pool \p characterPool.
	 * Checks each single character.
	 * \param whichString String which should be checked.
	 * \param characterPool Character pool which will be used for comparing all characters.
	 * \return Returns if all characters from string \p whichString are contained by string pool \p characterPool.
	 */
	function IsStringFromCharacterPool takes string whichString, string characterPool returns boolean
		local integer i
		if (StringLength(whichString) == 0 and StringLength(whichString) > 0) then
			return false
		endif
		set i = 1
		loop
			exitwhen (i > StringLength(whichString))
			if (FindString(characterPool, SubString(whichString, i - 1, i)) == -1) then
				return false
			endif
			set i = i + 1
		endloop
		return true
	endfunction

	/**
	 * Checks if string \p whichString is alphabetical.
	 * \param whichString Checked string.
	 * \return Returns true if string \p whichString contains only alphabetical characters.
	 */
	function IsStringAlphabetical takes string whichString returns boolean
		return IsStringFromCharacterPool(whichString, AAlphabeticalCharacters)
	endfunction

	/**
	 * Checks if string \p whichString is numeral.
	 * \param whichString Checked string.
	 * \return Returns true if string \p whichString contains only numeral characters.
	 */
	function IsStringNumeral takes string whichString returns boolean
		return IsStringFromCharacterPool(whichString, ANumeralCharacters)
	endfunction

	/**
	 * Checks if string \p whichString contains only special characters.
	 * \param whichString Checked string.
	 * \return Returns true if string \p whichString contains only special characters.
	 */
	function IsStringSpecial takes string whichString returns boolean
		return IsStringFromCharacterPool(whichString, ASpecialCharacters)
	endfunction

	/**
	 * Checks if string \p whichString contains only white-space characters.
	 * \param whichString Checked string.
	 * \return Returns true if string \p whichString contains only white-space characters.
	 */
	function IsStringWhiteSpace takes string whichString returns boolean
		return IsStringFromCharacterPool(whichString, AWhiteSpaceCharacters)
	endfunction

	/**
	 * Checks if string \p whichString is a signature.
	 * \param whichString Checked string.
	 * \return Returns true if string \p whichString is a signature.
	 */
	function IsStringSign takes string whichString returns boolean
		return IsStringFromCharacterPool(whichString, ASignCharacters)
	endfunction

	/**
	 * Checks if string \p which is an integer.
	 * Integers can have signs:
	 * 0
	 * 3234
	 * -234
	 * +53
	 * \param which Checked string.
	 * \return Returns true if string \p which is an integer.
	 */
	function IsStringInteger takes string whichString returns boolean
		local string prefix

		if (StringLength(whichString) == 0) then
			return false
		endif

		set prefix = SubString(whichString, 0, 1)

		if ((not IsStringNumeral(prefix)) and ((not IsStringSign(prefix)) or StringLength(whichString) == 1)) then
			return false
		endif

		if (StringLength(whichString) > 1) then
			return IsStringNumeral(SubString(whichString, 1, StringLength(whichString)))
		endif

		return true
	endfunction

	/**
	 * Checks if string \p whichString is binary.
	 * Binary number do not have any kind of prefix but can have signs:
	 * +101
	 * 101
	 * -111
	 * \param whichString Checked string.
	 * \return Returns true if string \p whichString is binary.
	 * \note All but octal numbers mustn't start with 0 if they have no prefix, except the value itself is 0 (0101 is invalid, 101 is not - binary numbers have no prefixes)!
	 */
	function IsStringBinary takes string whichString returns boolean
		local integer prefixLength
		local string prefix
		local string pool
		if (StringLength(whichString) == 0) then
			return false
		endif
		set prefix = SubString(whichString, 0, 1) // string length is at least 1
		set pool = ABinaryCharacters
		if (not IsStringFromCharacterPool(prefix, pool)) then
			if (not IsStringSign(prefix) or StringLength(whichString) == 1) then
				return false
			endif

			if (StringLength(whichString) > 1) then
				if (SubString(whichString, 1, 2) == "0" and StringLength(whichString) > 2) then // starts with 0 but is not 0, would be octal
					return false
				endif
			endif
		elseif (prefix == "0" and StringLength(whichString) > 1) then // starts with 0 but is not 0, would be octal
			return false
		endif

		if (StringLength(whichString) > 1) then
			return IsStringFromCharacterPool(SubString(whichString, 1, StringLength(whichString)), pool)
		endif

		return true
	endfunction

	/**
	 * Checks if string \p whichString is octal.
	 * Octal numbers can have prefixes of 0 and signs:
	 * 123
	 * 02324
	 * -234
	 * -01323
	 * +243
	 * +0341
	 * \param whichString Checked string.
	 * \return Returns true if string \p whichString is octal.
	 * \note All but octal numbers mustn't start with 0 if they have no prefix, except the value itself is 0 (0A32 is invalid, 0x0A32 is not)!
	 */
	function IsStringOctal takes string whichString returns boolean
		local string prefix
		local boolean checkPrefix
		local string pool
		if (StringLength(whichString) == 0) then
			return false
		endif
		set prefix = SubString(whichString, 0, 1) // string length is at least 1
		set checkPrefix = false
		set pool = AOctalCharacters
		if (not IsStringFromCharacterPool(prefix, pool)) then
			if (not IsStringSign(prefix) or StringLength(whichString) == 1) then
				return false
			endif
		endif

		if (StringLength(whichString) > 1) then
			return IsStringFromCharacterPool(SubString(whichString, 1, StringLength(whichString)), pool)
		endif

		return true
	endfunction

	/**
	 * Checks if string \p whichString is hexadecimal.
	 * Hexadecimal numbers can have prefixes of 0x and signs:
	 * 0xAF31
	 * -0xA320
	 * +0xFC31
	 * FC21
	 * -FC34521
	 * +234
	 * 0x0A2 - starts with 0 but with prefix
	 * \param whichString Checked string.
	 * \return Returns true if string \p whichString is hexadecimal.
	 * \note All but octal numbers mustn't start with 0 if they have no prefix, except the value itself is 0 (0A32 is invalid, 0x0A32 is not)!
	 */
	function IsStringHexadecimal takes string whichString returns boolean
		local integer prefixLength
		local integer literalStart // used for single 0 check
		local string prefix
		local boolean checkPrefix
		local string pool
		if (StringLength(whichString) == 0) then
			return false
		endif
		set prefixLength = 1 // string length is at least 1
		set prefix = SubString(whichString, 0, prefixLength)
		set checkPrefix = false
		set pool = AHexadecimalCharacters
		if (not IsStringFromCharacterPool(prefix, pool)) then
			set literalStart = 1
			if (IsStringSign(prefix)) then
				if (StringLength(whichString) == 1) then // is only sign
					return false
				endif
				if (StringLength(whichString) > 3) then // could be prefix (WITH some more digits!!!)
					set prefixLength = 3
					set prefix = SubString(whichString, 1, prefixLength)
					set checkPrefix = not IsStringFromCharacterPool(prefix, pool)
				endif
			elseif (StringLength(whichString) > 2) then // could be prefix (WITH some more digits!!!)
				set prefixLength = 2
				set prefix = SubString(whichString, 0, prefixLength)
				set checkPrefix = not IsStringFromCharacterPool(prefix, pool)
			else // no digit and can't be 0x...
				return false
			endif
		elseif (StringLength(whichString) >= 2) then
			set prefixLength = 2
			set prefix = SubString(whichString, 0, prefixLength)
			set checkPrefix = not IsStringFromCharacterPool(prefix, pool)
		else
			set literalStart = 0
		endif

		if (checkPrefix) then
			if (prefix != "0x" or StringLength(whichString) == prefixLength) then // is not prefix or stops after prefix
				return false
			endif
			set literalStart = prefixLength
		endif

		if (not checkPrefix and StringLength(whichString) > literalStart + 1 and SubString(whichString, literalStart, literalStart + 1) == "0") then // starts with 0 but is not 0 and without prefix, would be octal
			return false
		endif

		if (StringLength(whichString) > prefixLength) then // use prefixLength here again, otherwise with literalStart it would check prefix chars twice
			return IsStringFromCharacterPool(SubString(whichString, prefixLength, StringLength(whichString)), pool)
		endif

		return true
	endfunction

	/**
	 * Removes all characters which occur in \p charPool from \p whichString and returns the result.
	 */
	function StringRemoveCharPool takes string whichString, string charPool returns string
		local integer i = 0
		local string subString
		local string result = ""
		loop
			exitwhen (i == StringLength(whichString))
			set subString = SubString(whichString, i, i + 1)
			if (not IsStringFromCharacterPool(subString, charPool)) then
				set result = result + subString
			endif
			set i = i + 1
		endloop
		return result
	endfunction

	/**
	 * Removes all white spaces to the first non-whitespace character, starting from left and returns the result.
	 * \sa StringTrim(), StringTrimRight()
	 */
	function StringTrimLeft takes string whichString returns string
		local integer i = 0
		loop
			exitwhen (i == StringLength(whichString))
			if (not IsStringWhiteSpace(SubString(whichString, i, i + 1))) then
				return SubString(whichString, i, StringLength(whichString))
			endif
			set i = i + 1
		endloop
		return null
	endfunction

	/**
	 * Removes all white spaces to the first non-whitespace character, starting from right and returns the result.
	 * \sa StringTrim(), StringTrimLeft()
	 */
	function StringTrimRight takes string whichString returns string
		local integer i = StringLength(whichString)
		loop
			exitwhen (i <= 0)
			if (not IsStringWhiteSpace(SubString(whichString, i - 1, i))) then
				return SubString(whichString, 0, i)
			endif
			set i = i - 1
		endloop
		return null
	endfunction

	/**
	 * Removes all whitespaces at string start and end and returns the result.
	 * \sa StringTrimLeft(), StringTrimRight()
	 */
	function StringTrim takes string whichString returns string
		return StringTrimRight(StringTrimLeft(whichString))
	endfunction

endlibrary