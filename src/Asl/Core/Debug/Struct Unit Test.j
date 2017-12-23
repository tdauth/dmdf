library AStructCoreDebugUnitTest requires AStructCoreGeneralVector, ALibraryCoreDebugMisc

	/**
	 * \defgroup unittest Unit Test
	 * ASL provides some basic unit test functionality. Unit Tests are used for automatic tests with expected results to
	 * observe code changes and prevent unnoticed bugs.
	 * Below you can see a simple example of using the Unit Test API:
	 * \code
	//! runtextmacro A_UNIT_TEST("MyUnitTest")
		private integer a
		private integer i

		//! runtextmacro A_TEST_INIT()
			set this.a = 10
		//! runtextmacro A_TEST_INIT_END()

		//! runtextmacro A_TEST_CLEAN()
			set this.a = 0
		//! runtextmacro A_TEST_CLEAN_END()

		//! runtextmacro A_TEST_CASE_INIT()
			set this.a = 2 * this.a
		//! runtextmacro A_TEST_CASE_INIT_END()

		//! runtextmacro A_TEST_CASE_CLEAN()
			set this.a = 10
		//! runtextmacro A_TEST_CASE_CLEAN_END()

		//! runtextmacro A_TEST()
			//! runtextmacro A_TEST_CASE("TestCase0")

				//! runtextmacro A_CHECK("1 == 1")
				//! runtextmacro A_REQUIRE_2("1 == 1", "Oh my god!")

				set this.i = 0
				loop
					exitwhen (this.i == 100)
					//! runtextmacro A_REQUIRE_2("this.i < 100", "Should always be less 100.")
					set this.i = this.i + 1
				//! runtextmacro A_TEST_CASE_END_LOOP()

			//! runtextmacro A_TEST_CASE_END()
		//! runtextmacro A_TEST_END()

	//! runtextmacro A_UNIT_TEST_END()

	function myTestFunction takes nothing returns nothing
		//! runtextmacro A_TEST_RUN("MyUnitTest")
		//! runtextmacro A_TEST_PRINT("MyUnitTest")
		//! runtextmacro A_TEST_CASE_PRINT("MyUnitTest", "TestCase0")
	endfunction
	 * \endcode
	 * \ref A_UNIT_TEST creates a new unit test with the given name. As it declares a new struct internally
	 * you can declare methods and member variables between the macro call and the call of \ref A_UNIT_TEST_END
	 * With \ref A_TEST_INIT and \ref A_TEST_INIT_END you can enclose any initialization code.
	 * Init code is called before the whole unit test is started.
	 * Using \ref A_TEST_CLEAN and \ref A_TEST_CLEAN_END it's possible to do the same with clean up code.
	 * Clean up code is called after the whole unit test has ended.
	 * For single test cases there are similary macros: \ref A_TEST_CASE_INIT - \ref A_TEST_CASE_INIT_END and \ref A_TEST_CASE_CLEAN and \ref A_TEST_CASE_CLEAN_END.
	 * \note Between all these macros you can access any default or custom members and methods using "this".
	 *
	 * Your final test code has to be enclosed by \ref A_TEST and \ref A_TEST_END. For each test case \ref A_TEST_CASE and \ref A_TEST_CASE_END should be used since errors will be assigned to test cases, so not all cases must've been failed if the unit test had failed.
	 * Now you can use any require or check macros in your test case:
	 * <ul>
	 * <li>\ref A_CHECK expects a conditional expression, test case continues on fail </li>
	 * <li>\ref A_CHECK_2 expects a conditional expression and an error message, test case continues on fail </li>
	 * <li>\ref A_REQUIRE expects a conditional expression, test case stops on fail </li>
	 * <li>\ref A_REQUIRE_2 expects a conditional expression and an error message, test case stops on fail </li>
	 * </ul>
	 *
	 * \note Use \ref A_TEST_CASE_END_LOOP to end loops in test cases to. Otherwise, canceling test cases cannot be guaranteed!
	 *
	 * Each unit test can be run using \ref A_TEST_RUN and its given name as parameter. In the example above we declared the function "myTestFunction" which runs our unit test. This function could be called on any event.
	 * \ref A_TEST_PRINT prints all test cases with error counts and messages.
	 */
	struct ATestCase
		private AStringVector m_errors
		private string m_name
		private boolean m_canceled

		public method name takes nothing returns string
			return this.m_name
		endmethod

		public method cancel takes nothing returns nothing
			set this.m_canceled = true
		endmethod

		public method canceled takes nothing returns boolean
			return this.m_canceled
		endmethod

		public method print takes nothing returns nothing
			local integer i = 0
			if (not this.m_errors.isEmpty()) then
				debug call Print(this.m_name + " with " + I2S(this.m_errors.size()) + " errors:")
				set i = 0
				loop
					exitwhen (i == this.m_errors.size())
					if (this.m_errors[i] != null) then
						debug call Print("- " + this.m_errors[i])
					endif
					set i = i + 1
				endloop
			else
				debug call Print(this.m_name + " succeded.")
			endif
		endmethod

		public method reset takes nothing returns nothing
			call this.m_errors.clear()
			set this.m_canceled = false
		endmethod

		public method addError takes string error returns nothing
			call this.m_errors.pushBack(error)
		endmethod

		public method succeded takes nothing returns boolean
			return this.m_errors.isEmpty()
		endmethod

		public method failed takes nothing returns boolean
			return not this.succeded()
		endmethod

		public static method create takes string name returns thistype
			local thistype this = thistype.allocate()
			set this.m_errors = AStringVector.create()
			set this.m_name = name
			set this.m_canceled = false

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_errors.destroy()
		endmethod
	endstruct

	struct AUnitTest
		private static AIntegerVector m_unitTests
		private string m_name
		private AIntegerVector m_testCases
		private ATestCase m_current

		public method name takes nothing returns string
			return this.m_name
		endmethod

		/// \todo Should be protected, vJass bug.
		public method testCases takes nothing returns AIntegerVector
			return this.m_testCases
		endmethod

		/// \todo Should be protected, vJass bug.
		public method setCurrent takes ATestCase current returns nothing
			set this.m_current = current
		endmethod

		/// \todo Should be protected, vJass bug.
		public method current takes nothing returns ATestCase
			return this.m_current
		endmethod

		public method findTestCase takes string name returns ATestCase
			local integer i = 0
			loop
				exitwhen (i == this.testCases().size())
				if (ATestCase(this.testCases()[i]).name() == name) then
					return ATestCase(this.testCases()[i])
				endif
				set i = i + 1
			endloop
			return 0
		endmethod

		public method print takes nothing returns nothing
			local integer i = 0
			debug call Print(this.m_name + ":")
			loop
				exitwhen (i == this.m_testCases.size())
				call ATestCase(this.m_testCases[i]).print()
				set i = i + 1
			endloop
		endmethod

		public method reset takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_testCases.size())
				call ATestCase(this.m_testCases[i]).reset()
				set i = i + 1
			endloop
		endmethod

		public method succeded takes nothing returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_testCases.size())
				if (not ATestCase(this.m_testCases[i]).succeded()) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		public method failed takes nothing returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_testCases.size())
				if (not ATestCase(this.m_testCases[i]).succeded()) then
					return true
				endif
				set i = i + 1
			endloop
			return false
		endmethod

		public stub method onInitialize takes nothing returns nothing
		endmethod

		public stub method onCleanup takes nothing returns nothing
		endmethod

		public stub method onInitializeTestCase takes nothing returns nothing
		endmethod

		public stub method onCleanupTestCase takes nothing returns nothing
		endmethod

		public stub method run takes nothing returns nothing
			call this.reset()
		endmethod

		public static method create takes string name returns thistype
			local thistype this = thistype.allocate()
			set this.m_name = name
			set this.m_testCases = AIntegerVector.create()
			set this.m_current = 0
			call thistype.m_unitTests.pushBack(this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call thistype.m_unitTests.remove(this)
			loop
				exitwhen (this.m_testCases.empty())
				call ATestCase(this.m_testCases.back()).destroy()
				call this.m_testCases.popBack()
			endloop
			call this.m_testCases.destroy()
		endmethod

		public static method onInit takes nothing returns nothing
			set thistype.m_unitTests = AIntegerVector.create()
		endmethod

		public static method unitTests takes nothing returns AIntegerVector
			return thistype.m_unitTests
		endmethod

		public static method find takes string name returns thistype
			local integer i = 0
			loop
				exitwhen (i == thistype.unitTests().size())
				if (thistype(thistype.unitTests()[i]).name() == name) then
					return thistype(thistype.unitTests()[i])
				endif
				set i = i + 1
			endloop
			return 0
		endmethod

		public static method contains takes string name returns boolean
			return thistype.find(name) != 0
		endmethod
	endstruct

	/*
	 TODO printing code won't work with string parameters:
	 http://www.wc3c.net/showpost.php?p=1136328&postcount=178
	*/

	//! textmacro A_CHECK takes CONDITION
		if (not ($CONDITION$)) then
			call this.current().addError(null)
		endif
	//! endtextmacro

	//! textmacro A_CHECK_2 takes CONDITION, MESSAGE
		if (not ($CONDITION$)) then
			call this.current().addError("$MESSAGE$")
		endif
	//! endtextmacro

	//! textmacro A_REQUIRE takes CONDITION
		if (not ($CONDITION$)) then
			call this.current().addError(null)
			call this.current().cancel()
			exitwhen (true)
		endif
	//! endtextmacro

	//! textmacro A_REQUIRE_2 takes CONDITION, MESSAGE
		if (not ($CONDITION$)) then
			call this.current().addError("$MESSAGE$")
			call this.current().cancel()
			exitwhen (true)
		endif
	//! endtextmacro

	//! textmacro A_UNIT_TEST takes NAME
		struct AUnitTest$NAME$ extends AUnitTest

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate("$NAME$")

			return this
		endmethod
	//! endtextmacro

	//! textmacro A_UNIT_TEST_END
		endstruct
	//! endtextmacro

	//! textmacro A_TEST_CASE takes NAME
		set testCase = ATestCase(this.findTestCase("$NAME$"))
		if (testCase == 0) then
			call this.setCurrent(ATestCase.create("$NAME$"))
			call this.testCases().pushBack(this.current())
		else
			call this.setCurrent(testCase)
		endif
		call this.onInitializeTestCase()
		loop
	//! endtextmacro

	//! textmacro A_TEST_CASE_END
			exitwhen (true)
		endloop
		call this.onCleanupTestCase()
		call this.setCurrent(0)
	//! endtextmacro

	//! textmacro A_TEST_CASE_END_LOOP
		endloop
		exitwhen (this.current().canceled())
	//! endtextmacro

	//! textmacro A_TEST_CASE_INIT
		public stub method onInitializeTestCase takes nothing returns nothing
	//! endtextmacro

	//! textmacro A_TEST_CASE_INIT_END
		endmethod
	//! endtextmacro

	//! textmacro A_TEST_CASE_CLEAN
		public stub method onCleanupTestCase takes nothing returns nothing
	//! endtextmacro

	//! textmacro A_TEST_CASE_CLEAN_END
		endmethod
	//! endtextmacro

	//! textmacro A_TEST_INIT
		public stub method onInitialize takes nothing returns nothing
	//! endtextmacro

	//! textmacro A_TEST_INIT_END
		endmethod
	//! endtextmacro

	//! textmacro A_TEST_CLEAN
		public stub method onCleanup takes nothing returns nothing
	//! endtextmacro

	//! textmacro A_TEST_CLEAN_END
		endmethod
	//! endtextmacro

	//! textmacro A_TEST
		public stub method run takes nothing returns nothing
			local ATestCase testCase = 0
			call super.run()
			call this.onInitialize()
	//! endtextmacro

	//! textmacro A_TEST_END
			call this.onCleanup()
		endmethod
	//! endtextmacro

	//! textmacro A_TEST_RUN takes NAME
		if (AUnitTest.contains("$NAME$")) then
			call AUnitTest.find("$NAME$").run()
		else
			call AUnitTest$NAME$.create().run()
		endif
	//! endtextmacro

	//! textmacro A_TEST_PRINT takes NAME
		if (AUnitTest.contains("$NAME$")) then
			call AUnitTest.find("$NAME$").print()
		debug else
			debug call Print("Contains not $NAME$")
		endif
	//! endtextmacro

	//! textmacro A_TEST_CASE_PRINT takes UNITTESTNAME, TESTCASENAME
		if (AUnitTest.contains("$UNITTESTNAME$")) then
			if (AUnitTest.find("$UNITTESTNAME$").findTestCase("$TESTCASENAME$") != 0) then
				call AUnitTest.find("$UNITTESTNAME$").findTestCase("$TESTCASENAME$").print()
			debug else
				debug call Print("Contains not $TESTCASENAME$")
			endif
		debug else
			debug call Print("Contains not $UNITTESTNAME$")
		endif
	//! endtextmacro

endlibrary