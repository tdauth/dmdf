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

	// Inherits NpcRoutineWithFacing if no partner is used or if the partner is not available a facing can still be set.
	struct NpcRoutineWithOtherNpc extends NpcRoutineWithFacing
		private unit m_partner = null

		public method setPartner takes unit partner returns nothing
			set this.m_partner = partner
		endmethod

		public method partner takes nothing returns unit
			return this.m_partner
		endmethod
	endstruct

	/**
	 * \brief Basic routine type for talks between two NPCs.
	 * The text is shown as floating texttag on the speaking unit and a corresponding sound is played.
	 */
	struct NpcTalksRoutine extends NpcRoutineWithOtherNpc
		public static constant integer maxSounds = 4
		private real m_range = 800.0
		private sound array m_sounds[thistype.maxSounds]
		private string array m_soundTexts[thistype.maxSounds]
		private integer m_soundsCount = 0
		/// Answer sounds are optional and can be used as answers of the talk partners.
		private sound array m_answerSounds[thistype.maxSounds]
		private string array m_answerSoundTexts[thistype.maxSounds]
		private integer m_answerSoundsCount = 0

		public method setRange takes real range returns nothing
			set this.m_range = range
		endmethod

		public method range takes nothing returns real
			return this.m_range
		endmethod

		public method soundsCount takes nothing returns integer
			return this.m_soundsCount
		endmethod

		public method answerSoundsCount takes nothing returns integer
			return this.m_answerSoundsCount
		endmethod

		public method addSound takes string text, sound whichSound returns nothing
			if (this.soundsCount() >= thistype.maxSounds) then
				return
			endif
			set this.m_sounds[this.soundsCount()] = whichSound
			set this.m_soundTexts[this.soundsCount()] = text
			set this.m_soundsCount = this.soundsCount() + 1
		endmethod

		public method addSoundAnswer takes string text, sound whichSound returns nothing
			if (this.answerSoundsCount() >= thistype.maxSounds) then
				return
			endif
			set this.m_answerSounds[this.answerSoundsCount()] = whichSound
			set this.m_answerSoundTexts[this.answerSoundsCount()] = text
			set this.m_answerSoundsCount = this.answerSoundsCount() + 1
		endmethod

		public method text takes integer index returns string
			return this.m_soundTexts[index]
		endmethod

		public method sound takes integer index returns sound
			return this.m_sounds[index]
		endmethod

		public method answerText takes integer index returns string
			return this.m_answerSoundTexts[index]
		endmethod

		public method answerSound takes integer index returns sound
			return this.m_answerSounds[index]
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
		private static ARoutine m_harvest
		private static ARoutine m_splitWood
		private static ARoutine m_sleep
		private static ATextTagVector m_textTags
		private static ASoundList m_sounds

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod

		private static method moveToTargetAction takes NpcRoutineWithFacing period returns nothing
			//debug call Print("Unit " + GetUnitName(period.unit()) + " gets new facing in target.")
			call IssueImmediateOrder(period.unit(), "stop")
			call TriggerSleepAction(0.0) // sometimes the facing is not applied
			call SetUnitFacing(period.unit(), period.facing())
		endmethod

		private static method trainEndAction takes ARoutinePeriod period returns nothing
			call ResetUnitAnimation(period.unit())
		endmethod

		private static method trainTargetAction takes NpcRoutineWithFacing period returns nothing
			local integer index = GetRandomInt(0, thistype.m_trainAnimations.backIndex())
			call SetUnitFacing(period.unit(), period.facing())
			call QueueUnitAnimation(period.unit(), thistype.m_trainAnimations[index])
			call TriggerSleepAction(2.0)
			call AContinueRoutineLoop(period, thistype.trainTargetAction)
		endmethod

		private static method enterHouseTargetAction takes NpcEntersHouseRoutine period returns nothing
			call ShowUnit(period.unit(), false)
			if (period.hasChooseHero()) then
				call UnitRemoveAbility(period.unit(), 'Aneu')
			endif
			// TODO disable trading ability/hero selection
		endmethod

		private static method leaveHouseCondition takes NpcLeavesHouseRoutine period returns boolean
			return IsUnitHidden(period.unit()) // only leave if had entered - first leave routine is therefore wrong when NPCs aren't placed in their houses at the beginning of game
		endmethod

		private static method leaveHouseTargetAction takes NpcLeavesHouseRoutine period returns nothing
			call SetUnitFacing(period.unit(), period.facing()) // turn around
			call ShowUnit(period.unit(), true)
			if (period.hasChooseHero()) then
				call UnitAddAbility(period.unit(), 'Aneu')
			endif
			// TODO enable trading ability/hero selection
		endmethod

		private static method hammerEndAction takes ARoutinePeriod period returns nothing
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

		/**
		 * Let a unit talk to another unit by using a sound and a floating texttag.
		 * The sound is only played and the texttag does only appear to players who have their characters in range and to whom the area is not masked.
		 */
		private static method unitTalks takes unit speaking, unit listening, sound whichSound, string text returns nothing
			local texttag whichTextTag = null
			local integer i = 0
			// talks can have answers by the other NPC
			if (not IsUnitPaused(speaking)) then
				set whichTextTag = CreateTextTag()
				call SetTextTagTextBJ(whichTextTag, text, 10.0)
				call SetTextTagPosUnit(whichTextTag, speaking,  0.0)
				call SetTextTagColor(whichTextTag, 255, 255, 255, 0)
				call SetTextTagVisibility(whichTextTag, false)
				call SetTextTagPermanent(whichTextTag, true)

				set i = 0
				loop
					exitwhen (i == MapData.maxPlayers)
					// don't play the sound in talk, otherwise it becomes annoying when listening to another NPC
					if (ACharacter.playerCharacter(Player(i)) != 0 and ACharacter.playerCharacter(Player(i)).talk() == 0 and GetDistanceBetweenUnitsWithoutZ(speaking, ACharacter.playerCharacter(Player(i)).unit()) <= 1000.0 and not IsUnitMasked(speaking, Player(i)) and (not IsUnitFogged(speaking, Player(i)) or (not IsUnitFogged(listening, Player(i)) and listening != null)) and Player(i) == GetLocalPlayer() and GetDistanceBetweenPointsWithoutZ(GetCameraTargetPositionX(), GetCameraTargetPositionY(), GetUnitX(speaking), GetUnitY(speaking)) <= 1000.0) then
						call PlaySoundOnUnitBJ(whichSound, 60.0, speaking) // TODO sound is not always 3D? Distance should play a role (distance between unit and player's current camera view)
						call ShowTextTagForPlayer(Player(i), whichTextTag, true)
					endif
					set i = i + 1
				endloop

				call thistype.m_textTags.pushBack(whichTextTag)
				call thistype.m_sounds.pushBack(whichSound)

				// NOTE don't check during this time (if sound is played) if partner is being paused in still in range, just talk to the end and continue if he/she is still range!
				call TriggerSleepAction(GetSoundDurationBJ(whichSound))

				//call StopSoundBJ(whichSound, false)
				// TODO A set would be more efficient.
				if (thistype.m_textTags.contains(whichTextTag)) then
					call thistype.m_textTags.remove(whichTextTag)
					call DestroyTextTag(whichTextTag)
					set whichTextTag = null
				endif

				if (thistype.m_sounds.contains(whichSound)) then
					call thistype.m_sounds.remove(whichSound)
				endif
			endif
		endmethod

		private static method talkTargetAction takes NpcTalksRoutine period returns nothing
			local integer index = 0

			if ((period.partner() != null and GetDistanceBetweenUnitsWithoutZ(period.unit(), period.partner()) <= period.range() and not IsUnitPaused(period.partner())) or (period.partner() == null)) then
				//debug call Print(GetUnitName(period.unit()) + " has in range " + GetUnitName(period.partner()) + " to talk.")
				if (period.partner() != null) then
					call SetUnitFacingToFaceUnit(period.unit(), period.partner())
				else
					call SetUnitFacing(period.unit(), period.facing())
				endif
				call QueueUnitAnimation(period.unit(), "Stand Talk")
				set index = GetRandomInt(0, period.soundsCount() - 1)
				if (period.soundsCount() > index) then
					call thistype.unitTalks(period.unit(), period.partner(), period.sound(index), period.text(index))

					// talks can have answers by the other NPC
					if (period.answerSoundsCount() > index) then
						call thistype.unitTalks(period.partner(), period.unit(), period.answerSound(index), period.answerText(index))
					endif
				endif

				call TriggerSleepAction(4.0) // set + 4 otherwise we have loop sounds all the time
			else
				// set at least facing properly
				call SetUnitFacing(period.unit(), period.facing())
				// set a smaller interval to check the condition faster.

				call TriggerSleepAction(2.0)
			endif

			call AContinueRoutineLoop(period, thistype.talkTargetAction)
		endmethod

		private static method harvestEndAction takes NpcRoutineWithFacing period returns nothing
			call ResetUnitAnimation(period.unit())
		endmethod

		private static method harvestTargetAction takes NpcRoutineWithFacing period returns nothing
			call SetUnitFacing(period.unit(), period.facing())
			call QueueUnitAnimation(period.unit(), "Stand Work")
			call TriggerSleepAction(1.266)
			call PlaySoundFileOnUnit("Abilities\\Spells\\Other\\Repair\\PeonRepair1.wav", period.unit())
			call AContinueRoutineLoop(period, thistype.harvestTargetAction)
		endmethod

		private static method splitWoodEndAction takes NpcRoutineWithFacing period returns nothing
			call ResetUnitAnimation(period.unit())
		endmethod

		private static method splitWoodTargetAction takes NpcRoutineWithFacing period returns nothing
			call SetUnitFacing(period.unit(), period.facing())
			call QueueUnitAnimation(period.unit(), "Stand Work")
			call TriggerSleepAction(1.266)
			call PlaySoundFileOnUnit("Abilities\\Spells\\Other\\Repair\\PeonRepair1.wav", period.unit())
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
			set thistype.m_harvest = ARoutine.create(true, true, 0, 0, thistype.harvestEndAction, thistype.harvestTargetAction)
			set thistype.m_splitWood = ARoutine.create(true, true, 0, 0, thistype.splitWoodEndAction, thistype.splitWoodTargetAction)
			set thistype.m_sleep = ARoutine.create(true, true, 0, 0, thistype.sleepEndAction, thistype.sleepTargetAction)
			set thistype.m_textTags = ATextTagList.create()
			set thistype.m_sounds = ASoundList.create()
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

		private static method forEachStopSound takes sound whichSound returns nothing
			call StopSoundBJ(whichSound, false)
		endmethod

		public static method stopSounds takes nothing returns nothing
			call thistype.m_sounds.forEach(thistype.forEachStopSound)
			call thistype.m_sounds.clear()
		endmethod

		public static method stopSoundsForPlayer takes player whichPlayer returns nothing
			local ASoundListIterator iterator = thistype.m_sounds.begin()
			loop
				exitwhen (not iterator.isValid())
				if (GetLocalPlayer() == whichPlayer) then
					call StopSoundBJ(iterator.data(), false)
				endif
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		public static method hideTexttagsForPlayer takes player whichPlayer returns nothing
			local ATextTagListIterator iterator = thistype.m_textTags.begin()
			loop
				exitwhen (not iterator.isValid())
				call ShowTextTagForPlayer(whichPlayer, iterator.data(), false)
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod
	endstruct

endlibrary