library ALibraryTestStringPool requires AStructCoreDebugUnitTest, ALibraryCoreDebugMisc, ACoreString

	//! runtextmacro A_UNIT_TEST("AStringPoolTest")

		//! runtextmacro A_TEST()
			//! runtextmacro A_TEST_CASE("Pool")
				//! runtextmacro A_CHECK_2("IsStringFromCharacterPool(GetRandomCharacter(\"abc\"), \"abc\")", "Error in IsStringFromCharacterPool().")
				//! runtextmacro A_CHECK_2("IsStringAlphabetical(GetRandomAlphabeticalCharacter())", "Error in IsStringAlphabetical().")
				//! runtextmacro A_CHECK_2("IsStringNumeral(GetRandomNumeralCharacter())", "Error in IsStringNumeral().")
				//! runtextmacro A_CHECK_2("IsStringSpecial(GetRandomSpecialCharacter())", "Error in IsStringSpecial().")
				//! runtextmacro A_CHECK_2("IsStringWhiteSpace(GetRandomWhiteSpaceCharacter())", "Error in IsStringWhiteSpace().")
				//! runtextmacro A_CHECK_2("IsStringSign(GetRandomSignCharacter())", "Error in IsStringSign().")
				//! runtextmacro A_CHECK_2("IsStringInteger(\"-23\") and IsStringInteger(\"+23\") and IsStringInteger(\"12\") and (not IsStringInteger(\"34,3\"))", "Error in IsStringInteger().")
				//! runtextmacro A_CHECK_2("IsStringBinary(\"+101\") and IsStringBinary(\"101\") and IsStringBinary(\"-0\") and (not IsStringBinary(\"1201\")) and (not IsStringBinary(\"010\"))", "Error in IsStringBinary().")
				//! runtextmacro A_CHECK_2("IsStringOctal(\"00023\") and IsStringOctal(\"-123\") and IsStringOctal(\"+077\") and (not IsStringOctal(\"2148\"))", "Error in IsStringOctal().")
				//! runtextmacro A_CHECK_2("IsStringHexadecimal(\"+AF23\") and IsStringHexadecimal(\"-acf1034a\") and IsStringHexadecimal(\"-0x1439\") and IsStringHexadecimal(\"0x1AF9\") and (not IsStringHexadecimal(\"0AF21\"))", "Error in IsStringHexadecimal().")
				//! runtextmacro A_CHECK_2("(not IsStringInteger(\"\")) and (not IsStringBinary(\"\")) and (not IsStringOctal(\"\")) and (not IsStringHexadecimal(\"\"))", "Error in empty string string pool test.")

				//! runtextmacro A_CHECK_2("StringTrimLeft(\"  Peter lief heim!  \") == \"Peter lief heim!  \"", "Error in StringTrimLeft().")
				//! runtextmacro A_CHECK_2("StringTrimRight(\"  Peter lief heim!  \") == \"  Peter lief heim!\"", "Error in StringTrimRight().")
				//! runtextmacro A_CHECK_2("StringTrim(\"  Peter lief heim!  \") == \"Peter lief heim!\"", "Error in StringTrim().")

			//! runtextmacro A_TEST_CASE_END()
		//! runtextmacro A_TEST_END()

	//! runtextmacro A_UNIT_TEST_END()

	function AStringPoolDebug takes nothing returns nothing
		//! runtextmacro A_TEST_RUN("AStringPoolTest")
		//! runtextmacro A_TEST_PRINT("AStringPoolTest")
	endfunction

endlibrary