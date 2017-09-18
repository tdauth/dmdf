library ALibraryTestBonusModBonusMod requires AStructCoreDebugUnitTest, ALibraryCoreDebugMisc, ALibrarySystemsBonusModBonusMod

	/*
	constant integer A_BONUS_TYPE_DAMAGE = 0
	constant integer A_BONUS_TYPE_ARMOR = 1
	constant integer A_BONUS_TYPE_LIFE = 2
	constant integer A_BONUS_TYPE_MANA = 3
	constant integer A_BONUS_TYPE_SIGHT_RANGE = 4 // Sight Range Bonus
	constant integer A_BONUS_TYPE_MANA_REGENERATION = 5 // Mana Regeneration Bonus (A % value)
	constant integer A_BONUS_TYPE_LIFE_REGENERATION = 6
	*/
	//! runtextmacro A_UNIT_TEST("ABonusModTest")
		private integer bonusType
		private integer amount
		private unit whichUnit

		//! runtextmacro A_TEST_INIT()
			call AInitBonusMod()
		//! runtextmacro A_TEST_INIT_END()

		//! runtextmacro A_TEST_CASE_INIT()
			set this.bonusType = 0
			set this.amount = 0
			set this.whichUnit = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'hpea', 0.0, 0.0, 0.0)
		//! runtextmacro A_TEST_CASE_INIT_END()

		//! runtextmacro A_TEST_CASE_CLEAN()
			call RemoveUnit(this.whichUnit)
			set this.whichUnit = null
		//! runtextmacro A_TEST_CASE_CLEAN_END()

		private static method bonusTypeName takes integer bonusType returns string
			if (bonusType == A_BONUS_TYPE_DAMAGE) then
				return "Damage"
			elseif (bonusType == A_BONUS_TYPE_ARMOR) then
				return "Armor"
			elseif (bonusType == A_BONUS_TYPE_LIFE) then
				return "Life"
			elseif (bonusType == A_BONUS_TYPE_MANA) then
				return "Mana"
			elseif (bonusType == A_BONUS_TYPE_SIGHT_RANGE) then
				return "Sight range"
			elseif (bonusType == A_BONUS_TYPE_MANA_REGENERATION) then
				return "Mana regeneration"
			elseif (bonusType == A_BONUS_TYPE_LIFE_REGENERATION) then
				return "Life regeneration"
			endif
			return ""
		endmethod

		//! runtextmacro A_TEST()
			/*
			//! runtextmacro A_TEST_CASE("Test all with all possible values")

				set this.bonusType = 0
				loop
					exitwhen (this.bonusType == A_BONUS_MAX_TYPES)
					set this.amount = 1
					if (ABonusIsBigValue(this.bonusType)) then
						set this.amount = this.amount * A_BONUS_BIG_VALUES_FACTOR
					endif
					// TODO worker stays with +8 damage, tests cancels after new amount 40, this is because there are too many operations in the loop, removing one loop (for example the bonus type loop) doesn't help, if you add more function calls like prints it will stop earlier
					loop
						exitwhen (this.amount > ABonusMax(this.bonusType))
						//! runtextmacro A_CHECK_2("AUnitGetBonus(this.whichUnit, this.bonusType) == 0", "Bonus should be 0 for \" + thistype.bonusTypeName(this.bonusType) + \".")
						//! runtextmacro A_CHECK_2("AUnitSetBonus(this.whichUnit, this.bonusType, this.amount)", "Bonus couldn't be set for \" + thistype.bonusTypeName(this.bonusType) + \".")
						//! runtextmacro A_CHECK_2("AUnitGetBonus(this.whichUnit, this.bonusType) == this.amount", "Bonus should be \" + I2S(this.amount) + \" now for \" + thistype.bonusTypeName(this.bonusType) + \".")
						//! runtextmacro A_REQUIRE_2("AUnitClearBonus(this.whichUnit, this.bonusType)", "Bonus couldn't be cleared for \" + thistype.bonusTypeName(this.bonusType) + \".")
						//! runtextmacro A_CHECK_2("AUnitAddBonus(this.whichUnit, this.bonusType, this.amount)", "Bonus couldn't be added for \" + thistype.bonusTypeName(this.bonusType) + \".")
						//! runtextmacro A_CHECK_2("AUnitGetBonus(this.whichUnit, this.bonusType) == this.amount", "Bonus should be \" + I2S(this.amount) + \" now (second time) for \" + thistype.bonusTypeName(this.bonusType) + \".")
						//! runtextmacro A_REQUIRE_2("AUnitRemoveBonus(this.whichUnit, this.bonusType, this.amount)", "Bonus couldn't be removed for \" + thistype.bonusTypeName(this.bonusType) + \".")
						//! runtextmacro A_CHECK_2("AUnitGetBonus(this.whichUnit, this.bonusType) == 0", "Bonus should be 0 now (finally) for \" + thistype.bonusTypeName(this.bonusType) + \".")
						if (ABonusIsBigValue(this.bonusType)) then
							set this.amount = (this.amount + 1) * A_BONUS_BIG_VALUES_FACTOR
						else
							set this.amount = this.amount + 1
						endif
					//! runtextmacro A_TEST_CASE_END_LOOP()
					set this.bonusType = this.bonusType + 1
				//! runtextmacro A_TEST_CASE_END_LOOP()
			//! runtextmacro A_TEST_CASE_END()
			*/

			//! runtextmacro A_TEST_CASE("Test all with fixed")

				set this.bonusType = 0
				loop
					exitwhen (this.bonusType == A_BONUS_MAX_TYPES)
					set this.amount = 5
					if (ABonusIsBigValue(this.bonusType)) then
						set this.amount = this.amount * A_BONUS_BIG_VALUES_FACTOR
					endif
					//! runtextmacro A_CHECK_2("AUnitGetBonus(this.whichUnit, this.bonusType) == 0", "Bonus should be 0 for \" + thistype.bonusTypeName(this.bonusType) + \".")
					//! runtextmacro A_CHECK_2("AUnitSetBonus(this.whichUnit, this.bonusType, this.amount)", "Bonus couldn't be set for \" + thistype.bonusTypeName(this.bonusType) + \".")
					//! runtextmacro A_CHECK_2("AUnitGetBonus(this.whichUnit, this.bonusType) == this.amount", "Bonus should be \" + I2S(this.amount) + \" now for \" + thistype.bonusTypeName(this.bonusType) + \".")
					//! runtextmacro A_REQUIRE_2("AUnitClearBonus(this.whichUnit, this.bonusType)", "Bonus couldn't be cleared for \" + thistype.bonusTypeName(this.bonusType) + \".")
					//! runtextmacro A_CHECK_2("AUnitAddBonus(this.whichUnit, this.bonusType, this.amount)", "Bonus couldn't be added for \" + thistype.bonusTypeName(this.bonusType) + \".")
					//! runtextmacro A_CHECK_2("AUnitGetBonus(this.whichUnit, this.bonusType) == this.amount", "Bonus should be \" + I2S(this.amount) + \" now (second time) for \" + thistype.bonusTypeName(this.bonusType) + \".")
					//! runtextmacro A_REQUIRE_2("AUnitRemoveBonus(this.whichUnit, this.bonusType, this.amount)", "Bonus couldn't be removed for \" + thistype.bonusTypeName(this.bonusType) + \".")
					//! runtextmacro A_CHECK_2("AUnitGetBonus(this.whichUnit, this.bonusType) == 0", "Bonus should be 0 now (finally) for \" + thistype.bonusTypeName(this.bonusType) + \".")
					set this.bonusType = this.bonusType + 1
				//! runtextmacro A_TEST_CASE_END_LOOP()

			//! runtextmacro A_TEST_CASE_END()
		//! runtextmacro A_TEST_END()

	//! runtextmacro A_UNIT_TEST_END()

	function ABonusModDebug takes nothing returns nothing
		//! runtextmacro A_TEST_RUN("ABonusModTest")
		//! runtextmacro A_TEST_PRINT("ABonusModTest")
	endfunction

endlibrary