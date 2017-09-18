library ALibraryTestStringMisc requires AStructCoreDebugUnitTest, ALibraryCoreDebugMisc, ACoreString

	//! runtextmacro A_UNIT_TEST("AStringMiscTest")

		//! runtextmacro A_TEST()
			//! runtextmacro A_TEST_CASE("Misc")
				//! runtextmacro A_CHECK("FindString(\"Peter went home!\", \"went\") == 6")
				//! runtextmacro A_CHECK("FindString(\"Peter went home!\", \"leaves\") == -1")

				//! runtextmacro A_CHECK("ReplaceSubString(\"Peter went home!\", 6, \"is at\") == \"Peter is athome!\"") // normal replacement with overriding chars
				//! runtextmacro A_CHECK("ReplaceSubString(\"Peter went home!\", -10, \"Hansi\") == \"Hansi went home!\"") // negative values, replacement should start at 0
				//! runtextmacro A_CHECK("ReplaceSubString(\"Peter went home!\", 2341, \" Besides he lost his keys!\") == \"Peter went home! Besides he lost his keys!\"") // big values, replacement means appending string

				//! runtextmacro A_CHECK("ReplaceString(\"Peter went home!\", \"back\", \"to his mother\") == \"Peter went home!\"") // no changes
				//! runtextmacro A_CHECK("ReplaceString(\"Peter went home!\", \"home\", \"to his mother\") == \"Peter went to his mother!\"") // no override, usual replacement

				//! runtextmacro A_CHECK("RemoveSubString(\"Peter went home!\", 0, 6) == \"went home!\"")
				//! runtextmacro A_CHECK("RemoveSubString(\"Peter went home!\", 0, StringLength(\"Peter went home!\")) == \"\"")
				//! runtextmacro A_CHECK("RemoveSubString(\"Peter went home!\", StringLength(\"Peter went home!\") - 6, 6) == \"Peter went\"")

				//! runtextmacro A_CHECK("RemoveSubString(\"Peter went home!\", -2332, 6) == \"went home!\"")
				//! runtextmacro A_CHECK("RemoveSubString(\"Peter went home!\", -2332, 343435) == \"\"")
				//! runtextmacro A_CHECK("RemoveSubString(\"Peter went home!\", 434, 343435) == \"Peter went home!\"")

				//! runtextmacro A_CHECK("RemoveString(\"Peter went home!\", \"Peter \") == \"went home!\"")
				//! runtextmacro A_CHECK("RemoveString(\"Peter went home!\", \"back\") == \"Peter went home!\"")

				//! runtextmacro A_CHECK("InsertString(\"Peter went home!\", 0, \"Our wonderful \") == \"Our wonderful Peter went home!\"")
				//! runtextmacro A_CHECK("InsertString(\"Peter went home!\", -2323, \"Our wonderful \") == \"Our wonderful Peter went home!\"")
				//! runtextmacro A_CHECK("InsertString(\"Peter went home!\", StringLength(\"Peter went home!\"), \" And this is the end!\") == \"Peter went home! And this is the end!\"")
				//! runtextmacro A_CHECK("InsertString(\"Peter went home!\", 0, \"\") == \"Peter went home!\"")

				//! runtextmacro A_CHECK("ReverseString(\"Peter went home!\") == \"!emoh tnew reteP\"")
				//! runtextmacro A_CHECK("ReverseString(\"\") == \"\"")

				//! runtextmacro A_CHECK("StringMatch(\"Peter went home!\", \"peter went home!\", false)")
				//! runtextmacro A_CHECK("StringMatch(\"Peter went home!\", \"WENT\", false)")
				//! runtextmacro A_CHECK("StringMatch(\"Peter went home!\", \"*WENT*\", false)")
				//! runtextmacro A_CHECK("StringMatch(\"Peter went home!\", \"[P]\", true)")
				//! runtextmacro A_CHECK("not StringMatch(\"Peter went home!\", \"[p]\", true)")
				//! runtextmacro A_CHECK("StringMatch(\"*?[\", \"\\*\\?\\[\", true)")
/*
TODO at least two errors
				//! runtextmacro A_CHECK("StringLeft(\"Peter went home!\", 5) == \"Peter\"")
				//! runtextmacro A_CHECK("StringLeft(\"Peter went home!\", 534) == \"Peter went home!\"")

				//! runtextmacro A_CHECK("StringRight(\"Peter went home!\", 5) == \"home!\"")
				//! runtextmacro A_CHECK("StringRight(\"Peter went home!\", 534) == \"Peter went home!\"")

				//! runtextmacro A_CHECK("StringAppend(\"Peter went home!\", \"\") == \"Peter went home!\"")
				//! runtextmacro A_CHECK("StringAppend(\"Peter went home!\", \"!!\") == \"Peter went home!!!\"")


				//! runtextmacro A_CHECK("StringPrepend(\"Peter went home!\", \"\") == \"Peter went home!\"")
				//! runtextmacro A_CHECK("StringPrepend(\"Peter went home!\", \"Our wonderful \") == \"Our wonderful Peter went home!\"")

				//! runtextmacro A_CHECK("StringRepeated(\"Peter went home!\", 0) == \"\"")
				//! runtextmacro A_CHECK("StringRepeated(\"Peter went home!\", -2334) == \"\"")
				//! runtextmacro A_CHECK("StringRepeated(\"Peter went home!\", 1) == \"Peter went home!\"")

				//! runtextmacro A_CHECK("StringResize(\"Peter went home!\", 5) == \"Peter\"")
				//! runtextmacro A_CHECK("StringResize(\"Peter went home!\", StringLength(\"Peter went home!\") + 4) == \"Peter went home!    \"")
				//! runtextmacro A_CHECK("StringResize(\"Peter went home!\", 0) == \"\"")
				//! runtextmacro A_CHECK("StringResize(\"Peter went home!\", -123) == \"\"")

				//! runtextmacro A_CHECK("StringTruncate(\"Peter went home!\", 0) == \"\"")
				//! runtextmacro A_CHECK("StringTruncate(\"Peter went home!\", -332) == \"\"")
				//! runtextmacro A_CHECK("StringTruncate(\"Peter went home!\", 6) == \"went home!\"")
				//! runtextmacro A_CHECK("StringTruncate(\"Peter went home!\", 2342) == \"\"")
				*/
			//! runtextmacro A_TEST_CASE_END()

		//! runtextmacro A_TEST_END()

	//! runtextmacro A_UNIT_TEST_END()

	function AStringMiscDebug takes nothing returns nothing
		//! runtextmacro A_TEST_RUN("AStringMiscTest")
		//! runtextmacro A_TEST_PRINT("AStringMiscTest")
	endfunction

endlibrary