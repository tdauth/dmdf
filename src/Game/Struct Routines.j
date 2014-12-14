library StructGameRoutines requires Asl

	struct NpcRoutineWithFacing extends AUnitRoutine
		private real m_facing = 0.0

		public method setFacing takes real facing returns nothing
			set this.m_facing = facing
		endmethod

		public method facing takes nothing returns real
			return this.m_facing
		endmethod
	endstruct

	struct NpcLeavesHouseRoutine extends NpcRoutineWithFacing
	endstruct

	struct NpcRoutineWithOtherNpc extends AUnitRoutine
		private unit m_partner = null

		public method setPartner takes unit partner returns nothing
			set this.m_partner = partner
		endmethod

		public method partner takes nothing returns unit
			return this.m_partner
		endmethod
	endstruct

	struct NpcTalksRoutine extends NpcRoutineWithOtherNpc
		public static constant integer maxSounds = 4
		private real m_range = 800.0
		private sound array m_sounds[thistype.maxSounds]
		private integer m_soundsCount = 0

		public method setRange takes real range returns nothing
			set this.m_range = range
		endmethod

		public method range takes nothing returns real
			return this.m_range
		endmethod

		public method soundsCount takes nothing returns integer
			return this.m_soundsCount
		endmethod

		public method addSound takes sound whichSound returns nothing
			if (this.soundsCount() >= thistype.maxSounds) then
				return
			endif
			set this.m_sounds[this.soundsCount()] = whichSound
			set this.m_soundsCount = this.soundsCount() + 1
		endmethod

		public method sound takes integer index returns sound
			return this.m_sounds[index]
		endmethod
	endstruct

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
		private static ARoutine m_splitWood
		private static ARoutine m_sleep

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method moveToTargetAction takes NpcRoutineWithFacing period returns nothing
			//debug call Print("Unit " + GetUnitName(period.unit()) + " gets new facing in target.")
			call IssueImmediateOrder(period.unit(), "stop")
			call SetUnitFacing(period.unit(), period.facing())
		endmethod

		private static method trainEndAction takes ARoutinePeriod period returns nothing
			call ResetUnitAnimation(period.unit())
		endmethod

		/// @todo Should check whether the unit has animation
		private static method trainTargetAction takes NpcRoutineWithFacing period returns nothing
			local integer index = GetRandomInt(0, thistype.m_trainAnimations.backIndex())
			call SetUnitFacing(period.unit(), period.facing())
			call QueueUnitAnimation(period.unit(), thistype.m_trainAnimations[index])
			call TriggerSleepAction(2.0)
			call AContinueRoutineLoop(period, thistype.trainTargetAction)
		endmethod

		private static method enterHouseTargetAction takes ARoutinePeriod period returns nothing
			//debug call Print("Unit " + GetUnitName(period.unit()) + " enters house.")
			call ShowUnit(period.unit(), false)
			//debug call Print("After entering house")
			//debug if (IsUnitHidden(period.unit())) then
			//debug call Print("It is hidden")
			//debug else
			//debug call Print("It is not hidden")
			//debug endif
		endmethod

		private static method leaveHouseCondition takes NpcLeavesHouseRoutine period returns boolean
			return IsUnitHidden(period.unit()) // only leave if had entered - first leave routine is therefore wrong when NPCs aren't placed in their houses at the beginning of game
		endmethod

		private static method leaveHouseTargetAction takes NpcLeavesHouseRoutine period returns nothing
			//debug call Print("Unit " + GetUnitName(period.unit()) + " leaves house.")
			call SetUnitFacing(period.unit(), period.facing()) // turn around
			call ShowUnit(period.unit(), true)
		endmethod

		private static method hammerEndAction takes ARoutinePeriod period returns nothing
			//debug call Print("Reset hammer animation.")
			call ResetUnitAnimation(period.unit())
		endmethod

		/// Animation of villager.
		private static method hammerTargetAction takes NpcRoutineWithFacing period returns nothing
			call SetUnitFacing(period.unit(), period.facing())
			call QueueUnitAnimation(period.unit(), "Attack")
			call PlaySoundFileOnUnit("Buildings\\Human\\Blacksmith\\BlacksmithWhat1.wav", period.unit())
			call TriggerSleepAction(1.0)
			call AContinueRoutineLoop(period, thistype.hammerTargetAction)
		endmethod

		private static method talkEndAction takes ARoutinePeriod period returns nothing
			call ResetUnitAnimation(period.unit())
		endmethod

		private static method talkTargetAction takes NpcTalksRoutine period returns nothing
			local sound whichSound = null
			local real time = 5.0 // usual wait interval

			if (period.partner() != null and GetDistanceBetweenUnitsWithoutZ(period.unit(), period.partner()) <= period.range() and not IsUnitPaused(period.partner())) then
				debug call Print(GetUnitName(period.unit()) + " has in range " + GetUnitName(period.partner()) + " to talk.")
				call SetUnitFacingToFaceUnit(period.unit(), period.partner())
				call QueueUnitAnimation(period.unit(), "Stand Talk")
				if (period.soundsCount() > 0) then
					set whichSound = period.sound(GetRandomInt(0, period.soundsCount() - 1))
					call PlaySoundOnUnitBJ(whichSound, 100.0, period.unit())
					set time = GetSoundDurationBJ(whichSound) + 1.0
				endif

				// NOTE don't check during this time (if sound is played) if partner is being paused in still in range, just talk to the end and continue if he/she is still range!
			endif

			call TriggerSleepAction(time)
			call AContinueRoutineLoop(period, thistype.talkTargetAction)
		endmethod

		private static method drinkEndAction takes ARoutinePeriod period returns nothing
			call ResetUnitAnimation(period.unit())
		endmethod

		/// @todo FIXME
		private static method drinkTargetAction takes NpcRoutineWithFacing period returns nothing
			call SetUnitFacing(period.unit(), period.facing())
			call QueueUnitAnimation(period.unit(), "Stand")
			call TriggerSleepAction(1.0)
			call AContinueRoutineLoop(period, thistype.drinkTargetAction)
		endmethod

		private static method harvestEndAction takes NpcRoutineWithFacing period returns nothing
			call ResetUnitAnimation(period.unit())
		endmethod

		private static method harvestTargetAction takes NpcRoutineWithFacing period returns nothing
			call SetUnitFacing(period.unit(), period.facing())
			call QueueUnitAnimation(period.unit(), "Stand Work")
			call TriggerSleepAction(1.266)
			call AContinueRoutineLoop(period, thistype.harvestTargetAction)
		endmethod

		private static method splitWoodEndAction takes NpcRoutineWithFacing period returns nothing
			call ResetUnitAnimation(period.unit())
		endmethod

		private static method splitWoodTargetAction takes NpcRoutineWithFacing period returns nothing
			call SetUnitFacing(period.unit(), period.facing())
			call QueueUnitAnimation(period.unit(), "Stand Work")
			call TriggerSleepAction(1.266)
			call AContinueRoutineLoop(period, thistype.splitWoodTargetAction)
		endmethod

		private static method sleepEndAction takes NpcRoutineWithFacing period returns nothing
			call ResetUnitAnimation(period.unit())
		endmethod

		private static method sleepTargetAction takes NpcRoutineWithFacing period returns nothing
			call SetUnitFacing(period.unit(), period.facing())
			call QueueUnitAnimation(period.unit(), "Death")
			call TriggerSleepAction(1.266)
			call AContinueRoutineLoop(period, thistype.sleepTargetAction)
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_moveTo = ARoutine.create(true, true, 0, 0, 0, thistype.moveToTargetAction) // NOTE second true means loop that it returns to the position.
			set thistype.m_trainAnimations = AStringVector.create()
			call thistype.m_trainAnimations.pushBack("Attack 1")
			call thistype.m_trainAnimations.pushBack("Attack 2")
			call thistype.m_trainAnimations.pushBack("Attack 3")
			set thistype.m_train = ARoutine.create(true, true, 0, 0, thistype.trainEndAction, thistype.trainTargetAction)
			set thistype.m_enterHouse = ARoutine.create(true, false, 0, 0, 0, thistype.enterHouseTargetAction)
			set thistype.m_leaveHouse = ARoutine.create(true, false, thistype.leaveHouseCondition, 0, 0, thistype.leaveHouseTargetAction)
			set thistype.m_hammer = ARoutine.create(true, true, 0, 0, thistype.hammerEndAction, thistype.hammerTargetAction)
			set thistype.m_talk = ARoutine.create(true, true, 0, 0, thistype.talkEndAction, thistype.talkTargetAction)
			set thistype.m_drink = ARoutine.create(true, true, 0, 0, thistype.drinkEndAction, thistype.drinkTargetAction)
			set thistype.m_harvest = ARoutine.create(true, true, 0, 0, thistype.harvestEndAction, thistype.harvestTargetAction)
			set thistype.m_splitWood = ARoutine.create(true, true, 0, 0, thistype.splitWoodEndAction, thistype.splitWoodTargetAction)
			set thistype.m_sleep = ARoutine.create(true, true, 0, 0, thistype.sleepEndAction, thistype.sleepTargetAction)
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

		public static method splitWood takes nothing returns ARoutine
			return thistype.m_splitWood
		endmethod

		public static method sleep takes nothing returns ARoutine
			return thistype.m_sleep
		endmethod
	endstruct

endlibrary