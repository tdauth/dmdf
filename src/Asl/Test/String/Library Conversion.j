library ALibraryTestStringConversion requires AStructCoreDebugUnitTest, ALibraryCoreDebugMisc, ACoreString

	//! runtextmacro A_UNIT_TEST("AStringConversionTest")
		private integer i

		//! runtextmacro A_TEST_CASE_INIT()
			set this.i = 0
		//! runtextmacro A_TEST_CASE_INIT_END()

		//! runtextmacro A_TEST_CASE_CLEAN()
			set this.i = 0
		//! runtextmacro A_TEST_CASE_CLEAN_END()

		//! runtextmacro A_TEST()
			//! runtextmacro A_TEST_CASE("Conversion")

				set this.i = 48
				loop
					exitwhen (this.i == 58)
					//! runtextmacro A_CHECK("AsciiToChar(this.i) == I2S(this.i - 48)")
					set this.i = this.i + 1
				//! runtextmacro A_TEST_CASE_END_LOOP()

				//! runtextmacro A_CHECK_2("StringToPlayerColor(\"ff0000\") == PLAYER_COLOR_RED", "Error in StringToPlayerColor().")
				//! runtextmacro A_CHECK_2("PlayerColorToString(PLAYER_COLOR_BLUE) == \"0000ff\"", "Error in PlayerColorToString().")
				//! runtextmacro A_CHECK_2("HighlightShortcut(\"Oh Lord forgive me!\", 'O', null) == \"|cffffcc00O|rh Lord forgive me!\"", "Error in HighlightShortcut().")
				//! runtextmacro A_CHECK_2("InsertLineBreaks(\"Hey there out in the jungle!\", 4) == \"Hey \nther\ne ou\nt in\n the\njung\nle!\"", "Error in InsertLineBreaks().")
				//! runtextmacro A_CHECK_2("GetTimeString(120) == \"02:00\"", "Error in GetTimeString().")
				//! runtextmacro A_CHECK_2("StringArg(StringArg(IntegerArg(\"You're %i years old and you're called %s. Besides you're %s.\", 0), \"Peter\"), \"nice\") == \"You're 0 years old and you're called Peter. Besides you're nice.\"", "Error in StringArg().")

			//! runtextmacro A_TEST_CASE_END()

		//! runtextmacro A_TEST_END()

	//! runtextmacro A_UNIT_TEST_END()

	function AStringConversionDebug takes nothing returns nothing
		//! runtextmacro A_TEST_RUN("AStringConversionTest")
		//! runtextmacro A_TEST_PRINT("AStringConversionTest")
	endfunction

endlibrary