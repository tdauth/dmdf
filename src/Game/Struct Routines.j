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

		private static method trainEndAction takes ARoutineData routineData returns nothing
			call ResetUnitAnimation(routineData.routineUnitData().unit())
		endmethod

		/// @todo Should check whether the unit has animation
		private static method trainTargetAction takes ARoutineData routineData returns nothing
			local integer index = GetRandomInt(0, thistype.m_trainAnimations.backIndex())
			call QueueUnitAnimation(routineData.routineUnitData().unit(), thistype.m_trainAnimations[index])
			call TriggerSleepAction(2.0)
			call AContinueRoutineLoop(routineData, thistype.trainTargetAction)
		endmethod

		private static method enterHouseTargetAction takes ARoutineData routineData returns nothing
			debug call Print("Unit " + GetUnitName(routineData.routineUnitData().unit()) + " enters house.")
			call ShowUnit(routineData.routineUnitData().unit(), false)
		endmethod

		private static method leaveHouseTargetAction takes ARoutineData routineData returns nothing
			debug call Print("Unit " + GetUnitName(routineData.routineUnitData().unit()) + " leaves house.")
			call SetUnitFacing(routineData.routineUnitData().unit(), GetUnitFacing(routineData.routineUnitData().unit()) - 180.0) // turn around
			call ShowUnit(routineData.routineUnitData().unit(), true)
		endmethod

		private static method hammerEndAction takes ARoutineData routineData returns nothing
			//debug call Print("Reset hammer animation.")
			call ResetUnitAnimation(routineData.routineUnitData().unit())
		endmethod

		/// Animation of villager.
		private static method hammerTargetAction takes ARoutineData routineData returns nothing
			call QueueUnitAnimation(routineData.routineUnitData().unit(), "Attack")
			call PlaySoundFileOnUnit("Buildings\\Human\\Blacksmith\\BlacksmithWhat1.wav", routineData.routineUnitData().unit())
			call TriggerSleepAction(1.0)
			call AContinueRoutineLoop(routineData, thistype.hammerTargetAction)
		endmethod

		private static method talkEndAction takes ARoutineData routineData returns nothing
			call ResetUnitAnimation(routineData.routineUnitData().unit())
		endmethod

		private static method talkFilter takes nothing returns boolean
			return GetOwningPlayer(GetEnumUnit()) == Player(PLAYER_NEUTRAL_PASSIVE) and not IsUnitPaused(GetEnumUnit())
		endmethod

		private static method talkTargetAction takes ARoutineData routineData returns nothing
			local group whichGroup = CreateGroup()
			local unit whichUnit = null
			//debug call Print("Talk target action.")
			call GroupEnumUnitsInRange(whichGroup, GetUnitX(routineData.routineUnitData().unit()), GetUnitY(routineData.routineUnitData().unit()), 400.0, Filter(function thistype.talkFilter))
			//debug call Print("Talk: Found " + I2S(CountUnitsInGroup(whichGroup)) + " possible partners.")
			set whichUnit = FindClosestUnit(whichGroup, GetUnitX(routineData.routineUnitData().unit()), GetUnitY(routineData.routineUnitData().unit()))
			//debug call Print(GetUnitName(whichUnit) + " is the closest partner.")

			if (whichUnit != null) then
				call SetUnitFacingToFaceUnit(routineData.routineUnitData().unit(), whichUnit)
				call QueueUnitAnimation(routineData.routineUnitData().unit(), "Stand Talk")
				debug call Print("Talking to.")
			endif
			call DestroyGroup(whichGroup)
			set whichGroup = null
			call TriggerSleepAction(1.0)
			call AContinueRoutineLoop(routineData, thistype.talkTargetAction)
		endmethod

		private static method drinkEndAction takes ARoutineData routineData returns nothing
			call ResetUnitAnimation(routineData.routineUnitData().unit())
		endmethod

		/// @todo FIXME
		private static method drinkTargetAction takes ARoutineData routineData returns nothing
			call QueueUnitAnimation(routineData.routineUnitData().unit(), "Stand")
			call TriggerSleepAction(1.0)
			call AContinueRoutineLoop(routineData, thistype.drinkTargetAction)
		endmethod

		private static method harvestEndAction takes ARoutineData routineData returns nothing
			call ResetUnitAnimation(routineData.routineUnitData().unit())
		endmethod

		private static method harvestTargetAction takes ARoutineData routineData returns nothing
			call QueueUnitAnimation(routineData.routineUnitData().unit(), "Stand Work")
			call TriggerSleepAction(1.266)
			call AContinueRoutineLoop(routineData, thistype.harvestTargetAction)
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