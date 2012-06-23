library StructGameRoutines requires Asl

	struct Routines
		private static ARoutine m_moveTo
		private static AStringVector m_trainAnimations
		private static ARoutine m_train
		private static ARoutine m_enterHouse
		private static ARoutine m_leaveHouse
		private static ARoutine m_hammer
		private static ARoutine m_talk
		private static ARoutine m_drink
		private static ARoutine m_harvest

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method trainEndAction takes ARoutinePeriod period returns nothing
			call ResetUnitAnimation(period.unit())
		endmethod

		/// @todo Should check whether the unit has animation
		private static method trainTargetAction takes ARoutinePeriod period returns nothing
			local integer index = GetRandomInt(0, thistype.m_trainAnimations.backIndex())
			call QueueUnitAnimation(period.unit(), thistype.m_trainAnimations[index])
			call TriggerSleepAction(2.0)
			call AContinueRoutineLoop(period, thistype.trainTargetAction)
		endmethod

		private static method enterHouseTargetAction takes ARoutinePeriod period returns nothing
			debug call Print("Unit " + GetUnitName(period.unit()) + " enters house.")
			call ShowUnit(period.unit(), false)
		endmethod

		private static method leaveHouseTargetAction takes ARoutinePeriod period returns nothing
			debug call Print("Unit " + GetUnitName(period.unit()) + " leaves house.")
			call SetUnitFacing(period.unit(), GetUnitFacing(period.unit()) - 180.0) // turn around
			call ShowUnit(period.unit(), true)
		endmethod

		private static method hammerEndAction takes ARoutinePeriod period returns nothing
			//debug call Print("Reset hammer animation.")
			call ResetUnitAnimation(period.unit())
		endmethod

		/// Animation of villager.
		private static method hammerTargetAction takes ARoutinePeriod period returns nothing
			call QueueUnitAnimation(period.unit(), "Attack")
			call PlaySoundFileOnUnit("Buildings\\Human\\Blacksmith\\BlacksmithWhat1.wav", period.unit())
			call TriggerSleepAction(1.0)
			call AContinueRoutineLoop(period, thistype.hammerTargetAction)
		endmethod

		private static method talkEndAction takes ARoutinePeriod period returns nothing
			call ResetUnitAnimation(period.unit())
		endmethod

		private static method talkFilter takes nothing returns boolean
			return GetOwningPlayer(GetEnumUnit()) == Player(PLAYER_NEUTRAL_PASSIVE) and not IsUnitPaused(GetEnumUnit())
		endmethod

		private static method talkTargetAction takes ARoutinePeriod period returns nothing
			local group whichGroup = CreateGroup()
			local unit whichUnit = null
			debug call Print("Talk target action.")
			call GroupEnumUnitsInRange(whichGroup, GetUnitX(period.unit()), GetUnitY(period.unit()), 400.0, Filter(function thistype.talkFilter))
			debug call Print("Talk: Found " + I2S(CountUnitsInGroup(whichGroup)) + " possible partners.")
			set whichUnit = FindClosestUnit(whichGroup, GetUnitX(period.unit()), GetUnitY(period.unit()))
			debug call Print(GetUnitName(whichUnit) + " is the closest partner.")

			if (whichUnit != null) then
				call SetUnitFacingToFaceUnit(period.unit(), whichUnit)
				call QueueUnitAnimation(period.unit(), "Stand Talk")
				debug call Print("Talking to.")
			endif
			call DestroyGroup(whichGroup)
			set whichGroup = null
			call TriggerSleepAction(1.0)
			call AContinueRoutineLoop(period, thistype.talkTargetAction)
		endmethod

		private static method drinkEndAction takes ARoutinePeriod period returns nothing
			call ResetUnitAnimation(period.unit())
		endmethod

		/// @todo FIXME
		private static method drinkTargetAction takes ARoutinePeriod period returns nothing
			call QueueUnitAnimation(period.unit(), "Stand")
			call TriggerSleepAction(1.0)
			call AContinueRoutineLoop(period, thistype.drinkTargetAction)
		endmethod

		private static method harvestEndAction takes ARoutinePeriod period returns nothing
			call ResetUnitAnimation(period.unit())
		endmethod

		private static method harvestTargetAction takes ARoutinePeriod period returns nothing
			call QueueUnitAnimation(period.unit(), "Stand Work")
			call TriggerSleepAction(1.266)
			call AContinueRoutineLoop(period, thistype.harvestTargetAction)
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_moveTo = ARoutine.create(true, false, 0, 0, 0)
			set thistype.m_trainAnimations = AStringVector.create()
			call thistype.m_trainAnimations.pushBack("Attack 1")
			call thistype.m_trainAnimations.pushBack("Attack 2")
			call thistype.m_trainAnimations.pushBack("Attack 3")
			set thistype.m_train = ARoutine.create(true, true, 0, thistype.trainEndAction, thistype.trainTargetAction)
			set thistype.m_enterHouse = ARoutine.create(true, false, 0, 0, thistype.enterHouseTargetAction)
			set thistype.m_leaveHouse = ARoutine.create(true, false, 0, 0, thistype.leaveHouseTargetAction)
			set thistype.m_hammer = ARoutine.create(true, true, 0, thistype.hammerEndAction, thistype.hammerTargetAction)
			set thistype.m_talk = ARoutine.create(true, true, 0, thistype.talkEndAction, thistype.talkTargetAction)
			set thistype.m_drink = ARoutine.create(true, true, 0, thistype.drinkEndAction, thistype.drinkTargetAction)
			set thistype.m_harvest = ARoutine.create(true, true, 0, thistype.harvestEndAction, thistype.harvestTargetAction)
		endmethod

		public static method moveTo takes nothing returns ARoutine
			return thistype.m_moveTo
		endmethod

		public static method train takes nothing returns ARoutine
			return thistype.m_train
		endmethod

		public static method enterHouse takes nothing returns ARoutine
			return thistype.m_enterHouse
		endmethod

		public static method leaveHouse takes nothing returns ARoutine
			return thistype.m_leaveHouse
		endmethod

		public static method hammer takes nothing returns ARoutine
			return thistype.m_hammer
		endmethod

		public static method talk takes nothing returns ARoutine
			return thistype.m_talk
		endmethod

		public static method drink takes nothing returns ARoutine
			return thistype.m_drink
		endmethod

		public static method harvest takes nothing returns ARoutine
			return thistype.m_harvest
		endmethod
	endstruct

endlibrary