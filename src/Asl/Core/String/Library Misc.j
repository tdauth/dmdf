library ALibraryCoreStringMisc requires optional ALibraryCoreDebugMisc

	debug function StringPositionDebug takes string functionName, string whichString, integer position returns nothing
		debug if ((position < 0) or (position >= StringLength(whichString))) then
			debug call PrintFunctionError(functionName, "Wrong position value: " + I2S(position) + ".")
		debug endif
	debug endfunction

	/**
	 * Searches for position of string \p searchedString in string \p whichString.
	 * If \p searchedString is not contained by \p whichString function will return -1 otherwise it will return its position.
	 * \param whichString String which should contain searched string.
	 * \param searchedString String which is searched.
	 * \return If the string was found it returns its position otherwise it will return -1.
	 */
	function FindString takes string whichString, string searchedString returns integer
static if (A_RTC) then
		return StringPos(whichString, searchedString)
else
		local integer i
		debug if (StringLength(whichString) < StringLength(searchedString)) then
			debug call PrintFunctionError("FindString", "Used string is lesser than searched string.")
		debug endif
		set i = 0
		loop
			exitwhen (i + StringLength(searchedString) > StringLength(whichString))
			if (SubString(whichString, i, i + StringLength(searchedString)) == searchedString) then
				return i
			endif
			set i = i + 1
		endloop
		return -1
endif
	endfunction

	/**
	 * Replaces a part of a string and returns the resulting string.
	 * \note The newly created string can be longer than the old of old string until position + replacing string is longer!
	 * \param whichString String which is used for replacement operation.
	 * \param position Position where replacement should start. If this value is equal to or greater than the length of \p whichString, \p replacingString is just appended. Negative values will be converted to 0.
	 * \param replacingString String which should replace a sub string of string \p whichString.
	 * \return Returns the new string with the replaced sub string.
	 */
	function ReplaceSubString takes string whichString, integer position, string replacingString returns string
		local string result = ""
		debug call StringPositionDebug("ReplaceSubString", whichString, position)
		if (position < 0) then
			set position = 0
		endif
		set result = SubString(whichString, 0, IMinBJ(position, StringLength(whichString))) + replacingString
		if (position + StringLength(replacingString) < StringLength(whichString)) then
			set result = result + SubString(whichString, position + StringLength(replacingString), StringLength(whichString))
		endif
		return result
	endfunction

	/**
	 * Replaces string \p replacedString in string \p whichString by string \p replacingString and returns the resulting string.
	 * Note that \p replacedString and \p replacingString do not have to have the same size. The function removes \p replacedString and inserts \p replacingString afterwards at \p replacedString's old position as expected and other than \ref ReplaceSubString() which simply overrides chars.
	 * \param whichString String which contains the sub string \p replacedString.
	 * \param replacedString Sub string of string \p whichString which should be replaced.
	 * \param replacingString String which should replace \p replacedString.
	 * \return Returns the new string with the replaced sub string.
	 */
	function ReplaceString takes string whichString, string replacedString, string replacingString returns string
static if (A_RTC) then
		return StringReplace(whichString, replacedString, replacingString)
else
		local integer position = FindString(whichString, replacedString)
		if (position == -1) then
			debug call PrintFunctionError("ReplaceString", "Replaced string not found: \"" + replacedString + "\".")

			return whichString
		endif

		return SubString(whichString, 0, position) + replacingString + SubString(whichString, position + StringLength(replacedString), StringLength(whichString))
endif
	endfunction

	/**
	 * Removes the sub string at position \p position with length \p length of string \p whichString and returns the resulting string.
	 * \param whichString String which is used for removing the sub string.
	 * \param position Position of the sub string which should be removed. If this value is smaller than 0, it will be set to 0. If it is equal to or greater than length of \p whichString nothing will be removed.
	 * \param length Length of the sub string which should be removed.
	 * \return Returns the new string without the sub string string.
	 */
	function RemoveSubString takes string whichString, integer position, integer length returns string
		local integer endIndex = position + length
		local string result = ""
		debug call StringPositionDebug("RemoveSubString", whichString, position)
		debug call StringPositionDebug("RemoveSubString", whichString, endIndex - 1)
		if (position < 0) then // usually, doesn't happen
			set position = 0
			set endIndex = position + length
		else
			set result = SubString(whichString, 0, position)
		endif
		if (endIndex < StringLength(whichString)) then
			set result = result + SubString(whichString, endIndex, StringLength(whichString))
		endif
		return result
	endfunction

	/**
	 * Removes string \p removedString from string \p whichString and returns the resulting string.
	 * If \p removedString is not contained by \p whichString it is returned unmodified.
	 * \param whichString String from which \p subString should be removed.
	 * \param removedString String which should be removed.
	 * \return Returns the new string without the removed string.
	 */
	function RemoveString takes string whichString, string removedString returns string
		local integer position = FindString(whichString, removedString)
		if (position == -1) then
			debug call PrintFunctionError("RemoveString", "String \"" + whichString + "\" does not contain string \"" + removedString + "\".")
			return whichString
		endif
		return RemoveSubString(whichString, position, StringLength(removedString))
	endfunction

	/**
	 * Inserts string \p insertedString into string \p whichString at position \p position and returns the resulting string.
	 * \param whichString String into which string \p insertedString should be inserted.
	 * \param position Position where string \p insertedString should be inserted. If this value is bigger or equal to length of string \p whichString string \p insertedString will be appended to string \p whichString. If this value is less then 0, it will be set to 0.
	 * \param insertedString String which should be inserted into string \p whichString at position \p position.
	 * \return Returns the new string with the inserted string.
	 */
	function InsertString takes string whichString, integer position, string insertedString returns string
		debug call StringPositionDebug("InsertString", whichString, position)

		if (position >= StringLength(whichString)) then
			return whichString + insertedString
		elseif (position < 0) then
			set position = 0
		endif

		return SubString(whichString, 0, position) + insertedString + SubString(whichString, position, StringLength(whichString))
	endfunction

	/**
	* Reverses a string that it will be written backwards and returns the resulting string.
	* \param whichString String which should be reversed.
	* \return Returns the new reversed string.
	*/
	function ReverseString takes string whichString returns string
		local integer i = StringLength(whichString)
		local string result = ""
		loop
			exitwhen (i == 0)
			set result = result + SubString(whichString, i - 1, i)
			set i = i - 1
		endloop
		return result
	endfunction

	/**
	* Basic case (in)sensitive pattern matching.
	* Supported wildcard characters:
	* * - matches 0 or more any characters
	* ? - matches exactly 1 any character
	* # - matches any digit, 0-9
	* [list] - matches any character in <list> (l, i, s and t in this example)
	* [!list] - matches any character that isn't in the list
	* Use \\* or \\? or \\[ to match a * or ? or [ respectively.
	* To get a ] in a list, put it as first character of the list.
	* To get a ! in a list, don't put it first.
	* By common convention, special characters *, ? and # have no meaning when used in a list.
	* If "case" is true, the matching is case sensitive.
	* \author AceHart
	* <a href="http://www.wc3c.net/showthread.php?t=102026">Wc3C.net thread</a>
	*/
	function StringMatch takes string text, string mask, boolean case returns boolean
		local string a
		local string b
		local string x
		local string y
		local integer i = 0
		local integer j = 0
		local boolean m

		if case then
			set a = text
			set b = mask
		else
			set a = StringCase(text, true)
			set b = StringCase(mask, true)
		endif

		set x = SubString(a, 0, 1)
		set y = SubString(b, 0, 1)
		if x == null and y == null then
			return false
		endif

		loop
			if y == null then
				return x == null
			elseif y == "#" then
				exitwhen not (x == "0" or x == "1" or x == "2" or x == "3" or x == "4" or x == "5" or x == "6" or x == "7" or x == "8" or x == "9")
			elseif y == "\\" then
				set j = j + 1
				set y = SubString(b, j, j + 1)
				exitwhen x != y
			elseif y == "?" then
				// nothing to do
			elseif y == "[" then
				set j = j + 1
				set y = SubString(b, j, j + 1)
				exitwhen y == null
				set m = false
				if y == "!" then
					loop
						set j = j + 1
						set y = SubString(b, j, j + 1)
						if y == null then
							return false
						endif
						exitwhen y == "]"
						if x == y then
							set m = true
						endif
					endloop
					exitwhen y != "]"
					exitwhen m == true
				else
					loop
						if y == null then
							return false
						endif
						if x == y then
							set m = true
						endif
						set j = j + 1
						set y = SubString(b, j, j + 1)
						exitwhen y == "]"
					endloop
					exitwhen y != "]"
					exitwhen m == false
				endif
			elseif y == "*" then
				loop
					set j = j + 1
					set y = SubString(b, j, j + 1)
					exitwhen y != "*"
				endloop
//			if y == null then
				if StringLength(y) < 1 then
					return true
				endif
				set a = SubString(a, i, StringLength(a))
				set b = SubString(b, j, StringLength(b))
				loop
					exitwhen a == null
					if StringMatch(a, b, case) then
					return true
					endif
					set i = i + 1
					set a = SubString(a, 1, StringLength(a))
				endloop
				return false
			else
				exitwhen x != y
			endif

			set i = i + 1
			set j = j + 1
			set x = SubString(a, i, i + 1)
			set y = SubString(b, j, j + 1)
		endloop
		return false
	endfunction

	/**
	 * \return Returns \p number characters from \p whichString starting from left.
	 */
	function StringLeft takes string whichString, integer number returns string
		set number = IMinBJ(number, StringLength(whichString))
		return SubString(whichString, 0, number)
	endfunction

	/**
	 * \return Returns \p number characters from \p whichString starting from right.
	 */
	function StringRight takes string whichString, integer number returns string
		set number = IMinBJ(number, StringLength(whichString))
		return SubString(whichString, StringLength(whichString) - number, StringLength(whichString))
	endfunction

	/**
	 * Appends \p other to \p whichString and returns the result.
	 * Could be useful for function variables.
	 * \sa StringPrepend()
	 */
	function StringAppend takes string whichString, string other returns string
		return whichString + other
	endfunction

	/**
	 * Appends \p whichString to \p other and returns the result.
	 * Could be useful for function variables.
	 * \sa StringAppend()
	 */
	function StringPrepend takes string whichString, string other returns string
		return other + whichString
	endfunction

	/**
	 * Concatenates string \p whichString \p number times and returns the result.
	 */
	function StringRepeated takes string whichString, integer number returns string
		local string result = ""
		local integer i = 0
		loop
			exitwhen (i == number)
			set result = result + whichString
			set i = i + 1
		endloop
		return result
	endfunction

	/// Appends ' ' characters if size is larger than original size.
	function StringResize takes string whichString, integer size returns string
		set size = IMaxBJ(0, size)
		if (size < StringLength(whichString)) then
			return SubString(whichString, 0, size)
		elseif (size > StringLength(whichString)) then
			return whichString + StringRepeated(" ", size - StringLength(whichString))
		endif
		return whichString
	endfunction

	/**
	 * Truncates string at the given position.
	 * \return Returns sub string of \p whichString starting at \p position + 1.
	 */
	function StringTruncate takes string whichString, integer position returns string
		set position = IMaxBJ(0, position)
		return SubString(whichString, 0, position + 1)
	endfunction

endlibrary