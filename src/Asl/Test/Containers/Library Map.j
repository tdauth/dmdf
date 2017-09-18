library ALibraryTestContainersMap requires AStructCoreDebugBenchmark, AStructCoreDebugUnitTest, ALibraryCoreDebugMisc, ACoreString, AStructCoreGeneralMap

	//! runtextmacro A_UNIT_TEST("AMapTest")
		private integer i
		private AIntegerMap map
		private AIntegerMapIterator iterator

		//! runtextmacro A_TEST_CASE_INIT()
			set this.i = 0
			set this.map = AIntegerMap.create()
			set this.i = 0
			loop
				exitwhen (this.map.size() == 100)
				set this.map[this.i] = GetRandomInt(0, 10000)
			endloop
			set this.iterator = 0
		//! runtextmacro A_TEST_CASE_INIT_END()

		//! runtextmacro A_TEST_CASE_CLEAN()
			call this.map.destroy()
			if (this.iterator != 0) then
				call this.iterator.destroy()
			endif
		//! runtextmacro A_TEST_CASE_CLEAN_END()

		//! runtextmacro A_TEST()
			//! runtextmacro A_TEST_CASE("Check Map")

				//! runtextmacro A_CHECK("this.map.size() == 100")

				set this.i = 0
				loop
					exitwhen (this.map.size() == 100)
					//! runtextmacro A_REQUIRE_2("this.map[this.i] >= 0 and this.map[this.i] <= 10000", "Map values should be within 0 and 10000.")
					set this.i = this.i + 1
				//! runtextmacro A_TEST_CASE_END_LOOP()

			//! runtextmacro A_TEST_CASE_END()

			//! runtextmacro A_TEST_CASE("Check Map Iterator")

				set this.iterator = this.map.begin()

				//! runtextmacro A_REQUIRE("this.iterator != 0")
				//! runtextmacro A_REQUIRE("this.map.end() != 0")

				set this.i = 0
				loop
					exitwhen (this.iterator == this.map.end())
					//! runtextmacro A_CHECK("this.iterator.key() == this.i")
					//! runtextmacro A_CHECK("this.iterator.data() >= 0 and this.iterator.data() <= 10000")
					set this.i = this.i + 1
					call this.iterator.next()
				//! runtextmacro A_TEST_CASE_END_LOOP()

			//! runtextmacro A_TEST_CASE_END()

			//! runtextmacro A_TEST_CASE("Erase")

				set this.iterator = this.map.begin()

				//! runtextmacro A_REQUIRE("this.iterator != 0")

				call this.map.erase(this.iterator).destroy() // destroy resulting iterator to prevent leaks

				//! runtextmacro A_REQUIRE("this.map.size() == 99")

			//! runtextmacro A_TEST_CASE_END()
		//! runtextmacro A_TEST_END()

	//! runtextmacro A_UNIT_TEST_END()

	function AMapDebug takes nothing returns nothing
		//! runtextmacro A_TEST_RUN("AMapTest")
		//! runtextmacro A_TEST_PRINT("AMapTest")
	endfunction

endlibrary