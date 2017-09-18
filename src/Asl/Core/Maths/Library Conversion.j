library ALibraryCoreMathsConversion requires optional ALibraryCoreDebugMisc, ALibraryCoreStringMisc

	/**
	 * Converts an integer into any numeral system
	 * The A in I2A stands for alpha-numeric.
	 * \param value The integer value which will be converted.
	 * \param chars The character pool of the numeral system.
	 * \return Returns the converted value as string.
	 */
	function I2A takes integer value, string chars returns string
		local string alphanumeric = ""
		local integer index = 0
		debug if ((value >= 0) or (value <= 0x7FFFFFFF)) then
			loop
				set index = (ModuloInteger(value, StringLength(chars)) + 1)
				set value = (value / StringLength(chars))
				set alphanumeric = (SubStringBJ(chars, index, index) + alphanumeric)
				exitwhen (value == 0)
			endloop
		debug else
			debug call Print("Invalid integer.")
		debug endif
		return alphanumeric
	endfunction

	/**
	 * Converts a number from any numeral system into an integer.
	 * The A in A2I stands for alpha-numeric.
	 * \param alphanumeric The alpha-numeric string which will be converted.
	 * \param chars The character pool of the numeral system.
	 * \return Returns the converted integer.
	 */
	function A2I takes string alphanumeric, string chars returns integer
		local integer value = 0
		local integer index = 1
		loop
			set value = value + ((FindString(chars, SubString(alphanumeric, (StringLength(alphanumeric) - 1), StringLength(alphanumeric)))) * index)
			exitwhen (StringLength(alphanumeric) == 1)
			set alphanumeric = SubString(alphanumeric, 0, (StringLength(alphanumeric) - 1))
			set index = index * StringLength(chars)
		endloop
		return value
	endfunction

	/// \author Vexorian
	/// <a href="http://www.wc3c.net/showthread.php?t=101407">source</a>
	function I2Roman takes integer n returns string
		local string r=""
		if n > 3999 or n < 1 then
			return I2S(n)
		endif
		loop
			exitwhen n<1000
			set r=r+"M"
			set n=n-1000
		endloop
		loop
			exitwhen n < 900
			set r=r+"CM"
			set n=n-900
		endloop
		loop
			exitwhen n<500
			set r=r+"D"
			set n=n-500
		endloop
		loop
			exitwhen n < 400
			set r=r+"CD"
			set n=n-400
		endloop
		loop
			exitwhen n<100
			set r=r+"C"
			set n=n-100
		endloop
		loop
			exitwhen n < 90
			set r=r+"XC"
			set n=n-90
		endloop
		loop
			exitwhen n<50
			set r=r+"L"
			set n=n-50
		endloop
		loop
			exitwhen n < 40
			set r=r+"XL"
			set n=n-40
		endloop
		loop
			exitwhen n<10
			set r=r+"X"
			set n=n-10
		endloop
		loop
			exitwhen n < 9
			set r=r+"IX"
			set n=n-9
		endloop
		loop
			exitwhen n<5
			set r=r+"V"
			set n=n-5
		endloop
		loop
			exitwhen n < 4
			set r=r+"IV"
			set n=n-4
		endloop
		loop
			exitwhen n<1
			set r=r+"I"
			set n=n-1
		endloop
		return r
	endfunction


	//! textmacro ALibraryCoreMathsConversionMacro takes TYPENAME, CHARS
		function I2$TYPENAME$ takes integer Integer returns string
			return I2A(Integer, $CHARS$)
		endfunction

		function $TYPENAME$2I takes string $TYPENAME$ returns integer
			return A2I($TYPENAME$, $CHARS$)
		endfunction
	//! endtextmacro

	//! runtextmacro ALibraryCoreMathsConversionMacro("Binary", "\"01\"")
	//! runtextmacro ALibraryCoreMathsConversionMacro("Octal", "\"01234567\"")
	//! runtextmacro ALibraryCoreMathsConversionMacro("Hexadecimal", "\"0123456789ABCDEF\"")

endlibrary