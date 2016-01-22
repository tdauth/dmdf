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
	
	struct NpcHammerRoutine extends NpcRoutineWithFacing
		private sound m_sound
		private real m_soundVolume = 100.0
		
		public method setSound takes sound whichSound returns nothing
			set this.m_sound = whichSound
		endmethod
		
		public method sound takes nothing returns sound
			return this.m_sound
		endmethod
		
		public method setSoundVolume takes real soundVolume returns nothing
			set this.m_soundVolume = soundVolume
		endmethod
		
		public method soundVolume takes nothing returns real
			return this.m_soundVolume
		endmethod
	endstruct
	
	struct NpcEntersHouseRoutine extends AUnitRoutine
		private boolean m_hasChooseHero = false
		
		public method setHasChooseHero takes boolean hasChooseHero returns nothing
			set this.m_hasChooseHero = hasChooseHero
		endmethod
		
		public method hasChooseHero takes nothing returns boolean
			return this.m_hasChooseHero
		endmethod
	endstruct

	struct NpcLeavesHouseRoutine extends NpcRoutineWithFacing
		private boolean m_hasChooseHero = false
		
		public method setHasChooseHero takes boolean hasChooseHero returns nothing
			set this.m_hasChooseHero = hasChooseHero
		endmethod
		
		public method hasChooseHero takes nothing returns boolean
			return this.m_hasChooseHero
		endmethod
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
		private string array m_soundTexts[thistype.maxSounds]
		private integer m_soundsCount = 0
		private real m_facing = 0.0

		public method setFacing takes real facing returns nothing
			set this.m_facing = facing
		endmethod

		public method facing takes nothing returns real
			return this.m_facing
		endmethod

		public method setRange takes real range returns nothing
			set this.m_range = range
		endmethod

		public method range takes nothing returns real
			return this.m_range
		endmethod

		public method soundsCount takes nothing returns integer
			return this.m_soundsCount
		endmethod

		public method addSound takes string text, sound whichSound returns nothing
			if (this.soundsCount() >= thistype.maxSounds) then
				return
			endif
			set this.m_sounds[this.soundsCount()] = whichSound
			set this.m_soundTexts[this.soundsCount()] = text
			set this.m_soundsCount = this.soundsCount() + 1
		endmethod
		
		public method text takes integer index returns string
			return this.m_soundTexts[index]
		endmethod

		public method sound takes integer index returns sound
			return this.m_sounds[index]
		endmethod
	endstruct

	/**
	 * \brief Static class which contains all routines of the game.
	 * These routines can be used for specific NPCs and provide abstract routine actions like talking or training.
	 */
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
		private static ATextTagVector m_textTags

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

		private static method enterHouseTargetAction takes NpcEntersHouseRoutine period returns nothing
			//debug call Print("Unit " + GetUnitName(period.unit()) + " enters house.")
			call ShowUnit(period.unit(), false)
			if (period.hasChooseHero()) then
				call UnitRemoveAbility(period.unit(), 'Aneu')
			endif
			// TODO disable trading ability/hero selection
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
			if (period.hasChooseHero()) then
				call UnitAddAbility(period.unit(), 'Aneu')
			endif
			// TODO enable trading ability/hero selection
		endmethod

		private static method hammerEndAction takes ARoutinePeriod period returns nothing
			//debug call Print("Reset hammer animation.")
			call ResetUnitAnimation(period.unit())
		endmethod

		/// Animation of villager.
		private static method hammerTargetAction takes NpcHammerRoutine period returns nothing
			call SetUnitFacing(period.unit(), period.facing())
			call QueueUnitAnimation(period.unit(), "Attack")
			call PlaySoundOnUnitBJ(period.sound(), period.soundVolume(), period.unit())
			call TriggerSleepAction(1.0)
			call AContinueRoutineLoop(period, thistype.hammerTargetAction)
		endmethod

		private static method talkEndAction takes ARoutinePeriod period returns nothing
			call ResetUnitAnimation(period.unit())
		endmethod

		private static method talkTargetAction takes NpcTalksRoutine period returns nothing
			local sound whichSound = null
			local texttag whichTextTag = null
			local boolean isVisibleAndInRange
			local integer index
			local integer i
			
			if (period.partner() != null and GetDistanceBetweenUnitsWithoutZ(period.unit(), period.partner()) <= period.range() and not IsUnitPaused(period.partner())) then
				//debug call Print(GetUnitName(period.unit()) + " has in range " + GetUnitName(period.partner()) + " to talk.")
				call SetUnitFacingToFaceUnit(period.unit(), period.partner())
				call QueueUnitAnimation(period.unit(), "Stand Talk")
				set index = GetRandomInt(0, period.soundsCount() - 1)
				if (period.soundsCount() > 0) then
					set whichSound = period.sound(index)
					
					set i = 0
					loop
						exitwhen (i == MapData.maxPlayers)
						// don't play the sound in talk, otherwise it becomes annoying when listening to another NPC
						if (ACharacter.playerCharacter(Player(i)) != 0 and ACharacter.playerCharacter(Player(i)).talk() == 0 and GetDistanceBetweenUnitsWithoutZ(period.unit(), ACharacter.playerCharacter(Player(i)).unit()) <= 1000.0 and not IsUnitMasked(period.unit(), Player(i)) and Player(i) == GetLocalPlayer()) then
							call PlaySoundOnUnitBJ(whichSound, 100.0, period.unit())
						endif
						set i = i + 1
					endloop
				endif
				
				set whichTextTag = CreateTextTag()
				call SetTextTagTextBJ(whichTextTag, period.text(index), 10.0)
				call SetTextTagPosUnit(whichTextTag, period.unit(),  0.0)
				call SetTextTagColor(whichTextTag, 255, 255, 255, 0)
				call SetTextTagVisibility(whichTextTag, false)
				call SetTextTagPermanent(whichTextTag, true)
				
				/*
				 * Only show the text tag if the unit is not masked. Otherwise it will appear at a masked unit.
				 */
				set i = 0
				loop
					exitwhen (i == MapData.maxPlayers)
					if (ACharacter.playerCharacter(Player(i)) != 0 and GetDistanceBetweenUnitsWithoutZ(period.unit(), ACharacter.playerCharacter(Player(i)).unit()) <= 1000.0 and not IsUnitMasked(period.unit(), Player(i))) then
						call ShowTextTagForPlayer(Player(i), whichTextTag, true)
					endif
					set i = i + 1
				endloop
				
				call thistype.m_textTags.pushBack(whichTextTag)

				// NOTE don't check during this time (if sound is played) if partner is being paused in still in range, just talk to the end and continue if he/she is still range!
				call TriggerSleepAction(GetSoundDurationBJ(whichSound))
				
				//call StopSoundBJ(whichSound, false)
				// TODO A set would be more efficient.
				if (thistype.m_textTags.contains(whichTextTag)) then
					call thistype.m_textTags.remove(whichTextTag)
					call DestroyTextTag(whichTextTag)
					set whichTextTag = null
				endif
				
				call TriggerSleepAction(6.0) // set + 6 otherwise we have loop sounds all the time
			else
				// set at least facing properly
				call SetUnitFacing(period.unit(), period.facing())
				// set a smaller interval to check the condition faster.
				
				call TriggerSleepAction(2.0)
			endif

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
			call PlaySoundFileOnUnit("Abilities\\Spells\\Other\\Repair\\PeonRepair1.wav", period.unit())
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
			set thistype.m_textTags = ATextTagVector.create()
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
		
		private static method forEachDestroyTextTag takes texttag whichTextTag returns nothing
			call DestroyTextTag(whichTextTag)
		endmethod
		
		public static method destroyTextTags takes nothing returns nothing
			call thistype.m_textTags.forEach(thistype.forEachDestroyTextTag)
			call thistype.m_textTags.clear()
		endmethod
	endstruct

endlibrary